clear;
clc;
close all;


%% ============================================================
% PRUEBA SEÑAL B
% ============================================================


%% Generar señal B

[t,senal,info] = generarSenal('C');


fprintf('--------------------------------------\n');
fprintf('PRUEBA SEÑAL C\n');
fprintf('--------------------------------------\n');

fprintf('Nombre: %s\n',info.nombre);
fprintf('Descripcion: %s\n',info.descripcion);
fprintf('Frecuencia maxima estimada: %.2f Hz\n',info.fMax);
fprintf('Frecuencia Nyquist: %.2f Hz\n',info.FsNyquist);



%% ============================================================
% MUESTREO
% ============================================================

Fs = 1000;   % frecuencia de muestreo

[tm,muestras,infoM] = muestrearSenal(t,senal,Fs);



fprintf('\nMUESTREO\n');

fprintf('Fs = %.2f Hz\n',infoM.Fs);

fprintf('Ts = %.6f s\n',infoM.Ts);

fprintf('Numero de muestras = %d\n',infoM.numeroMuestras);



%% ============================================================
% CUANTIFICACION
% ============================================================

N = 256;

[muestrasCuant,niveles,infoQ] = ...
    cuantificarSenal(muestras,N);



fprintf('\nCUANTIFICACION\n');

fprintf('Niveles = %d\n',infoQ.N);

fprintf('Paso cuantificacion = %.5f\n',infoQ.paso);



%% ============================================================
% RECONSTRUCCION
% ============================================================

[tRecon,senalRecon] = ...
    reconstruirSenal(tm,muestrasCuant,t);



%% ============================================================
% GRAFICA SEÑAL ORIGINAL
% ============================================================

figure;

plot(t,senal,'LineWidth',1.5);

grid on;

xlabel('Tiempo [s]');
ylabel('Amplitud');





%% ============================================================
% GRAFICA MUESTREO Y CUANTIFICACION
% ============================================================

figure;

plot(t,senal,'b','LineWidth',1.3);

hold on;

stem(tm,muestrasCuant,'r','filled');

grid on;

xlabel('Tiempo [s]');
ylabel('Amplitud');

title('Señal B muestreada y cuantificada');

legend('Señal original','Muestras cuantificadas');



%% ============================================================
% GRAFICA RECONSTRUCCION
% ============================================================

figure;

plot(t,senal,'b','LineWidth',1.5);

hold on;

plot(tRecon,senalRecon,'r','LineWidth',1.5);


grid on;

xlabel('Tiempo [s]');
ylabel('Amplitud');



legend('Original','Reconstruida');

