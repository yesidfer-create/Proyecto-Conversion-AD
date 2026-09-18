function interfazADC()

%% ============================================================
% INTERFAZ ADC - VERSION 6
% Diseño compacto
% ============================================================


clc;


%% Variables internas

resultadoActual = [];

archivoAudioActual = [];



%% ============================================================
% VENTANA PRINCIPAL
% ============================================================


fig = figure(...
    'Name','Proyecto Conversion A/D',...
    'NumberTitle','off',...
    'Position',[450 150 520 650],...
    'MenuBar','none',...
    'Resize','off');



%% ============================================================
% TITULO
% ============================================================


uicontrol(fig,...
    'Style','text',...
    'String','PROYECTO CONVERSION A/D',...
    'FontSize',14,...
    'FontWeight','bold',...
    'Position',[90 570 340 35]);




%% ============================================================
% SELECCION DE SENAL
% ============================================================


uicontrol(fig,...
    'Style','text',...
    'String','Seleccionar senal:',...
    'Position',[40 535 130 25],...
    'HorizontalAlignment','left');


popupSenal = uicontrol(fig,...
    'Style','popupmenu',...
    'String',{'A','B','C','D'},...
    'Position',[180 535 80 30],...
    'Callback',@cambioSenal);



%% BOTON CARGAR AUDIO


uicontrol(fig,...
    'Style','pushbutton',...
    'String','CARGAR AUDIO',...
    'Position',[320 535 120 30],...
    'Callback',@cargarAudio);



%% ============================================================
% INFORMACION SENAL
% ============================================================


infoSenalTexto = uicontrol(fig,...
    'Style','text',...
    'String','Informacion senal',...
    'Position',[40 455 400 65],...
    'HorizontalAlignment','left',...
    'FontSize',10);



%% ============================================================
% PARAMETROS ADC
% ============================================================


uicontrol(fig,...
    'Style','text',...
    'String','Fs [Hz]:',...
    'Position',[40 400 80 25],...
    'HorizontalAlignment','left');


editFs = uicontrol(fig,...
    'Style','edit',...
    'String','1000',...
    'Position',[110 400 90 30]);



uicontrol(fig,...
    'Style','text',...
    'String','Niveles:',...
    'Position',[270 400 70 25],...
    'HorizontalAlignment','left');


editN = uicontrol(fig,...
    'Style','edit',...
    'String','256',...
    'Position',[350 400 90 30]);



%% ============================================================
% INFORMACION AUDIO
% ============================================================


infoAudioTexto = uicontrol(fig,...
    'Style','text',...
    'String','Audio: no cargado',...
    'Position',[40 350 400 35],...
    'HorizontalAlignment','left');



%% ============================================================
% BOTON PROCESAR
% ============================================================


uicontrol(fig,...
    'Style','pushbutton',...
    'String','PROCESAR ADC',...
    'FontWeight','bold',...
    'Position',[150 300 220 40],...
    'Callback',@procesar);



%% ============================================================
% BOTONES DE ACCION
% ============================================================


uicontrol(fig,...
    'Style','pushbutton',...
    'String','MOSTRAR GRAFICAS',...
    'Position',[40 240 140 40],...
    'Callback',@mostrarGraficas);



uicontrol(fig,...
    'Style','pushbutton',...
    'String','AUDIO ORIGINAL',...
    'Position',[190 240 130 40],...
    'Callback',@reproducirOriginal);



uicontrol(fig,...
    'Style','pushbutton',...
    'String','AUDIO RECONSTRUIDO',...
    'Position',[330 240 150 40],...
    'Callback',@reproducirReconstruido);



%% ============================================================
% RESULTADOS
% ============================================================


resultadoTexto = uicontrol(fig,...
    'Style','text',...
    'String','Resultados apareceran aqui',...
    'FontSize',10,...
    'Position',[40 40 440 160],...
    'HorizontalAlignment','left');



%% Mostrar informacion inicial

actualizarInformacionSenal();

%% ============================================================
% ACTUALIZAR INFORMACION DE SENAL
% ============================================================


