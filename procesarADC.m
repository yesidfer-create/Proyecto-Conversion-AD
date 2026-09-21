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

    % Informacion de cuantificacion original del archivo WAV
    datosAudio = audioinfo(archivoAudio);
    info.BitsPorMuestra = datosAudio.BitsPerSample;
    info.NOriginal = 2^info.BitsPorMuestra;



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


% Para la senal D tambien se calculan MSE y SQNR usando como
% referencia el numero de niveles original indicado por el WAV.
% Se usa una formula directa para evitar crear millones de niveles.
MSEOriginal = [];
SNROriginal = [];
errorRelativoOriginal = [];

if tipoSenal == "D"

    muestrasCuantOriginal = cuantificarOriginalRapida(...
        senalProcesada,...
        info.NOriginal);

    [MSEOriginal,SNROriginal,~] = ...
        calcularMetricas(...
        senalProcesada,...
        muestrasCuantOriginal);

end



%% ============================================================
% ESPECTROS PARA COMPARAR ORIGINAL VS RECONSTRUIDA
% ============================================================


if tipoSenal == "D"

    % La senal reconstruida permanece a la Fs seleccionada por el usuario.
    % Solo para calcular el error espectral se lleva temporalmente a la
    % frecuencia de muestreo original del archivo WAV.
    senalReconComparacion = resample(senalRecon,...
                                     info.FsAudio,...
                                     Fs);

    % Igualar longitudes temporales antes de calcular las FFT.
    longitudTemporal = min(length(senal),...
                           length(senalReconComparacion));

    senalOriginalComparacion = senal(1:longitudTemporal);
    senalReconComparacion = senalReconComparacion(1:longitudTemporal);

    FsComparacion = info.FsAudio;

else

    % Para A, B y C la senal original y la reconstruida estan definidas
    % sobre el vector temporal de referencia generado a FsReferencia.
    longitudTemporal = min(length(senal),...
                           length(senalRecon));

    senalOriginalComparacion = senal(1:longitudTemporal);
    senalReconComparacion = senalRecon(1:longitudTemporal);

    FsComparacion = info.FsReferencia;

end


[f,Xoriginal] = ...
    calcularEspectro(...
    senalOriginalComparacion,...
    FsComparacion);



[~,Xreconstruida] = ...
    calcularEspectro(...
    senalReconComparacion,...
    FsComparacion);



% Por seguridad, igualar las longitudes de los espectros.

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


% Para la senal D, calcular tambien el error espectral usando
% los niveles originales de cuantificacion del archivo WAV.
if tipoSenal == "D"

    senalReconOriginalComparacion = resample(muestrasCuantOriginal,...
                                              info.FsAudio,...
                                              Fs);

    longitudOriginal = min(length(senal),...
                           length(senalReconOriginalComparacion));

    senalOriginalErrorOriginal = senal(1:longitudOriginal);
    senalReconOriginalComparacion = ...
        senalReconOriginalComparacion(1:longitudOriginal);

    [~,XoriginalParaOriginal] = ...
        calcularEspectro(senalOriginalErrorOriginal,...
                         info.FsAudio);

    [~,XreconOriginal] = ...
        calcularEspectro(senalReconOriginalComparacion,...
                         info.FsAudio);

    longitudEspectralOriginal = min(length(XoriginalParaOriginal),...
                                    length(XreconOriginal));

    XoriginalParaOriginal = ...
        XoriginalParaOriginal(1:longitudEspectralOriginal);

    XreconOriginal = ...
        XreconOriginal(1:longitudEspectralOriginal);

    [~,errorRelativoOriginal] = ...
        calcularErrorEspectral(XoriginalParaOriginal,...
                               XreconOriginal);

end



%% ============================================================
% GUARDAR RESULTADOS
% ============================================================


resultado.tipo = tipoSenal;

resultado.info = info;


resultado.archivoAudio = archivoAudio;


resultado.Fs = Fs;

resultado.FsComparacion = FsComparacion;

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

resultado.MSEOriginal = MSEOriginal;

resultado.SNROriginal = SNROriginal;

resultado.errorRelativoOriginal = errorRelativoOriginal;



% Espectros

resultado.f = f;

resultado.Xoriginal = Xoriginal;

resultado.Xreconstruida = Xreconstruida;



resultado.errorEspectral = errorEspectral;

resultado.errorRelativo = errorRelativo;



resultado.pasoCuantificacion = infoQ.paso;



end


%% ============================================================
% CUANTIFICACION UNIFORME RAPIDA PARA N ORIGINAL DEL WAV
% ============================================================

function xq = cuantificarOriginalRapida(x,N)

xmin = min(x);
xmax = max(x);

if xmax == xmin
    xq = x;
    return;
end

paso = (xmax-xmin)/(N-1);

indice = round((x-xmin)/paso);

% Limitar por seguridad al rango valido de indices.
indice(indice < 0) = 0;
indice(indice > N-1) = N-1;

xq = xmin + indice*paso;

end
