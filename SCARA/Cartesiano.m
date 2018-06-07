clear all;
close all;
clc

format short;
%% Iniciliza��o  

%Vari�veis das juntas
syms d1 d2 d3

%Referencial 0
p0 = [0;0;0;1]; %Incio da junta, chutes iniciais abaixo

%Posi��o desejada
pfinal = [2;2;2;1];

%P�sso
ds = 0.01;

%% SCARA

% Calcula a matriz de rota��o
A1 = A(0, 0, d1, 0, 1);
A2 = A(0, 0, d2, 0, 1);
A2 = hom(pi/2, zeros(3,1), 1, 1)*A2;
A3 = A(0, 0, d3, 0, 1);
A3 = hom(-pi/2, zeros(3,1), 3, 1)*hom(pi/2, zeros(3,1), 1, 1)*A3;

%Posi��o de cada junta
T1_s = A1*p0;
T2_s = A1*A2*p0;
T3_s = A1*A2*A3*p0;
%%TESTE
%         d1 = 1;
%         d2 = 1;
%         d3 = 1;
%         T1 = eval(T1_s);
%         T2 = eval(T2_s);
%         T3 = eval(T3_s);
% plot3([p0(1) T1(1)],[p0(2) T1(2)],[p0(3) T1(3)], 'k');
% hold on;
%     axis([-3 3 -3 3 -3 3])
%     plot3(T1(1),T1(2), T1(3), 'b*')
%     plot3(T2(1),T2(2), T2(3), 'g*')
%     plot3(T3(1),T3(2), T3(3), 'c*')
%     plot3([T1(1) T2(1)],[T1(2) T2(2)],[T1(3) T2(3)], 'k');
%     plot3([T2(1) T3(1)],[T2(2) T3(2)],[T2(3) T3(3)], 'k');
%     return
%%TESTE
%Tira o jacobiano
Jacobiano = jacobian(T3_s, [d1 d2 d3]);
Jacobiano = simplify(Jacobiano);

%Chute inicial
d1 = 1;
d2 = 1;
d3 = 1;

%Trajet�ria
pini = eval(T3_s);      %Posi��o inicial da ponta do robo
trajetoria = [ linspace(pini(1,1),pfinal(1,1),inv(ds));
               linspace(pini(2,1),pfinal(2,1),inv(ds));
               linspace(pini(3,1),pfinal(3,1),inv(ds));
               linspace(pini(4,1),pfinal(4,1),inv(ds))];

%Par�metros
maxIter = 100;
d(:,1) = [d1; d2; d3];
eps = 10^-4;

%Posi��o inicial
pos_inicial = eval(A1*A2*A3*p0);

for i = 2:inv(ds)
    pf = trajetoria(:,i);
    k = 1;
    %Loop para cinem�tica reversa
    while (1)
        %Descobre as posi��es das juntas
        T1 = eval(T1_s);
        T2 = eval(T2_s);
        T3 = eval(T3_s);
        J = eval(Jacobiano);

        %Faz a itera��o do algoritmo
        dx = pinv(J)*(pf - T3);
        d(:,k+1) = d(:,k) + dx;
        erro_de_posicao = pf - T3;
        d1 = d(1,k+1);
        d2 = d(2,k+1);
        d3 = d(3,k+1);

        k = k+1;
        if (sum(abs(erro_de_posicao) < eps) == 4)||(sum(dx < 10^-10) == 4)||(k > maxIter)
            erro_de_posicao
            k
            %atualiza novo theta
            d(:,1) = d(:,k-1);
            d(:,1);
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
    plot3([T1(1) T2(1)],[T1(2) T2(2)],[T1(3) T2(3)], 'k');
    plot3([T2(1) T3(1)],[T2(2) T3(2)],[T2(3) T3(3)], 'k');
    pause(0.05);
    
    %Atualiza a posi��o incial como a posi��o atual do robo
    pos_inicial = T3;
    
%end for
end























