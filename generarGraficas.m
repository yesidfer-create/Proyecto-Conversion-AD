function generarGraficas(resultado)

% GENERARGRAFICAS Genera graficas del proceso ADC
%
% Entrada:
% resultado -> estructura generada por procesarADC


%% ============================================================
% EXTRAER INFORMACION
% ============================================================


tipo = resultado.tipo;


senal = resultado.senalOriginal;

senalRecon = resultado.senalReconstruida;


muestras = resultado.muestras;

muestrasCuant = resultado.muestrasCuantificadas;


t = resultado.tOriginal;

tm = resultado.tMuestreo;

tRecon = resultado.tRecon;


f = resultado.f;

Xoriginal = resultado.Xoriginal;

Xreconstruida = resultado.Xreconstruida;


errorEspectral = resultado.errorEspectral;


Fs = resultado.Fs;



%% ============================================================
% FRAGMENTO DE VISUALIZACION
% ============================================================


if tipo == "D"

    muestrasMostrar = min(round(0.05*Fs),length(senal));

else

    muestrasMostrar = length(senal);

end



%% ============================================================
% 1. SENAL ORIGINAL
% ============================================================


figure;

plot(t,senal,'LineWidth',1.5);

grid on;

xlabel('Tiempo [s]');

ylabel('Amplitud');

title('Senal original');



%% ============================================================
% 2. ESPECTRO ORIGINAL
% ============================================================


figure;

plot(f,Xoriginal,'LineWidth',1.5);

grid on;

xlabel('Frecuencia [Hz]');

ylabel('|X(f)|');

title('Espectro senal original');



%% ============================================================
% 3. SENAL MUESTREADA
% ============================================================


figure;

stem(tm,muestras,'filled');

grid on;

xlabel('Tiempo [s]');

ylabel('Amplitud');

title('Senal muestreada');



%% ============================================================
% 4. ESPECTRO SENAL MUESTREADA
% ============================================================


[fM,Xm] = calcularEspectro(muestras,Fs);


figure;

plot(fM,Xm,'LineWidth',1.5);

grid on;

xlabel('Frecuencia [Hz]');

ylabel('|Xm(f)|');

title('Espectro senal muestreada');



%% ============================================================
% 5. SENAL CUANTIFICADA
% ============================================================


figure;

stem(tm,muestrasCuant,'filled');

grid on;

xlabel('Tiempo [s]');

ylabel('Amplitud');

title('Senal cuantificada');



%% ============================================================
% 6. SENAL RECONSTRUIDA
% ============================================================


figure;

plot(tRecon,senalRecon,'LineWidth',1.5);

grid on;

xlabel('Tiempo [s]');

ylabel('Amplitud');

title('Senal reconstruida');



%% ============================================================
% 7. ERROR DE CUANTIFICACION
% ============================================================


errorCuant = muestras - muestrasCuant;


figure;

stem(tm,errorCuant,'filled');

grid on;

xlabel('Tiempo [s]');

ylabel('Error');

title('Error de cuantificacion');



%% ============================================================
% 8. COMPARACION ESPECTRAL
% ============================================================


figure;

plot(f,Xoriginal,...
    'LineWidth',1.5);

hold on;

plot(f,Xreconstruida,...
    'LineWidth',1.5);


grid on;

xlabel('Frecuencia [Hz]');

ylabel('|X(f)|');

title('Comparacion espectral');

legend('Original','Reconstruida');



%% ============================================================
% 9. ERROR ESPECTRAL
% ============================================================


figure;

plot(f,errorEspectral,...
    'LineWidth',1.5);


grid on;

xlabel('Frecuencia [Hz]');

ylabel('Error');

title('Error espectral');


end