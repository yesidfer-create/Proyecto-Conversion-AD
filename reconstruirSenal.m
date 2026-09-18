function [tRecon,senalRecon] = reconstruirSenal(tm,muestrasCuant,t)
% RECONSTRUIRSENAL Reconstruye una señal a partir de muestras cuantificadas.
%
% Entradas:
%   tm              -> tiempo de las muestras
%   muestrasCuant   -> valores cuantificados
%   t               -> tiempo donde se reconstruye
%
% Salidas:
%   tRecon          -> vector temporal reconstruido
%   senalRecon      -> señal reconstruida


%% ------------------------------------------------------------
% VALIDACIONES
% -------------------------------------------------------------

if nargin ~= 3
    error('Se requieren tm, muestras cuantificadas y t.');
end


%% ------------------------------------------------------------
% RECONSTRUCCIÓN POR INTERPOLACIÓN LINEAL
% -------------------------------------------------------------

tRecon = t;

senalRecon = interp1(...
    tm,...
    muestrasCuant,...
    t,...
    'linear',...
    'extrap');


end