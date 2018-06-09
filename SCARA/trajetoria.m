function [ x ] = trajetoria( ti, pi, tf, pf, vi, vf )
%Gera uma trajetoria cúbica a partir do ponto inicial e final

%% Calcula coeficientes
A = [1 ti ti^2 ti^3
     0 1  2*ti 3*ti
     1 tf tf^2 tf^3
     0 1  2*tf 3*tf];
b = [pi; vi; pf; vf];
x = A\b;

end

