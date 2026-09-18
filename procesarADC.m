function resultado = procesarADC(tipoSenal,Fs,N,archivoAudio)

% PROCESARADC Ejecuta todo el flujo de conversion A/D
%
% Entrada:
%   tipoSenal   -> 'A','B','C','D'
%   Fs          -> frecuencia de muestreo deseada
%   N           -> niveles de cuantificacion
%   archivoAudio-> ruta del archivo WAV (solo para D)
%
% Salida:
%   resultado -> estructura con señales y metricas


%% ============================================================
% GENERAR SENAL
% ============================================================


if nargin < 4
    archivoAudio = [];
end


tipoSenal = upper(string(tipoSenal));



if tipoSenal == "D"


    %% --------------------------------------------------------
    % AUDIO
    % ---------------------------------------------------------


    if isempty(archivoAudio)

        error('Debe seleccionar un archivo de audio.');

    end



    [senal,Fs_original] = audioread(archivoAudio);



    % Convertir a mono si es necesario

    if size(senal,2) > 1

        senal = mean(senal,2);

    end



    t = (0:length(senal)-1)/Fs_original;



    info.nombre = 'Senal D';

    info.descripcion = 'Audio WAV';

    info.archivo = archivoAudio;

    info.FsAudio = Fs_original;



else


    %% --------------------------------------------------------
    % SEÑALES SINTETICAS
    % ---------------------------------------------------------


    [t,senal,info] = generarSenal(tipoSenal);


end




%% ============================================================
% PROCESAMIENTO SEGUN TIPO DE SENAL
% ============================================================


if tipoSenal == "D"


    %% AUDIO


    senalProcesada = resample(senal,Fs,info.FsAudio);


    tProcesado = (0:length(senalProcesada)-1)/Fs;



else


    %% SEÑALES SINTETICAS


    [tm,muestras,infoM] = ...
        muestrearSenal(t,senal,Fs);



    senalProcesada = muestras;


    tProcesado = tm;


end




%% ============================================================
% CUANTIFICACION
% ============================================================


[muestrasCuant,~,infoQ] = ...
    cuantificarSenal(senalProcesada,N);




%% ============================================================
% RECONSTRUCCION
% ============================================================


if tipoSenal == "D"


    senalRecon = muestrasCuant;


else


    [tRecon,senalRecon] = ...
        reconstruirSenal(tProcesado,...
                         muestrasCuant,...
                         t);


end




%% ============================================================
% METRICAS
% ============================================================


[MSE,SNR,~] = ...
    calcularMetricas(...
    senalProcesada,...
    muestrasCuant);




%% ============================================================
% ESPECTROS
% ============================================================


[f,Xoriginal] = ...
    calcularEspectro(...
    senalProcesada,...
    Fs);



[~,Xreconstruida] = ...
    calcularEspectro(...
    senalRecon,...
    Fs);



% Ajustar longitudes

longitudMinima = min(length(Xoriginal),...
                     length(Xreconstruida));



Xoriginal = Xoriginal(1:longitudMinima);

Xreconstruida = Xreconstruida(1:longitudMinima);

f = f(1:longitudMinima);




%% ============================================================
% ERROR ESPECTRAL
% ============================================================


[errorEspectral,errorRelativo] = ...
    calcularErrorEspectral(...
    Xoriginal,...
    Xreconstruida);




%% ============================================================
% GUARDAR RESULTADOS
% ============================================================


resultado.tipo = tipoSenal;

resultado.info = info;


resultado.archivoAudio = archivoAudio;


resultado.Fs = Fs;

resultado.N = N;



% Señales

resultado.senalOriginal = senal;

resultado.senalProcesada = senalProcesada;

resultado.senalReconstruida = senalRecon;



resultado.tOriginal = t;

resultado.tMuestreo = tProcesado;



if tipoSenal ~= "D"

    resultado.tRecon = tRecon;

else

    resultado.tRecon = tProcesado;

end



resultado.muestrasCuantificadas = muestrasCuant;
resultado.muestras = senalProcesada;


% Metricas

resultado.MSE = MSE;

resultado.SNR = SNR;



% Espectros

resultado.f = f;

resultado.Xoriginal = Xoriginal;

resultado.Xreconstruida = Xreconstruida;



resultado.errorEspectral = errorEspectral;

resultado.errorRelativo = errorRelativo;



resultado.pasoCuantificacion = infoQ.paso;



end