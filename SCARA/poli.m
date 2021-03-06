function [ x ] = poli( ti, pi, tf, pf, vi, vf )
%Gera uma trajetoria c�bica a partir do ponto inicial e final

%% Calcula coeficientes
A = [1 ti ti^2 ti^3
     0 1  2*ti 3*ti^2
     1 tf tf^2 tf^3
     0 1  2*tf 3*tf^2];
b = [pi; vi; pf; vf];
x = A\b;

end

