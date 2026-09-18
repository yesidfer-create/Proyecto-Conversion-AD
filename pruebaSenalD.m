clear;
clc;
close all;


[t,senal,info] = generarSenal('D');


fprintf('============================\n');
fprintf('PRUEBA SEÑAL D\n');
fprintf('============================\n');


fprintf('Nombre: %s\n',info.nombre);

fprintf('Descripcion: %s\n',info.descripcion);

fprintf('Fs Audio: %.0f Hz\n',info.FsAudio);

fprintf('Duracion: %.2f segundos\n',...
    length(senal)/info.FsAudio);



sound(senal,info.FsAudio);


figure;

plot(t(1:2000),senal(1:2000));

grid on;

xlabel('Tiempo [s]');

ylabel('Amplitud');

title('Señal D - Audio');
