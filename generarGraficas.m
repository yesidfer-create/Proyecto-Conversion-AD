function generarGraficas(resultado)

% GENERARGRAFICAS Genera unicamente las graficas solicitadas por el proyecto ADC
%
% Entrada:
%   resultado -> estructura generada por procesarADC

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

Fs = resultado.Fs;

%% ============================================================
% NOTA PARA AUDIO
% ============================================================

if tipo == "D"
    msgbox('Para la señal de audio no se muestran gráficas en esta versión.');
    return;
end

%% ============================================================
% 1. SEÑAL ORIGINAL EN EL TIEMPO
% ============================================================

figure;
plot(t, senal, 'LineWidth', 1.5);
grid on;
xlabel('Tiempo [s]');
ylabel('Amplitud');
title('Señal original');

%% ============================================================
% 2. ESPECTRO DE LA SEÑAL ORIGINAL
% ============================================================

figure;
plot(f, Xoriginal, 'LineWidth', 1.5);
grid on;
xlabel('Frecuencia [Hz]');
ylabel('|X(f)|');
title('Espectro de la señal original');

%% ============================================================
% 3. SEÑAL MUESTREADA EN EL TIEMPO
% ============================================================

figure;
stem(tm, muestras, 'filled');
grid on;
xlabel('Tiempo [s]');
ylabel('Amplitud');
title('Señal muestreada');

%% ============================================================
% 4. ESPECTRO DE LA SEÑAL MUESTREADA
% ============================================================

[fM, Xm] = calcularEspectro(muestras, Fs);

figure;
plot(fM, Xm, 'LineWidth', 1.5);
grid on;
xlabel('Frecuencia [Hz]');
ylabel('|Xm(f)|');
title('Espectro de la señal muestreada');

%% ============================================================
% 5. SEÑAL CUANTIFICADA
% ============================================================

figure;
stem(tm, muestrasCuant, 'filled');
grid on;
xlabel('Tiempo [s]');
ylabel('Amplitud');
title('Señal cuantificada');

%% ============================================================
% 6. SEÑAL RECONSTRUIDA
% ============================================================

figure;
plot(tRecon, senalRecon, 'LineWidth', 1.5);
grid on;
xlabel('Tiempo [s]');
ylabel('Amplitud');
title('Señal reconstruida');

end
