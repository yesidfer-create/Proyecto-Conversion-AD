function [muestrasCuant, niveles, infoCuant] = cuantificarSenal(muestras,N)
% CUANTIFICARSENAL Cuantificador uniforme de amplitud.
%
% Entradas:
%   muestras -> señal muestreada
%   N        -> número de niveles de cuantificación
%
% Salidas:
%   muestrasCuant -> señal cuantificada
%   niveles       -> niveles disponibles
%   infoCuant      -> información del cuantificador


%% ------------------------------------------------------------
% VALIDACIONES
% -------------------------------------------------------------

if nargin ~= 2
    error('Se requieren muestras y número de niveles.');
end


if N <= 1 || mod(N,1)~=0
    error('El número de niveles debe ser un entero mayor que 1.');
end


%% ------------------------------------------------------------
% NORMALIZACIÓN DE LA SEÑAL
% -------------------------------------------------------------

 xmin = min(muestras);

 xmax = max(muestras);  
% xmin = -1;
% xmax = 1;


%% ------------------------------------------------------------
% CREACIÓN DE NIVELES
% -------------------------------------------------------------

niveles = linspace(xmin,xmax,N);



%% ------------------------------------------------------------
% CUANTIFICACIÓN
% -------------------------------------------------------------

muestrasCuant = zeros(size(muestras));


for k = 1:length(muestras)

    [~,indice] = min(abs(niveles-muestras(k)));

    muestrasCuant(k)=niveles(indice);

end



%% ------------------------------------------------------------
% INFORMACIÓN
% -------------------------------------------------------------

infoCuant.N = N;

infoCuant.paso = (xmax-xmin)/(N-1);

infoCuant.valorMin = xmin;

infoCuant.valorMax = xmax;


end