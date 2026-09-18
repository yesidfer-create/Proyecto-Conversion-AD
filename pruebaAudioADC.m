clear;
clc;
close all;


%% ============================================================
% PRUEBA ADC CON AUDIO REAL
% ============================================================


%% ------------------------------------------------------------
% CARGAR AUDIO
% ------------------------------------------------------------

archivo = 'audio/Billie_Jean_coro_20s_mono.wav';


[audio,Fs] = audioread(archivo);



fprintf('====================================\n');
fprintf('PRUEBA ADC AUDIO\n');
fprintf('====================================\n');


fprintf('Frecuencia audio: %.2f Hz\n',Fs);

fprintf('Numero de muestras: %d\n',length(audio));

fprintf('Duracion: %.2f segundos\n',...
    length(audio)/Fs);



%% ------------------------------------------------------------
% ASEGURAR MONO
% ------------------------------------------------------------

if size(audio,2)>1

    audio = mean(audio,2);

end



%% ------------------------------------------------------------
% VECTOR DE TIEMPO
% ------------------------------------------------------------

t = (0:length(audio)-1)/Fs;



%% ------------------------------------------------------------
% REPRODUCIR ORIGINAL
% ------------------------------------------------------------

disp('Reproduciendo audio original...');

sound(audio,Fs);


pause(length(audio)/Fs + 1);



%% ============================================================
% CUANTIFICACION ADC
% ============================================================


N = 256;


[muestrasCuant,niveles,infoQ] = ...
    cuantificarSenal(audio,N);



fprintf('\nCUANTIFICACION\n');

fprintf('Niveles: %d\n',infoQ.N);

fprintf('Paso cuantificacion: %.8f\n',...
    infoQ.paso);



%% ============================================================
% RECONSTRUCCION
% ============================================================


audioRecon = muestrasCuant;



%% ============================================================
% REPRODUCIR AUDIO RECONSTRUIDO
% ============================================================


disp('Reproduciendo audio reconstruido...');


sound(audioRecon,Fs);



%% ============================================================
% METRICAS
% ============================================================


[MSE,SNR,error] = ...
    calcularMetricas(audio,muestrasCuant);



fprintf('\nRESULTADOS AUDIO\n');

fprintf('MSE = %.10f\n',MSE);

fprintf('SNR = %.4f dB\n',SNR);



%% ============================================================
% GRAFICA COMPLETA (NO RECOMENDADA)
% ============================================================


figure;


plot(t,audio,'b');

hold on;

plot(t,audioRecon,'r');


grid on;


xlabel('Tiempo [s]');

ylabel('Amplitud');


title('Audio original vs reconstruido');


legend('Original','Reconstruido');



%% ============================================================
% ZOOM PRIMEROS 50 ms
% ============================================================


muestrasMostrar = round(0.05*Fs);



figure;


plot(t(1:muestrasMostrar),...
     audio(1:muestrasMostrar),...
     'b','LineWidth',1.2);


hold on;


plot(t(1:muestrasMostrar),...
     audioRecon(1:muestrasMostrar),...
     'r','LineWidth',1.2);



grid on;


xlabel('Tiempo [s]');

ylabel('Amplitud');


title('Detalle audio original vs reconstruido');


legend('Original','Reconstruido');



%% ============================================================
% ERROR DE CUANTIFICACION
% ============================================================


errorCuant = audio - muestrasCuant;



figure;


plot(t(1:muestrasMostrar),...
     errorCuant(1:muestrasMostrar));


grid on;


xlabel('Tiempo [s]');

ylabel('Error');


title('Error de cuantificacion audio');

