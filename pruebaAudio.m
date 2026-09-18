clear;
clc;
close all;


%% ============================================================
% PRUEBA CARGA AUDIO
% ============================================================


archivo = 'audio/Billie_Jean_coro_20s_mono.wav';


%% Leer audio

[audio,Fs] = audioread(archivo);



fprintf('====================================\n');
fprintf('PRUEBA AUDIO\n');
fprintf('====================================\n');


fprintf('Frecuencia de muestreo original: %.2f Hz\n',Fs);

fprintf('Numero de muestras: %d\n',length(audio));

fprintf('Duracion: %.2f segundos\n',...
    length(audio)/Fs);



%% Vector de tiempo

t = (0:length(audio)-1)/Fs;



%% Reproducir audio original

disp('Reproduciendo audio original...');

sound(audio,Fs);



%% Graficar primeros 0.05 segundos

muestrasMostrar = round(0.05*Fs);


figure;

plot(t(1:muestrasMostrar),...
    audio(1:muestrasMostrar),...
    'LineWidth',1.3);


grid on;


xlabel('Tiempo [s]');

ylabel('Amplitud');


title('Fragmento del audio original');
