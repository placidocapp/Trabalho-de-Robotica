% clear all;
% close all;
% clc

%%                      Lista de Jacobiano
%Exerc�cio 1

syms d1 d2 d3 d4
A1 = A(0,-90,d1,0)
A2 = A(0,-90,d2,-90)
A3 = A(0,-90,d3,90)
A4 = A(0,0,d4,0)

T1 = A1
T2 = A1*A2
T3 = T2*A3
T4 = T3*A4

%Simula o exerc�cio 
d1 = 1;
d2 = 1;
d3 = 1;
d4 = 1;

p0 =  [0;0;0;1];
T1 = eval(T1*p0);
T2 = eval(T2*p0);
T3 = eval(T3*p0);
T4 = eval(T4*p0);

%Plota
clf
plot3([p0(1) T1(1)],[p0(2) T1(2)],[p0(3) T1(3)], 'k');
hold on;
axis([-1 5 -1 5 -1 5])
plot3(T1(1),T1(2), T1(3), 'b*')
plot3(T2(1),T2(2), T2(3), 'g*')
plot3(T3(1),T3(2), T3(3), 'r*')
plot3([T1(1) T2(1)],[T1(2) T2(2)],[T1(3) T2(3)], 'k');
plot3([T2(1) T3(1)],[T2(2) T3(2)],[T2(3) T3(3)], 'k');
plot3([T3(1) T4(1)],[T3(2) T4(2)],[T3(3) T4(3)], 'k');
pause(0.05)