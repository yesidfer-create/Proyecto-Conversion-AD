function [f,magnitud] = calcularEspectro(senal,Fs)
% CALCULARESPECTRO Calcula el espectro de una señal mediante FFT.
%
% Entradas:
%   senal -> señal en el dominio temporal
%   Fs    -> frecuencia de muestreo
%
% Salidas:
%   f          -> eje de frecuencia
%   magnitud   -> magnitud del espectro


%% ------------------------------------------------------------
% VALIDACIONES
% -------------------------------------------------------------

if nargin ~= 2
    error('Se requieren señal y frecuencia de muestreo.');
end


%% ------------------------------------------------------------
% LONGITUD DE LA SEÑAL
% -------------------------------------------------------------

L = length(senal);



%% ------------------------------------------------------------
% FFT
% -------------------------------------------------------------

X = fft(senal);



%% ------------------------------------------------------------
% ESPECTRO DE MAGNITUD
% -------------------------------------------------------------

P2 = abs(X/L);


% Tomamos solamente la mitad positiva

P1 = P2(1:floor(L/2)+1);


% Ajuste de amplitud excepto DC

P1(2:end-1)=2*P1(2:end-1);



%% ------------------------------------------------------------
% EJE DE FRECUENCIA
% -------------------------------------------------------------

f = Fs*(0:floor(L/2))/L;


magnitud=P1;


end