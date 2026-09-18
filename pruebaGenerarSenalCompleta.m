clear;
clc;
close all;


%% ============================================================
% VALIDACION GENERAR SENAL A B C D
% ============================================================


senales = {'A','B','C','D'};


for k = 1:length(senales)


    tipo = senales{k};


    fprintf('\n============================\n');
    fprintf('Probando senal %s\n',tipo);
    fprintf('============================\n');


    [t,senal,info] = generarSenal(tipo);


    fprintf('Nombre: %s\n',info.nombre);

    fprintf('Descripcion: %s\n',info.descripcion);


    % Duracion segun tipo de senal

    if tipo == "D"

        duracion = length(senal)/info.FsAudio;

    else

        duracion = length(senal)/info.FsReferencia;

    end


    fprintf('Duracion: %.3f segundos\n',duracion);



    %% Reproducir solamente audio

    if tipo == "D"

        fprintf('Reproduciendo audio...\n');

        sound(senal,info.FsAudio);

        pause(length(senal)/info.FsAudio + 1);

    end



    %% Grafica

    figure;


    % Para audio mostrar solamente una parte

    if tipo == "D"


        muestras = min(3000,length(senal));


        plot(t(1:muestras),senal(1:muestras));


    else


        plot(t,senal);


    end



    grid on;


    xlabel('Tiempo [s]');

    ylabel('Amplitud');


    title(['Senal ',tipo]);



end