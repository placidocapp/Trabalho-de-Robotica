clear all;
close all;
clc

format short;
%% Iniciliza��o  

%Vari�veis das juntas
syms theta1 theta2 d3 theta4

%Par�metros do rob�
a1 = 0.5;
a2 = 0.5;
d1 = 0.45;
d4 = 0.35;

%Referencial 0
p0 = [0;0;0;1]; %Incio da junta, chutes iniciais abaixo

%Numero de trajet�rias
ntraj = 6;

%Posi��o desejada
pfinal = [  0.7     0.3     0.3     0.3     0.7     0.7
            0.7     0.3     0.3     0.3     0.7     0.7
            0.4     0.4     0.17    0.4     0.4     0.17
            1       1       1       1       1       1];     

%Passo para cinem�tica inversa
ds = 0.1;

%Passo para plote da trajet�ria
dss = 0.05;

%Tempo inicial e final
ti = [0 2 4 6 8 10];
tf = [2 4 6 8 10 12];

%Velocidades iniciais e finais
vi = [0 0 0 0 0 0];
vf = [0 0 0 0 0 0];

%Acelera��es iniciais e finais
ai = [0 0 0 0 0 0];
af = [0 0 0 0 0 0];

%% SCARA

% Calcula a matriz de rota��o
A1 = A(a1, 0, d1, theta1, 1);
A2 = A(a2, pi, 0, theta2, 1);
A3 = A(0, 0, d3, 0, 1);
A4 = A(0, 0, d4, theta4, 1);

%Posi��o de cada junta
T1_s = A1*p0;
T2_s = A1*A2*p0;
T3_s = A1*A2*A3*p0;
T4_s = A1*A2*A3*A4*p0;

%Tira o jacobiano
Jacobiano = jacobian(T4_s, [theta1 theta2 d3 theta4]);
Jacobiano = simplify(Jacobiano);

%Chute inicial
theta1 = 0.643501004072952;
theta2 = 0.283794318648993;
d3 = -0.070000000000000;
theta4 = 0;

%Loop de trajet�rias
thetaInterm = zeros(4,ntraj+1); %Salva os valores intermedi�rios de cada junta
thetaInterm(:,1) = [theta1; theta2; d3; theta4];
for traj = 1:ntraj
    %Trajet�ria
    pini = eval(A1*A2*A3*A4*p0);      %Posi��o inicial da ponta do robo
    trajetoria = [ linspace(pini(1,1),pfinal(1,traj),inv(ds));
                   linspace(pini(2,1),pfinal(2,traj),inv(ds));
                   linspace(pini(3,1),pfinal(3,traj),inv(ds));
                   linspace(pini(4,1),pfinal(4,traj),inv(ds))];
               
    %Par�metros
    maxIter = 100;
    theta = zeros(4,1);
    theta(:,1) = [theta1; theta2; d3; theta4];
    eps = 10^-4;
    thetaFinal = zeros(4,inv(ds));
    thetaFinal(:,1) = theta(:,1);

    %Posi��o inicial
    pos_inicial = eval(A1*A2*A3*A4*p0);

    for i = 2:inv(ds)
        pf = trajetoria(:,i);
        k = 1;
        %Loop para cinem�tica reversa
        while (1)
            %Descobre as posi��es das juntas
            T1 = eval(T1_s);
            T2 = eval(T2_s);
            T3 = eval(T3_s);
            T4 = eval(T4_s);
            J = eval(Jacobiano);

            %Faz a itera��o do algoritmo
            Dtheta = pinv(J)*(pf - T4);
            theta(:,k+1) = theta(:,k) + Dtheta;
            erro_de_posicao = pf - T4;
            theta1 = theta(1,k+1);
            theta2 = theta(2,k+1);
            d3 = theta(3,k+1);
            theta4 = theta(4,k+1);


            k = k+1;
            if (sum(abs(erro_de_posicao) < eps) == 4)||(sum(Dtheta < 10^-10) == 4)||(k > maxIter)
                erro_de_posicao;
                k;
                %atualiza novo theta
                theta(:,1) = theta(:,k);
                theta(:,1);
                break;
            end 

        %end while
        end

