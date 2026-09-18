function [tm, muestras, infoMuestreo] = muestrearSenal(t,senal,Fs)
% MUESTREARSENAL Realiza el muestreo de una señal.
%
% Entradas:
%   t      -> vector de tiempo de la señal original
%   senal  -> señal analógica simulada
%   Fs     -> frecuencia de muestreo [Hz]
%
% Salidas:
%   tm              -> instantes de muestreo
%   muestras        -> valores muestreados
%   infoMuestreo    -> información del muestreo
%
% El muestreo se realiza tomando valores cada Ts segundos.


%% ------------------------------------------------------------
% VALIDACIÓN
% -------------------------------------------------------------

if nargin ~= 3
    error('Se requieren t, señal y frecuencia de muestreo.');
end


if Fs <= 0
    error('La frecuencia de muestreo debe ser positiva.');
end


%% ------------------------------------------------------------
% PERIODO DE MUESTREO
% -------------------------------------------------------------

Ts = 1/Fs;


%% ------------------------------------------------------------
% GENERACIÓN DE LOS INSTANTES DE MUESTREO
% -------------------------------------------------------------

tm = t(1):Ts:t(end);


%% ------------------------------------------------------------
% OBTENER LAS MUESTRAS
% -------------------------------------------------------------

muestras = zeros(size(tm));


for k = 1:length(tm)

    [~,indice] = min(abs(t-tm(k)));

    muestras(k)=senal(indice);

end


%% ------------------------------------------------------------
% INFORMACIÓN DEL MUESTREO
% -------------------------------------------------------------

infoMuestreo.Fs = Fs;

infoMuestreo.Ts = Ts;

infoMuestreo.numeroMuestras = length(muestras);


end