function actualizarInformacionSenal(~,~)


    opciones = {'A','B','C','D'};

    tipo = opciones{popupSenal.Value};



    switch tipo


        case 'A'

            texto = sprintf([...
                'Tipo: Senal A\n',...
                'Descripcion: A*cos(2*pi*f0*t)\n',...
                'Frecuencia maxima: 5 Hz']);



        case 'B'

            texto = sprintf([...
                'Tipo: Senal B\n',...
                'Descripcion: sinc(2*a*t)\n',...
                'Frecuencia maxima: 50 Hz']);



        case 'C'

            texto = sprintf([...
                'Tipo: Senal C\n',...
                'Descripcion: sinc^2(a*t)+sinc(2*a*t)\n',...
                'Frecuencia maxima: 50 Hz']);



        case 'D'

            texto = sprintf([...
                'Tipo: Audio WAV\n',...
                'Descripcion: archivo externo']);

    end



    infoSenalTexto.String = texto;


end




%% ============================================================
% CAMBIO DE SENAL
% ============================================================


function cambioSenal(~,~)


    opciones = {'A','B','C','D'};

    tipo = opciones{popupSenal.Value};



    if tipo == "D"


        editFs.String = '22050';

        editN.String = '16';


    else


        editFs.String = '1000';

        editN.String = '256';


    end



    actualizarInformacionSenal();


end




%% ============================================================
% CARGAR AUDIO
% ============================================================


function cargarAudio(~,~)


    [archivo,ruta] = uigetfile('*.wav',...
        'Seleccione archivo WAV');



    if isequal(archivo,0)

        return;

    end



    archivoAudioActual = fullfile(ruta,archivo);



    [audio,FsAudio] = audioread(archivoAudioActual);



    if size(audio,2)>1

        audio = mean(audio,2);

    end



    duracion = length(audio)/FsAudio;



    infoAudioTexto.String = sprintf([...
        'Archivo: %s\n',...
        'Fs original: %.0f Hz | Duracion: %.2f s'],...
        archivo,...
        FsAudio,...
        duracion);



end




%% ============================================================
% PROCESAR ADC
% ============================================================


function procesar(~,~)


    opciones = {'A','B','C','D'};

    tipo = opciones{popupSenal.Value};



    Fs = str2double(editFs.String);

    N = str2double(editN.String);



    if isnan(Fs) || Fs<=0


        msgbox('Fs no valido');

        return;


    end



    if isnan(N) || mod(log2(N),1)~=0


        msgbox('N debe ser potencia de 2');

        return;


    end




    try


        if tipo=="D"


            if isempty(archivoAudioActual)


                msgbox('Cargue primero un audio');

                return;


            end



            resultadoActual = procesarADC(...
                tipo,Fs,N,archivoAudioActual);



        else


            resultadoActual = procesarADC(...
                tipo,Fs,N);



        end




        Ts = 1/Fs;



        resultadoTexto.String = sprintf([...
            'Senal: %s\n\n',...
            'Fs = %.2f Hz\n',...
            'Ts = %.8f s\n',...
            'Niveles = %d\n\n',...
            'MSE = %.10f\n',...
            'SNR = %.4f dB\n',...
            'Error espectral = %.10f'],...
            resultadoActual.info.nombre,...
            Fs,...
            Ts,...
            N,...
            resultadoActual.MSE,...
            resultadoActual.SNR,...
            resultadoActual.errorRelativo);



    catch error


        resultadoTexto.String = ...
            ['ERROR: ',error.message];


    end


end




%% ============================================================
% MOSTRAR GRAFICAS
% ============================================================


function mostrarGraficas(~,~)


    if isempty(resultadoActual)


        msgbox('Primero procese');

        return;


    end



    if resultadoActual.tipo ~= "D"


        generarGraficas(resultadoActual);



    else


        msgbox('Audio procesado correctamente');



    end


end




%% ============================================================
% AUDIO ORIGINAL
% ============================================================


function reproducirOriginal(~,~)


    if isempty(resultadoActual)

        msgbox('Primero procese');

        return;

    end



    if resultadoActual.tipo=="D"


        sound(resultadoActual.senalOriginal,...
            resultadoActual.info.FsAudio);


    end


end




%% ============================================================
% AUDIO RECONSTRUIDO
% ============================================================


function reproducirReconstruido(~,~)


    if isempty(resultadoActual)

        msgbox('Primero procese');

        return;

    end



    if resultadoActual.tipo=="D"


        sound(resultadoActual.senalReconstruida,...
            resultadoActual.Fs);


    end


end



end