%         %Plota
%         clf
%         plot3(pini(1,1),pini(2,1),pini(3,1),'.b');
%         hold on;
%         axis([-1 3 -1 3 -1 3])
%         plot3(pfinal(1,end),pfinal(2,end),pfinal(3,end),'.r');
%         plot3(pf(1,end),pf(2,end),pf(3,end),'*r');
%         plot3([p0(1) T1(1)],[p0(2) T1(2)],[p0(3) T1(3)], 'k');
%         plot3(T1(1),T1(2), T1(3), '*')
%         plot3(T2(1),T2(2), T2(3), '*')
%         plot3(T3(1),T3(2), T3(3), '*')
%         plot3([T1(1) T2(1)],[T1(2) T2(2)],[T1(3) T2(3)], 'k');
%         plot3([T2(1) T3(1)],[T2(2) T3(2)],[T2(3) T3(3)], 'k');
%         plot3([T3(1) T4(1)],[T3(2) T4(2)],[T3(3) T4(3)], 'k');
%         pause(0.05);

        %Atualiza a posi��o incial como a posi��o atual do robo
        pos_inicial = T4;
        thetaFinal(:,i) = theta(:,k);

    %end for
    end
    thetaInterm(:,traj+1) = thetaFinal(:,end);
    theta1 =  thetaFinal(1,end);
    theta2 =  thetaFinal(2,end);
    d3 = thetaFinal(3,end);
    theta4 = thetaFinal(4,end);
%end for
end

%%  Calcular trajet�ria junta a junta

%Numero de divisoes
div = floor(1/dss);

%Gera as trajet�rias
trajetoria = zeros(ntraj*div,size(theta,1));
vel = zeros(ntraj*div,size(theta,1));
acel = zeros(ntraj*div,size(theta,1));
t = [];
for traj = 1:ntraj
    t = [t linspace(ti(traj),tf(traj),div)];
end
figure(1);
figure(2);
figure(3);
for traj = 1:ntraj
    for i = 1:size(theta,1)
        aux = poli2(ti(traj), thetaInterm(i,traj), tf(traj), ...
            thetaInterm(i,traj+1), vi(traj), vf(traj), ai(traj), af(traj));
        for k = (1+(traj-1)*div):traj*div
            trajetoria(k,i) = aux'*[1; t(k); t(k)^2; t(k)^3; t(k)^4; t(k)^5];
            vel(k,i) = aux'*[0; 1; 2*t(k); 3*t(k)^2; 4*t(k)^3; 5*t(k)^4];
            acel(k,i) = aux'*[0; 0; 2; 6*t(k); 12*t(k)^2; 20*t(k)^3];
        end
    end
    
end

for i = 1:4
    figure(1),subplot(2,2,i), plot(t,trajetoria(:,i));
    %Escolhe o print
    if i == 1
        title('Trajet�ria de \theta_1')
        ylabel('\theta_1 [rad]')
    elseif i == 2
        title('Trajet�ria de \theta_2')
        ylabel('\theta_2 [rad]')
    elseif i == 3
        title('Trajet�ria de d_3')
        ylabel('d_3 [m]')
    elseif i == 4
        title('Trajet�ria de \theta_4')
        ylabel('\theta_4 [rad]')
    end
    xlabel('t [s]')
    figure(2),subplot(2,2,i), plot(t,vel(:,i));
    %Escolhe o print
    if i == 1
        title('Velocidade de \theta_1')
        ylabel('\theta_1 [rad/s]')
    elseif i == 2
        title('Velocidade de \theta_2')
        ylabel('\theta_2 [rad/s]')
    elseif i == 3
        title('Velocidade de d_3')
        ylabel('d_3 [m/s]')
    elseif i == 4
        title('Velocidade de \theta_4')
        ylabel('\theta_4 [rad/s]')
    end
    xlabel('t [s]')
    figure(3),subplot(2,2,i), plot(t,acel(:,i));
    %Escolhe o print
    if i == 1
        title('Acelera��o de \theta_1')
        ylabel('\theta_1 [rad/s^2]')
    elseif i == 2
        title('Acelera��o de \theta_2')
        ylabel('\theta_2 [rad/s^2]')
    elseif i == 3
        title('Acelera��o de d_3')
        ylabel('d_3 [m/s^2]')
    elseif i == 4
        title('Acelera��o de \theta_4')
        ylabel('\theta_4 [rad/s^2]')
    end
    xlabel('t [s]')
