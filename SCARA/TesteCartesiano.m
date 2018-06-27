clear all;
close all;
clc

%%  Chama dados da trajetória

load('Cartesiano_data')

%%  Simulink

%Parâmetros do Motor
Km = 1;

%Entradas do sistema
In1 = trajetoria(1,:);

%Controle
Kp = 10;
Ki = 10;

sim('ControleCartesiano')
