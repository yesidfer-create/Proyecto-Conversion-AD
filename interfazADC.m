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
% TABLAS SOLICITADAS EN LA SUSTENTACION
% ============================================================

uicontrol(fig,...
    'Style','pushbutton',...
    'String','TABLA 1 - CUANTIFICACION',...
    'Position',[80 205 170 30],...
    'Callback',@generarTabla1);

uicontrol(fig,...
    'Style','pushbutton',...
    'String','TABLA 2 - MUESTREO',...
    'Position',[270 205 170 30],...
    'Callback',@generarTabla2);



%% ============================================================
% RESULTADOS
% ============================================================


resultadoTexto = uicontrol(fig,...
    'Style','text',...
    'String','Resultados apareceran aqui',...
    'FontSize',10,...
    'Position',[40 30 440 165],...
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




%% ============================================================
% TABLA 1 - VARIACION DE NIVELES DE CUANTIFICACION
% Senal C, Fs de Nyquist
% ============================================================

function generarTabla1(~,~)

    try
        nivelesPrueba = [2 4 8 16 32 64 128 256];

        % Para la senal C, generarSenal define fMax = 50 Hz.
        % Por tanto, Fs de Nyquist = 2*fMax = 100 Hz.
        [~,~,infoC] = generarSenal('C');
        FsNyquist = infoC.FsNyquist;

        MSE = zeros(size(nivelesPrueba));
        SNR = zeros(size(nivelesPrueba));

        for k = 1:length(nivelesPrueba)
            r = procesarADC('C',FsNyquist,nivelesPrueba(k));
            MSE(k) = r.MSE;
            SNR(k) = r.SNR;
        end

        datos = [nivelesPrueba(:), MSE(:), SNR(:)];

        fTabla = figure(...
            'Name','Tabla 1 - Variacion de niveles de cuantificacion',...
            'NumberTitle','off',...
            'Position',[250 180 650 430]);

        uitable(fTabla,...
            'Data',datos,...
            'ColumnName',{'Niveles de cuantificacion','MSE','SNR [dB]'},...
            'ColumnWidth',{180 180 180},...
            'Position',[45 205 560 190]);

        axes('Parent',fTabla,'Position',[0.12 0.12 0.78 0.30]);
        yyaxis left
        plot(nivelesPrueba,MSE,'-o','LineWidth',1.5);
        ylabel('MSE');

        yyaxis right
        plot(nivelesPrueba,SNR,'-s','LineWidth',1.5);
        ylabel('SNR [dB]');

        xlabel('Niveles de cuantificacion');
        title(sprintf('Senal C - Fs Nyquist = %.0f Hz',FsNyquist));
        grid on;

    catch error
        msgbox(['ERROR TABLA 1: ',error.message]);
    end
end


%% ============================================================
% TABLA 2 - VARIACION DE FRECUENCIA DE MUESTREO
% Senal D, 16 niveles de cuantificacion
% ============================================================

function generarTabla2(~,~)

    if isempty(archivoAudioActual)
        msgbox('Cargue primero un archivo de audio para generar la Tabla 2');
        return;
    end

    try
        % fs es la frecuencia de muestreo ORIGINAL del archivo de audio.
        [~,FsOriginal] = audioread(archivoAudioActual);

        factores = [0.25 0.5 0.75 1 1.25 1.5 1.75 2];
        frecuencias = factores * FsOriginal;
        errorEspectral = zeros(size(factores));

        for k = 1:length(factores)
            r = procesarADC('D',frecuencias(k),16,archivoAudioActual);
            errorEspectral(k) = r.errorRelativo;
        end

        etiquetas = {...
            '0.25 fs'; '0.5 fs'; '0.75 fs'; 'fs';...
            '1.25 fs'; '1.5 fs'; '1.75 fs'; '2 fs'};

        datos = cell(length(factores),3);
        for k = 1:length(factores)
            datos{k,1} = etiquetas{k};
            datos{k,2} = frecuencias(k);
            datos{k,3} = errorEspectral(k);
        end

        fTabla = figure(...
            'Name','Tabla 2 - Variacion de frecuencia de muestreo',...
            'NumberTitle','off',...
            'Position',[250 180 700 440]);

        uitable(fTabla,...
            'Data',datos,...
            'ColumnName',{'Frecuencia','Fs [Hz]','Error espectral'},...
            'ColumnWidth',{130 180 200},...
            'Position',[55 210 590 195]);

        axes('Parent',fTabla,'Position',[0.12 0.12 0.80 0.30]);
        plot(frecuencias,errorEspectral,'-o','LineWidth',1.5);
        grid on;
        xlabel('Frecuencia de muestreo [Hz]');
        ylabel('Error espectral');
        title(sprintf('Senal D - 16 niveles - fs original = %.0f Hz',FsOriginal));

    catch error
        msgbox(['ERROR TABLA 2: ',error.message]);
    end
end


end