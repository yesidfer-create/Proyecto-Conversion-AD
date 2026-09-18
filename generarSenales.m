function [t, senal, info] = generarSenal(tipoSenal)
% GENERARSENAL Genera las señales sintéticas del proyecto ADC.
%
% Entradas:
%   tipoSenal -> 'A', 'B' o 'C'
%
% Salidas:
%   t     -> vector de tiempo de referencia
%   senal -> señal generada
%   info  -> estructura con información de la señal
%
% Señales:
%   A: A*cos(2*pi*f0*t)
%   B: sinc(2*a*t)
%   C: sinc^2(a*t) + sinc(2*a*t)

    %% ------------------------------------------------------------
    % CONSTANTES DEL PROYECTO
    % -------------------------------------------------------------

    A = 1;              % Amplitud de la señal A
    f0 = 5;            % Frecuencia de la señal A [Hz]
    a = 50;             % Parámetro de las señales B y C

    FsReferencia = 10000;  % Frecuencia usada para representar
                           % aproximadamente la señal continua

    duracion = 1;          % Duración total [s]

    %% ------------------------------------------------------------
    % VECTOR DE TIEMPO
    % -------------------------------------------------------------

    t = -duracion/2 : 1/FsReferencia : duracion/2 - 1/FsReferencia;


    %% ------------------------------------------------------------
    % VALIDACIÓN DE LA ENTRADA
    % -------------------------------------------------------------

    if nargin ~= 1
        error('generarSenal requiere un tipo de señal: A, B o C.');
    end

    tipoSenal = upper(char(tipoSenal));


    %% ------------------------------------------------------------
    % GENERACIÓN DE LA SEÑAL
    % -------------------------------------------------------------

    switch tipoSenal

        case 'A'

            senal = A * cos(2*pi*f0*t);

            info.nombre = 'Señal A';
            info.descripcion = 'A*cos(2*pi*f0*t)';
            info.fMax = f0;


        case 'B'

            senal = sincManual(2*a*t);

            info.nombre = 'Señal B';
            info.descripcion = 'sinc(2*a*t)';
            info.fMax = a;


        case 'C'

            sinc1 = sincManual(a*t);
            sinc2 = sincManual(2*a*t);

            senal = sinc1.^2 + sinc2;

            info.nombre = 'Señal C';
            info.descripcion = 'sinc^2(a*t) + sinc(2*a*t)';
            info.fMax = a;


        otherwise

            error('Tipo de señal no válido. Seleccione A, B o C.');

    end


    %% ------------------------------------------------------------
    % INFORMACIÓN ADICIONAL
    % -------------------------------------------------------------

    info.A = A;
    info.f0 = f0;
    info.a = a;

    info.FsReferencia = FsReferencia;

    % Frecuencia mínima según Nyquist
    info.FsNyquist = 2 * info.fMax;

end


%% ========================================================================
% FUNCIÓN AUXILIAR PARA CALCULAR SINC
% ========================================================================

function y = sincManual(x)
% SINCMANUAL Implementación de sinc normalizada.
%
% sinc(x) = sin(pi*x)/(pi*x)
%
% Para x = 0:
% sinc(0) = 1

    y = ones(size(x));

    indices = (x ~= 0);

    y(indices) = sin(pi*x(indices)) ./ (pi*x(indices));

end