clear;
clc;
close all;


%% ============================================================
% PRUEBA GENERAR GRAFICAS ADC
% SEÑAL C
% ============================================================


%% GENERAR SEÑAL

[t,senal,info] = generarSenal('C');


%% MUESTREO

Fs = 1000;


[tm,muestras,infoM] = ...
    muestrearSenal(t,senal,Fs);



%% CUANTIFICACION

N = 256;


[muestrasCuant,~,infoQ] = ...
    cuantificarSenal(muestras,N);



%% RECONSTRUCCION


[tRecon,senalRecon] = ...
    reconstruirSenal(tm,muestrasCuant,t);



%% ESPECTROS


FsReferencia = 10000;


[f,Xoriginal] = ...
    calcularEspectro(senal,FsReferencia);



[f,Xreconstruida] = ...
    calcularEspectro(senalRecon,FsReferencia);



%% ERROR ESPECTRAL


[errorEspectral,errorRelativo] = ...
    calcularErrorEspectral(Xoriginal,Xreconstruida);



fprintf('==============================\n');

fprintf('PRUEBA GENERAR GRAFICAS\n');

fprintf('==============================\n');


fprintf('Señal: %s\n',info.nombre);

fprintf('Niveles ADC: %d\n',N);

fprintf('Fs: %.2f Hz\n',Fs);

fprintf('Error espectral: %.10f\n',...
        errorRelativo);



%% GENERAR TODAS LAS FIGURAS


generarGraficas(...
    t,...
    senal,...
    tm,...
    muestras,...
    muestrasCuant,...
    tRecon,...
    senalRecon,...
    f,...
    Xoriginal,...
    Xreconstruida,...
    errorEspectral);
