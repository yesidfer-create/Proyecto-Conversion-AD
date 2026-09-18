clear;
clc;
close all;


%% ============================================================
% PRUEBA AUDIO RESAMPLING + ADC
% ============================================================


%% ------------------------------------------------------------
% CARGAR AUDIO ORIGINAL
% ------------------------------------------------------------

archivo = 'audio/Billie_Jean_coro_20s_mono.wav';


[audio,Fs_original] = audioread(archivo);



% Asegurar mono

if size(audio,2)>1

    audio = mean(audio,2);

end



fprintf('====================================\n');
fprintf('PRUEBA AUDIO RESAMPLING ADC\n');
fprintf('====================================\n');


fprintf('Fs original: %.0f Hz\n',Fs_original);



%% ------------------------------------------------------------
% NUEVA FRECUENCIA DE MUESTREO
% ------------------------------------------------------------

Fs_nuevo = 22050;


% Resampling

audio_resampled = resample(audio,Fs_nuevo,Fs_original);



fprintf('Fs nuevo: %.0f Hz\n',Fs_nuevo);



%% Nuevo vector de tiempo

t = (0:length(audio_resampled)-1)/Fs_nuevo;



%% ------------------------------------------------------------
% CUANTIFICACION
% ------------------------------------------------------------


N = 16;


[audio_cuant,~,infoQ] = ...
    cuantificarSenal(audio_resampled,N);



fprintf('\nCUANTIFICACION\n');

fprintf('Niveles: %d\n',N);

fprintf('Paso: %.8f\n',infoQ.paso);



%% ------------------------------------------------------------
% RECONSTRUCCION
% ------------------------------------------------------------


audio_recon = audio_cuant;



%% ------------------------------------------------------------
% ESCUCHAR AUDIO RECONSTRUIDO
% ------------------------------------------------------------


disp('Reproduciendo audio reconstruido...');


sound(audio_recon,Fs_nuevo);



%% ------------------------------------------------------------
% METRICAS
% ------------------------------------------------------------


% Comparar en la misma longitud

audio_original_comparacion = ...
    audio_resampled;



[MSE,SNR,~] = ...
    calcularMetricas(audio_original_comparacion,...
                     audio_recon);



fprintf('\nRESULTADOS\n');

fprintf('MSE = %.10f\n',MSE);

fprintf('SNR = %.4f dB\n',SNR);



%% ------------------------------------------------------------
% GRAFICA TEMPORAL
% ------------------------------------------------------------


muestrasMostrar = round(0.05*Fs_nuevo);



figure;


plot(t(1:muestrasMostrar),...
     audio_resampled(1:muestrasMostrar),...
     'b','LineWidth',1.2);


hold on;


plot(t(1:muestrasMostrar),...
     audio_recon(1:muestrasMostrar),...
     'r','LineWidth',1.2);


grid on;


xlabel('Tiempo [s]');

ylabel('Amplitud');


title('Audio resampleado vs reconstruido');


legend('Original resampleado',...
       'Reconstruido');



%% ------------------------------------------------------------
% ERROR ESPECTRAL
% ------------------------------------------------------------


FsFFT = Fs_nuevo;


[f,X1] = calcularEspectro(...
    audio_resampled,FsFFT);



[~,X2] = calcularEspectro(...
    audio_recon,FsFFT);



[errorEspectral,errorRelativo] = ...
    calcularErrorEspectral(X1,X2);



fprintf('\nERROR ESPECTRAL\n');

fprintf('Error relativo = %.10f\n',...
    errorRelativo);



figure;


plot(f,errorEspectral,...
    'LineWidth',1.2);


grid on;


xlabel('Frecuencia [Hz]');

ylabel('Error');


title('Error espectral audio');

xlim([0 5000]);