end

%Plota o resultado
figure(4);
%Inicializa o ponto inicial novamente
theta1 = -0.177613415641065;
theta2 = 1.947575427099808;
d3 = 1.300000000000000;
theta4 = deg2rad(0);
pini = eval(A1*A2*A3*A4*p0);
for i = 1:size(trajetoria,1)
    
    %Novas posi��es de cada junta
    theta1 = trajetoria(i,1);
    theta2 = trajetoria(i,2);
    d3 = trajetoria(i,3);
    theta4 = trajetoria(i,4);

    %Calcula posi��es do robo
    T1 = eval(T1_s);
    T2 = eval(T2_s);
    T3 = eval(T3_s);
    T4 = eval(T4_s);
    
%     %Plota
%     figure(4)
%     clf
%     plot3(pini(1,1),pini(2,1),pini(3,1),'.b');
%     hold on;
%     axis([-1 3 -1 3 -1 3])
%     plot3(pfinal(1,traj),pfinal(2,traj),pfinal(3,end),'.g');
%     plot3(pfinal(1,3),pfinal(2,3),pfinal(3,3),'.r');
%     plot3([p0(1) T1(1)],[p0(2) T1(2)],[p0(3) T1(3)], 'k');
%     plot3(T1(1),T1(2), T1(3), '*')
%     plot3(T2(1),T2(2), T2(3), '*')
%     plot3(T3(1),T3(2), T3(3), '*')
%     plot3([T1(1) T2(1)],[T1(2) T2(2)],[T1(3) T2(3)], 'k');
%     plot3([T2(1) T3(1)],[T2(2) T3(2)],[T2(3) T3(3)], 'k');
%     plot3([T3(1) T4(1)],[T3(2) T4(2)],[T3(3) T4(3)], 'k');
%     pause(0.01);
end

%% Modelo din�mico do sistema

%Par�metros do sistema
m = 3;     % [kg] para cada junta
g = 9.81;   % [m/s^2]
Iz1 = 8.25; Iz2 = 2; Iz3 = 0.05; Iz4 = 0;
m1 = 14.7222; m2 = 14.7222; m3 = 13.2500; m4 = 5.3055;

syms theta1 theta2 d3 theta4 theta1_dot theta2_dot

%Valor de D 
d11 = Iz1 + Iz2 + Iz3 + Iz4 + a1^2*(m1+m2+m3+m4) + a2^2*(m2+m3+m4)+...
    2*a1*a2*cos(theta2)*(m2+m3+m4);
d12 = Iz2 + Iz3 + Iz4 + a2^2*(m2+m3+m4)+a1*a2*cos(theta2)*(m2+m3+m4);
d13 = 0;
d14 = -Iz4;
d21 = Iz2 + Iz3 + Iz4 + a2^2*(m2+m3+m4)+2*a1*a2*cos(theta2)*(m2+m3+m4);
d22 = Iz2 + Iz3 + Iz4 + a2^2*(m2+m3+m4);
d23 = 0;
d24 = -Iz2;
d31 = 0;
d32 = 0;
d33 = m3+m4;
d34 = 0;
d41 = -Iz4;
d42 = -Iz4;
d43 = 0;
d44 = Iz4;

D = [d11 d12 d13 d14; d21 d22 d23 d24; d31 d32 d33 d34; d41 d42 d43 d44;];

%Matriz C
c112 = a1*a2*sin(theta2)*(m2+m3+m4);
C1 = [       0     -c112     0     0    
             c112  0         0     0 
             0     0         0     0
             0     0         0     0 
             ];
