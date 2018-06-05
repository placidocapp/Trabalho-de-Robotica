clear all;
close all;
clc

format short;
%% Iniciliza��o  

%Vari�veis das juntas
syms theta1 theta2 d3 theta4

%Par�metros do rob�
a1 = 1;
a2 = 1.2;
d1 = 0.6;
d4 = 0.1;

%Referencial 0
p0 = [0;0;0;1]; %Incio da junta, chutes iniciais abaixo

%Posi��o desejada
pf = [1.2;1.795;0.4;1];

%% SCARA

% Calcula a matriz de rota��o
A1 = A(a1, 0, d1, theta1, 1);
A2 = A(a2, pi, 0, theta2, 1);
A3 = A(0, 0, d3, 0, 1);
A4 = A(0, 0, d4, theta4, 1);

%Posi��o de cada junta
T1 = A1*p0;
T2 = A1*A2*p0;
T3 = A1*A2*A3*p0;
T4 = A1*A2*A3*A4*p0;

%Tira o jacobiano
Jacobiano = jacobian(T4, [theta1 theta2 d3 theta4]);
Jacobiano = simplify(Jacobiano);

%Chute inicial
theta1 = deg2rad(45);
theta2 = deg2rad(20);
d3 = 0.1;
theta4 = deg2rad(0);

%Par�metros
maxIter = 100;
theta = zeros(4, maxIter);
theta(:,1) = [theta1; theta2; d3; theta4];
k = 1;
eps = 10^-4;

%Posi��o inicial
pos_inicial = eval(A1*A2*A3*A4*p0);

while (1)
    %Descobre as posi��es das juntas
    T1 = eval(A1*p0);
    T2 = eval(A1*A2*p0);
    T3 = eval(A1*A2*A3*p0);
    T4 = eval(A1*A2*A3*A4*p0);
    J = eval(Jacobiano);

    %Plota
    plot3([p0(1) T1(1)],[p0(2) T1(2)],[p0(3) T1(3)], 'k');
    % axis([0 4 0 4 0 4])
    hold on
    plot3(T1(1),T1(2), T1(3), '*')
    plot3(T2(1),T2(2), T2(3), '*')
    plot3(T3(1),T3(2), T3(3), '*')
    plot3([T1(1) T2(1)],[T1(2) T2(2)],[T1(3) T2(3)], 'k');
    plot3([T2(1) T3(1)],[T2(2) T3(2)],[T2(3) T3(3)], 'k');
    plot3([T3(1) T4(1)],[T3(2) T4(2)],[T3(3) T4(3)], 'k');
    
    %Faz a itera��o do algoritmo
    theta(:,k+1) = theta(:,k) + J*(pf - T4);
    erro_de_posicao = pf - T4;
    theta1 = theta(1,k+1);
    theta2 = theta(2,k+1);
    d3 = theta(3,k+1);
    theta4 = theta(4,k+1);
    
    k = k+1;
    if (k == maxIter)||( sum(erro_de_posicao < eps) == 4 )
        erro_de_posicao
        k
        break;
    end
end


























