function [ R ] = rot( theta, axe, rad )
%Retorna a matriz de rota��o dado o theta em graus/rad e o eixo de rota��o
%1 � x, 2 � y e 3 � z

%Se rad n�o for preenchido n�o tem problema, supor graus
if ~exist('rad','var')
    %Caso o par�metro n�o exista resolve com graus
    rad = 0;
end

if rad == 0
    if(1 == axe)
        R = [1  0           0;
             0  cosd(theta) -sind(theta);
             0  sind(theta) cosd(theta)];
    end

    if(2 == axe)
        R = [cosd(theta)    0          sind(theta);
             0              1          0;
             -sind(theta)   0          cosd(theta)];
    end

    if(3 == axe)
        R = [cosd(theta)  -sind(theta)  0;
             sind(theta)  cosd(theta)   0;
             0            0             1]; 
    end
else
    if(1 == axe)
        R = [1  0           0;
             0  cos(theta) -sin(theta);
             0  sin(theta) cos(theta)];
    end

    if(2 == axe)
        R = [cos(theta)    0          sin(theta);
             0              1          0;
             -sin(theta)   0          cos(theta)];
    end

    if(3 == axe)
        R = [cos(theta)  -sin(theta)  0;
             sin(theta)  cos(theta)   0;
             0            0             1]; 
    end
end

end

