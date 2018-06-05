function [ R ] = A( a, alpha, d, theta, rad )
%Dadas as entradas de deslocamento em x e z, rotação em x e z retorna a
%matriz de rotação pelo método Denavit-Hartenberg

%Se rad não for preenchido não tem problema, supor graus
if ~exist('rad','var')
    %Caso o parâmetro não exista resolve com graus
    rad = 0;
end

R = hom(theta, zeros(3,1), 3, rad)*...  %Rotação de theta em z
    hom(0, [0; 0; d], 3, rad)*...                           
    hom(0, [a; 0; 0], 1, rad)*...
    hom(alpha, zeros(3,1), 1, rad);


end