C2 = [       -c112 0         0     0    
             0     0         0     0 
             0     0         0     0
             0     0         0     0 
             ];
C3 = [       0     0         0     0    
             0     0         0     0 
             0     0         0     0
             0     0         0     0 
             ];
C4 = [       0     0         0     0    
             0     0         0     0 
             0     0         0     0
             0     0         0     0 
             ];
C = C1*theta1_dot + C2*theta2_dot;
%C�lculo da matriz G
G = [0; 0; -g*(m3+m4); 0];   

%%  Esfor�os nas juntas da trajet�ria desejada

%Vetor de Esfor�os
F = zeros(4,ntraj*div);
for k = 1:ntraj*div
    theta1 = trajetoria(k,1);
    theta2 = trajetoria(k,2);
    theta1_dot = vel(k,1);
    theta2_dot = vel(k,2);
    F(:,k) = eval(D)*acel(k,:)' + eval(C)*vel(k,:)'...
        + G;
end

figure(5);
for i = 1:4
     figure(5),subplot(2,2,i), plot(t,F(i,:));
    %Escolhe o print
    if i == 1
        title('Esfor�o de \theta_1')
        ylabel('\theta_1 [N.m]')
    elseif i == 2
        title('Esfor�o de \theta_2')
        ylabel('\theta_2 [N.m]')
    elseif i == 3
        title('Esfor�o de d_3')
        ylabel('d_3 [N]')
    elseif i == 4
        title('Esfor�o de \theta_4')
        ylabel('\theta_4 [N.m]')
    end
    xlabel('t [s]')
end

%%  Energia Cin�tica e Potencial

Ep = zeros(1,ntraj*div);
Ec = zeros(1,ntraj*div);
for i = 1:ntraj*div
    %Valores da trajetoria
    theta1_dot = vel(i,1);
    theta2_dot = vel(i,2);
    d3_dot = vel(i,3);
    theta4_dot = vel(i,4);
    theta1 = trajetoria(i,1);
    theta2 = trajetoria(i,2);
    d3 = trajetoria(i,3);
    tehta4 = trajetoria(i,4);
    
    %Energia potencial
    Ep(i) = sum([m1*g*d1 m2*g*d1 m3*g*(d1-d3) m4*g*(d1-d3-d4)]);
    
    %Energia Cin�tica
    Ec(i) = eval(d11)*theta1_dot + 2*eval(d12)*theta1_dot*theta2_dot ...
    +d14*(2*theta1_dot*theta4_dot + 2*theta2_dot*theta4_dot - theta4_dot) ...
    +d22*theta2_dot + d33*d3_dot^2;
    
    
end

%plota energias
figure(6); 
plot(t,Ep); 
title('Energia Potencial')
figure(7);
title('Energia Cin�tica')
plot(t,abs(Ec))

%%  C�lculo das incertezas

%Incertezas do manipulador
u2 = 0.015;
u3 = 0.015;
u4 = 0.010;

%Sensibilidade
syms d2 d3 d4;
pf = A1*A2*A3*A4*p0;
jac = jacobian(A1*A2*A3*A4*p0, [d2 d3 d4]);

ux = zeros(ntraj*div,1);
uy = zeros(ntraj*div,1);
uz = zeros(ntraj*div,1);
for i = 1:ntraj*div
    theta1 = trajetoria(i,1);
    theta2 = trajetoria(i,2);
    ux(i) = eval(( (jac(1,1)*u2)^2 + (jac(1,2)*u3)^2 + (jac(1,3)*u4)^2 )^2);
    uy(i) = eval(( (jac(2,1)*u2)^2 + (jac(2,2)*u3)^2 + (jac(2,3)*u4)^2 )^2);
    uz(i) = eval(( (jac(3,1)*u2)^2 + (jac(3,2)*u3)^2 + (jac(3,3)*u4)^2 )^2);
end

%Plota erros
subplot(2,2,1)
plot(t,ux)
subplot(2,2,2)
plot(t,ux)
subplot(2,2,3)
plot(t,ux)










