clear;
clc;
close all;


%% ============================================================
% PRUEBA ERROR ESPECTRAL - SEÑAL C
% ============================================================


%% ------------------------------------------------------------
% GENERAR SEÑAL C
% ------------------------------------------------------------

[t,senal,info] = generarSenal('C');


fprintf('--------------------------------------\n');
fprintf('PRUEBA ERROR ESPECTRAL\n');
fprintf('SEÑAL C\n');
fprintf('--------------------------------------\n');

fprintf('Nombre: %s\n',info.nombre);

fprintf('Descripcion: %s\n',info.descripcion);



%% ------------------------------------------------------------
% MUESTREO
% ------------------------------------------------------------

Fs = 1000;


[tm,muestras,infoM] = ...
    muestrearSenal(t,senal,Fs);



fprintf('\nMUESTREO\n');

fprintf('Frecuencia de muestreo: %.2f Hz\n',infoM.Fs);

fprintf('Periodo de muestreo: %.6f s\n',infoM.Ts);

fprintf('Numero de muestras: %d\n',infoM.numeroMuestras);



%% ------------------------------------------------------------
% CUANTIFICACION
% ------------------------------------------------------------

N = 256;


[muestrasCuant,niveles,infoQ] = ...
    cuantificarSenal(muestras,N);



fprintf('\nCUANTIFICACION\n');

fprintf('Niveles: %d\n',infoQ.N);

fprintf('Paso cuantificacion: %.6f\n',infoQ.paso);



%% ------------------------------------------------------------
% RECONSTRUCCION
% ------------------------------------------------------------

[tRecon,senalRecon] = ...
    reconstruirSenal(tm,muestrasCuant,t);



%% ------------------------------------------------------------
% ESPECTROS
% ------------------------------------------------------------

% Frecuencia utilizada para representar la señal original
FsReferencia = 10000;


[f,Xoriginal] = ...
    calcularEspectro(senal,FsReferencia);



[f2,Xreconstruida] = ...
    calcularEspectro(senalRecon,FsReferencia);



%% ------------------------------------------------------------
% ERROR ESPECTRAL
% ------------------------------------------------------------

[errorEspectral,errorRelativo] = ...
    calcularErrorEspectral(Xoriginal,Xreconstruida);



fprintf('\nERROR ESPECTRAL\n');

fprintf('Error relativo = %.10f\n',errorRelativo);



%% ============================================================
% GRAFICA SEÑAL ORIGINAL VS RECONSTRUIDA
% ============================================================

figure;

plot(t,senal,'b','LineWidth',1.5);

hold on;

plot(tRecon,senalRecon,'r','LineWidth',1.5);


grid on;


xlabel('Tiempo [s]');

ylabel('Amplitud');


title('Señal C - Original vs Reconstruida');


legend('Original','Reconstruida');



%% ============================================================
% GRAFICA ESPECTROS
% ============================================================

figure;


plot(f,Xoriginal,'b','LineWidth',1.5);

hold on;


plot(f2,Xreconstruida,'r','LineWidth',1.5);


grid on;


xlabel('Frecuencia [Hz]');

ylabel('|X(f)|');


title('Espectro Señal C');


legend('Original','Reconstruida');


xlim([0 200]);



%% ============================================================
% GRAFICA ERROR ESPECTRAL
% ============================================================

figure;


plot(f,errorEspectral,'LineWidth',1.5);


grid on;


xlabel('Frecuencia [Hz]');

ylabel('Error');


title('Error espectral Señal C');


xlim([0 200]);
