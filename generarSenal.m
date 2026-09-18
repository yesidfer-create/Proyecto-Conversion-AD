function [t, senal, info] = generarSenal(tipoSenal)
% GENERARSENAL Genera las señales del proyecto ADC.
%
% Entradas:
%   tipoSenal -> 'A', 'B', 'C' o 'D'
%
% Salidas:
%   t     -> vector de tiempo
%   senal -> señal generada o audio cargado
%   info  -> estructura con información de la señal
%
% Señales:
%   A: A*cos(2*pi*f0*t)
%   B: sinc(2*a*t)
%   C: sinc^2(a*t)+sinc(2*a*t)
%   D: archivo de audio WAV


%% ------------------------------------------------------------
% CONSTANTES DEL PROYECTO
% -------------------------------------------------------------

A = 1;              
f0 = 5;             
a = 50;             

FsReferencia = 10000;  

duracion = 1;          


%% ------------------------------------------------------------
% VALIDACIÓN DE ENTRADA
% -------------------------------------------------------------

if nargin ~= 1

    error('generarSenal requiere un tipo de señal: A, B, C o D.');

end


tipoSenal = upper(char(tipoSenal));



%% ------------------------------------------------------------
% VECTOR DE TIEMPO PARA SEÑALES SINTÉTICAS
% -------------------------------------------------------------

t = -duracion/2 : 1/FsReferencia : duracion/2 - 1/FsReferencia;



%% ------------------------------------------------------------
% GENERACIÓN DE LA SEÑAL
% -------------------------------------------------------------

switch tipoSenal


    %% ========================================================
    % SEÑAL A
    % =========================================================

    case 'A'


        senal = A*cos(2*pi*f0*t);


        info.nombre = 'Señal A';

        info.descripcion = 'A*cos(2*pi*f0*t)';

        info.fMax = f0;



    %% ========================================================
    % SEÑAL B
    % =========================================================

    case 'B'


        senal = sincManual(2*a*t);


        info.nombre = 'Señal B';

        info.descripcion = 'sinc(2*a*t)';

        info.fMax = a;



    %% ========================================================
    % SEÑAL C
    % =========================================================

    case 'C'


        sinc1 = sincManual(a*t);

        sinc2 = sincManual(2*a*t);


        senal = sinc1.^2 + sinc2;


        info.nombre = 'Señal C';

        info.descripcion = 'sinc^2(a*t) + sinc(2*a*t)';

        info.fMax = a;



    %% ========================================================
    % SEÑAL D - AUDIO
    % =========================================================

    case 'D'


        archivo = 'audio/Billie_Jean_coro_20s_mono.wav';


        [senal,FsAudio] = audioread(archivo);



        % Convertir a mono si es estéreo

        if size(senal,2)>1

            senal = mean(senal,2);

        end



        % Tiempo correspondiente al audio

        t = (0:length(senal)-1)/FsAudio;



        info.nombre = 'Señal D';

        info.descripcion = 'Audio WAV';

        info.fMax = FsAudio/2;

        info.FsAudio = FsAudio;

        info.archivo = archivo;



    otherwise


        error('Tipo de señal no válido. Seleccione A, B, C o D.');

end



%% ------------------------------------------------------------
% INFORMACIÓN ADICIONAL
% -------------------------------------------------------------

info.A = A;

info.f0 = f0;

info.a = a;


info.FsReferencia = FsReferencia;


% Frecuencia mínima según Nyquist

info.FsNyquist = 2*info.fMax;



end



%% ========================================================================
% FUNCIÓN AUXILIAR PARA CALCULAR SINC
% ========================================================================

function y = sincManual(x)

% SINCMANUAL Implementación de sinc normalizada.
%
% sinc(x)=sin(pi*x)/(pi*x)


y = ones(size(x));


indices = (x ~= 0);


y(indices) = sin(pi*x(indices))./(pi*x(indices));


end