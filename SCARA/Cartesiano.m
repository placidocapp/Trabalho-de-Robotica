clear all;
close all;
clc

format short;
%% Iniciliza��o  

%Vari�veis das juntas
syms d1 d2 d3 d4

%Referencial 0
p0 = [0;0;0;1]; %Incio da junta, chutes iniciais abaixo

%Posi��o desejada
pfinal = [0.5;2;0.2;1];

%Passo
ds = 0.1;

%Passo para plote da trajet�ria
dss = 0.01;

%Tempo inicial e final
ti = 0;
tf = 1;

%Velocidades iniciais e finais
vi = 0;
vf = 0;

%Acelera��es iniciais e finais
ai = 0;
af = 0;

%% SCARA

% Calcula a matriz de rota��o
A1 = A(0,-90,d1,0);
A2 = A(0,-90,d2,-90);
A3 = A(0,-90,d3,90);
A4 = A(0,0,d4,0);

%Posi��o de cada junta
T1_s = A1*p0;
T2_s = A1*A2*p0;
T3_s = A1*A2*A3*p0;
T4_s = A1*A2*A3*A4*p0;

%Tira o jacobiano
Jacobiano = jacobian(T4_s, [d2 d3 d4]);
Jacobiano = simplify(Jacobiano);

%Chute inicial
d1 = 1;
d2 = 0.746846267080342;
d3 = 1;
d4 = 0.200000000000000;

%Trajet�ria
pini = eval(T4_s);      %Posi��o inicial da ponta do robo
trajetoria = [ linspace(pini(1,1),pfinal(1,1),inv(ds));
               linspace(pini(2,1),pfinal(2,1),inv(ds));
               linspace(pini(3,1),pfinal(3,1),inv(ds));
               linspace(pini(4,1),pfinal(4,1),inv(ds))];

%Par�metros
maxIter = 100;
d(:,1) = [d2; d3; d4];
eps = 10^-4;
thetaFinal = zeros(3,inv(ds));
thetaFinal(:,1) = d(:,1);

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
        dx = pinv(J)*(pf - T4);
        d(:,k+1) = d(:,k) + dx;
        erro_de_posicao = pf - T4;
        d2 = d(1,k+1);
        d3 = d(2,k+1);
        d4 = d(3,k+1);

        k = k+1;
        if (sum(abs(erro_de_posicao) < eps) == 4)||(sum(dx < 10^-10) == 4)||(k > maxIter)
            erro_de_posicao;
            k;
            %atualiza novo theta
            d(:,1) = d(:,k-1);
            d(:,1);
            break;
        end 
        
    %end while
    end
    
%     %Plota
%     clf
%     plot3(pini(1,1),pini(2,1),pini(3,1),'.b');
%     hold on;
%     axis([-1 3 -1 3 -1 3])
%     plot3(pfinal(1,end),pfinal(2,end),pfinal(3,end),'.r');
%     plot3(pf(1,end),pf(2,end),pf(3,end),'*r');
%     plot3([p0(1) T1(1)],[p0(2) T1(2)],[p0(3) T1(3)], 'k');
%     plot3(T1(1),T1(2), T1(3), 'b*')
%     plot3(T2(1),T2(2), T2(3), 'g*')
%     plot3([T1(1) T2(1)],[T1(2) T2(2)],[T1(3) T2(3)], 'k');
%     plot3([T2(1) T3(1)],[T2(2) T3(2)],[T2(3) T3(3)], 'k');
%     pause(0.05);
    
    %Atualiza a posi��o incial como a posi��o atual do robo
    pos_inicial = T4;
    thetaFinal(:,i) = d(:,k-1);
    
%end for
end


%%  Calcular trajet�ria junta a junta

%Numero de divisoes
div = floor(1/dss);

%Gera as trajet�rias
trajetoria = zeros(div,size(d,1));
vel = zeros(div,size(d,1));
acel = zeros(div,size(d,1));
t = linspace(ti,tf,div);
figure(1);
figure(2);
figure(3);
for i = 1:size(d,1)
    aux = poli2(ti, thetaFinal(i,1), tf, thetaFinal(i,end), vi, vf, ai, af);
    for k = 1:size(t,2)
        trajetoria(k,i) = aux'*[1; t(k); t(k)^2; t(k)^3; t(k)^4; t(k)^5];
        vel(k,i) = aux'*[0; 1; 2*t(k); 3*t(k)^2; 4*t(k)^3; 5*t(k)^4];
        acel(k,i) = aux'*[0; 0; 2; t(k)^3; t(k)^4; t(k)^5];
    end
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
for i = 1:size(trajetoria,1)
    
    %Novas posi��es de cada junta
    d2 = trajetoria(i,1);
    d3 = trajetoria(i,2);
    d4 = trajetoria(i,3);

    %Calcula posi��es do robo
    T1 = eval(T1_s);
    T2 = eval(T2_s);
    T3 = eval(T3_s);
    T4 = eval(T4_s);
    
    %Plota
    figure(4)
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
end

%% Modelo din�mico do sistema

%Par�metros do sistema
m = 15;     % [kg] para cada junta
g = 9.81;   % [m/s^2]

%Jacobianos de Velocidade 
Jv1 = [0 0 0;
       0 0 0;
       1 0 0];
Jv2 = [0 0 0;
       0 1 0;
       1 0 0];
Jv3 = [0 0 1;
       0 1 0;
       1 0 0];
% Jw = 0 para todos os elos !
   
% C�lculo dos valores de D
D1 = m*Jv1'*Jv1;
D2 = m*Jv2'*Jv2;  
D3 = m*Jv3'*Jv3;   
   
D = D1 + D2 + D3;

%Nesse caso a matriz C � zero para todos os coeficientes !
%       C = 0

%C�lculo da matriz G
G = [g*(m+m+m); 0; 0];   

%%  Esfor�os nas juntas da trajet�ria desejada

%Vetor de Esfor�os
F = zeros(3,div);
for k = 1:div
    F(:,k) = D*acel(k,:)'+ G;
end

figure(5);
for i = 1:3
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






















