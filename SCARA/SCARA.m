clear all;
close all;
clc

format short;
%% Inicilização  

%Variáveis das juntas
syms theta1 theta2 d3 theta4

%Parâmetros do robô
a1 = 1;
a2 = 1.2;
d1 = 1.5;
d4 = 0;

%Referencial 0
p0 = [0;0;0;1]; %Incio da junta, chutes iniciais abaixo

%Posição desejada
pfinal = [-1;1.9;0.2;1];

%Pàsso
ds = 0.01;

%% SCARA

% Calcula a matriz de rotação
A1 = A(a1, 0, d1, theta1, 1);
A2 = A(a2, pi, 0, theta2, 1);
A3 = A(0, 0, d3, 0, 1);
A4 = A(0, 0, d4, theta4, 1);

%Posição de cada junta
T1_s = A1*p0;
T2_s = A1*A2*p0;
T3_s = A1*A2*A3*p0;
T4_s = A1*A2*A3*A4*p0;

%Tira o jacobiano
Jacobiano = jacobian(T4_s, [theta1 theta2 d3 theta4]);
Jacobiano = simplify(Jacobiano);

%Chute inicial
theta1 = deg2rad(45);
theta2 = deg2rad(20);
d3 = 0.1;
theta4 = deg2rad(0);

%Trajetória
pini = eval(A1*A2*A3*A4*p0);      %Posição inicial da ponta do robo
trajetoria = [ linspace(pini(1,1),pfinal(1,1),inv(ds));
               linspace(pini(2,1),pfinal(2,1),inv(ds));
               linspace(pini(3,1),pfinal(3,1),inv(ds));
               linspace(pini(4,1),pfinal(4,1),inv(ds))];

%Parâmetros
maxIter = 100;
theta = zeros(4, maxIter);
theta(:,1) = [theta1; theta2; d3; theta4];
eps = 10^-4;

%Posição inicial
pos_inicial = eval(A1*A2*A3*A4*p0);

for i = 2:inv(ds)
    pf = trajetoria(:,i);
    k = 1;
    %Loop para cinemática reversa
    while (1)
        %Descobre as posições das juntas
        T1 = eval(T1_s);
        T2 = eval(T2_s);
        T3 = eval(T3_s);
        T4 = eval(T4_s);
        J = eval(Jacobiano);

        %Faz a iteração do algoritmo
        Dtheta = pinv(J)*(pf - T4);
        theta(:,k+1) = theta(:,k) + Dtheta;
        erro_de_posicao = pf - T4;
        theta1 = theta(1,k+1);
        theta2 = theta(2,k+1);
        d3 = theta(3,k+1);
        theta4 = theta(4,k+1);


        k = k+1;
        if (sum(abs(erro_de_posicao) < eps) == 4)||(sum(Dtheta < 10^-10) == 4)||(k > maxIter)
            erro_de_posicao
            k
            %atualiza novo theta
            theta(:,1) = theta(:,k-1);
            theta(:,1);
            break;
        end 
        
    %end while
    end
    
    %Plota
    clf
    plot3(pini(1,1),pini(2,1),pini(3,1),'.b');
    hold on;
    axis([-1 3 -1 3 -1 3])
    plot3(pfinal(1,end),pfinal(2,end),pfinal(3,end),'.r');
    plot3(pf(1,end),pf(2,end),pf(3,end),'*r');
    plot3([p0(1) T1(1)],[p0(2) T1(2)],[p0(3) T1(3)], 'k');
    plot3(T1(1),T1(2), T1(3), '*')
    plot3(T2(1),T2(2), T2(3), '*')
    plot3(T3(1),T3(2), T3(3), '*')
    plot3([T1(1) T2(1)],[T1(2) T2(2)],[T1(3) T2(3)], 'k');
    plot3([T2(1) T3(1)],[T2(2) T3(2)],[T2(3) T3(3)], 'k');
    plot3([T3(1) T4(1)],[T3(2) T4(2)],[T3(3) T4(3)], 'k');
    pause(0.05);
    
    %Atualiza a posição incial como a posição atual do robo
    pos_inicial = T4;
    T4 = eval(A1*A2*A3*A4*p0);
    
%end for
end
























