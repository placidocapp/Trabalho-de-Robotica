function [ R ] = A( a, alpha, d, theta, rad )
%Dadas as entradas de deslocamento em x e z, rota��o em x e z retorna a
%matriz de rota��o pelo m�todo Denavit-Hartenberg

%Se rad n�o for preenchido n�o tem problema, supor graus
if ~exist('rad','var')
    %Caso o par�metro n�o exista resolve com graus
    rad = 0;
end

R = hom(theta, zeros(3,1), 3, rad)*...  %Rota��o de theta em z
    hom(0, [0; 0; d], 3, rad)*...       %Transla��o de d em z                         
    hom(0, [a; 0; 0], 1, rad)*...       %Transla��o de a em x
    hom(alpha, zeros(3,1), 1, rad);     %Rota��o de alpha em x


end

