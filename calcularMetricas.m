function [mse,snr,error] = calcularMetricas(x,xq)
% CALCULARMETRICAS Calcula error de cuantificación.
%
% Entradas:
%   x  -> señal original muestreada
%   xq -> señal cuantificada
%
% Salidas:
%   mse   -> error cuadrático medio
%   snr   -> relación señal ruido [dB]
%   error -> error de cuantificación


%% ------------------------------------------------------------
% VALIDACIONES
% -------------------------------------------------------------

if nargin ~= 2
    error('Se requieren señal original y señal cuantificada.');
end


if length(x) ~= length(xq)

    error('Las señales deben tener la misma longitud.');

end


%% ------------------------------------------------------------
% ERROR DE CUANTIFICACIÓN
% -------------------------------------------------------------

error = x - xq;



%% ------------------------------------------------------------
% MSE
% -------------------------------------------------------------

mse = mean(error.^2);



%% ------------------------------------------------------------
% POTENCIAS
% -------------------------------------------------------------

potenciaSenal = mean(x.^2);

potenciaError = mean(error.^2);



%% ------------------------------------------------------------
% SNR
% -------------------------------------------------------------

if potenciaError == 0

    snr = Inf;

else

    snr = 10*log10(potenciaSenal/potenciaError);

end


end