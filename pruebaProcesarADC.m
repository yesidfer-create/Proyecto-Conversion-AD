clear;
clc;
close all;


%% ============================================================
% PRUEBA PROCESAR ADC - SENAL D (AUDIO)
% ============================================================


tipoSenal = 'D';

Fs = 22050;

N = 16;



%% ============================================================
% PROCESAMIENTO ADC COMPLETO
% ============================================================


resultado = procesarADC(tipoSenal,Fs,N);



%% ============================================================
% MOSTRAR INFORMACION
% ============================================================


fprintf('====================================\n');
fprintf('RESULTADOS ADC - AUDIO\n');
fprintf('====================================\n');


fprintf('Nombre: %s\n',...
    resultado.info.nombre);


fprintf('Descripcion: %s\n',...
    resultado.info.descripcion);


fprintf('Archivo: %s\n',...
    resultado.info.archivo);



fprintf('\nPARAMETROS ADC\n');

fprintf('Frecuencia de muestreo usada: %.0f Hz\n',...
    resultado.Fs);


fprintf('Niveles de cuantificacion: %d\n',...
    resultado.N);



fprintf('\nMETRICAS\n');


fprintf('MSE = %.10f\n',...
    resultado.MSE);


fprintf('SNR = %.4f dB\n',...
    resultado.SNR);


fprintf('Error espectral relativo = %.10f\n',...
    resultado.errorRelativo);



fprintf('\nDURACION\n');


fprintf('Duracion procesada: %.2f segundos\n',...
    length(resultado.senalReconstruida)/resultado.Fs);



%% ============================================================
% ESCUCHAR AUDIO RECONSTRUIDO
% ============================================================


disp(' ');

disp('Reproduciendo audio reconstruido...');


sound(resultado.senalReconstruida,...
      resultado.Fs);



%% ============================================================
% GRAFICA DE UN FRAGMENTO
% ============================================================


muestrasMostrar = round(0.05*resultado.Fs);



figure;


plot(resultado.tOriginal(1:muestrasMostrar),...
     resultado.senalOriginal(1:muestrasMostrar),...
     'b','LineWidth',1.3);


hold on;


plot(resultado.tOriginal(1:muestrasMostrar),...
     resultado.senalReconstruida(1:muestrasMostrar),...
     'r','LineWidth',1.3);



grid on;


xlabel('Tiempo [s]');

ylabel('Amplitud');


title('Audio original vs reconstruido');


legend('Original','Reconstruido');



%% ============================================================
% ERROR DE CUANTIFICACION
% ============================================================


error = resultado.senalOriginal - ...
        resultado.senalReconstruida;



figure;


plot(resultado.tOriginal(1:muestrasMostrar),...
     error(1:muestrasMostrar),...
     'LineWidth',1.2);



grid on;


xlabel('Tiempo [s]');

ylabel('Error');


title('Error de cuantificacion del audio');
