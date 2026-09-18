function [errorEspectral, errorRelativo] = calcularErrorEspectral(X1,X2)
% CALCULARESPCTROERROR Calcula el error entre dos espectros.
%
% Entradas:
%   X1 -> primer espectro (ejemplo: señal original)
%   X2 -> segundo espectro (ejemplo: señal reconstruida)
%
% Salidas:
%   errorEspectral -> diferencia absoluta entre espectros
%   errorRelativo  -> error normalizado


%% ------------------------------------------------------------
% VALIDACIONES
% -------------------------------------------------------------

if nargin ~= 2
    error('Se requieren dos espectros para comparar.');
end


if length(X1) ~= length(X2)

    error('Los espectros deben tener la misma longitud.');

end


%% ------------------------------------------------------------
% ERROR ESPECTRAL ABSOLUTO
% -------------------------------------------------------------

errorEspectral = abs(X1 - X2);



%% ------------------------------------------------------------
% ERROR ESPECTRAL RELATIVO
% -------------------------------------------------------------

energiaReferencia = sum(abs(X1).^2);


if energiaReferencia == 0

    errorRelativo = 0;

else

    errorRelativo = ...
        sum(errorEspectral.^2) / energiaReferencia;

end


end