clear;
clc;
close all;


%% ============================================================
% TABLA AUDIO - VARIACION FRECUENCIA DE MUESTREO
% N = 16 NIVELES
% ============================================================


%% ------------------------------------------------------------
% CARGAR AUDIO
% ------------------------------------------------------------

archivo = 'audio/Billie_Jean_coro_20s_mono.wav';


[audio,Fs_original] = audioread(archivo);



if size(audio,2)>1

    audio = mean(audio,2);

end



fprintf('====================================\n');
fprintf('TABLA AUDIO ADC\n');
fprintf('====================================\n');

fprintf('Fs original = %.0f Hz\n',Fs_original);



%% ------------------------------------------------------------
% PARAMETROS
% ------------------------------------------------------------


N = 16;


factores = [0.25 0.5 0.75 1 1.25 1.5 1.75 2];


Fs_pruebas = factores*Fs_original;



%% Crear vectores resultados

MSE = zeros(length(Fs_pruebas),1);

SNR = zeros(length(Fs_pruebas),1);

ErrorEspectral = zeros(length(Fs_pruebas),1);



%% ------------------------------------------------------------
% CICLO DE PRUEBAS
% ------------------------------------------------------------


for k = 1:length(Fs_pruebas)


    Fs_nuevo = round(Fs_pruebas(k));


    fprintf('\nProbando Fs = %.0f Hz\n',Fs_nuevo);



    %% Resampling

    audio_resampled = ...
        resample(audio,Fs_nuevo,Fs_original);



    %% Cuantificacion

    audio_cuant = ...
        cuantificarSenal(audio_resampled,N);



    % reconstruccion

    audio_recon = audio_cuant;



    %% Metricas temporales


    [MSE(k),SNR(k),~] = ...
        calcularMetricas(...
        audio_resampled,...
        audio_recon);



    %% Espectro


    [~,Xoriginal] = ...
        calcularEspectro(...
        audio_resampled,...
        Fs_nuevo);



    [~,Xrecon] = ...
        calcularEspectro(...
        audio_recon,...
        Fs_nuevo);



    [~,ErrorEspectral(k)] = ...
        calcularErrorEspectral(...
        Xoriginal,...
        Xrecon);



end



%% ------------------------------------------------------------
% CREAR TABLA
% ------------------------------------------------------------


TablaResultados = table(...
    Fs_pruebas',...
    MSE,...
    SNR,...
    ErrorEspectral,...
    'VariableNames',...
    {'Fs_Hz','MSE','SNR_dB','Error_Espectral'});



disp(' ')

disp('RESULTADOS AUDIO')

disp(TablaResultados)



%% ------------------------------------------------------------
% GRAFICA SNR
% ------------------------------------------------------------


figure;


plot(Fs_pruebas,SNR,...
    '-o',...
    'LineWidth',1.5);


grid on;


xlabel('Frecuencia de muestreo [Hz]');

ylabel('SNR [dB]');


title('SNR vs frecuencia de muestreo - Audio');


%% ------------------------------------------------------------
% GRAFICA ERROR ESPECTRAL
% ------------------------------------------------------------


figure;


plot(Fs_pruebas,...
     ErrorEspectral,...
     '-o',...
     'LineWidth',1.5);



grid on;


xlabel('Frecuencia de muestreo [Hz]');

ylabel('Error espectral');


title('Error espectral vs frecuencia de muestreo');
