clear all;
close all;
clc

%%  Rascunho
syms t1 t2 d1 d2 d3
A1 = A(0, pi/2, d1, t1, 1)
A2 = A(0, -pi/2, 0, t2, 1)

T2 = A1*A2;
T2 = simplify(T2)