function [ R ] = hom( theta, d, axe, rad )
%Retorna a matriz de rotação dado o theta em graus/rad e o eixo de rotação
%1 é x, 2 é y e 3 é z

%Se rad não for preenchido não tem problema, supor graus
if ~exist('rad','var')
    %Caso o parâmetro não exista resolve com graus
    rad = 0;
end

if rad == 0
    if(1 == axe)
        R = [1  0           0              d(1);
             0  cosd(theta) -sind(theta)   d(2);
             0  sind(theta) cosd(theta)    d(3);
             0  0           0              1];
    end

    if(2 == axe)
        R = [cosd(theta)    0          sind(theta)  d(1);
             0              1          0            d(2);
             -sind(theta)   0          cosd(theta)  d(3);
             0              0          0            1];
    end

    if(3 == axe)
        R = [cosd(theta)  -sind(theta)  0   d(1);
             sind(theta)  cosd(theta)   0   d(2);
             0            0             1   d(3);
             0            0             0   1]; 
    end
else
    if(1 == axe)
        R = [1  0           0           d(1);
             0  cos(theta) -sin(theta)  d(2);
             0  sin(theta) cos(theta)	d(3);
             0  0          0            1];
    end

    if(2 == axe)
        R = [cos(theta)    0          sin(theta)    d(1);
             0              1          0            d(2);
             -sin(theta)   0          cos(theta)    d(3);
             0             0          0             1]; 
    end

    if(3 == axe)
        R = [cos(theta)  -sin(theta)  0     d(1);
             sin(theta)  cos(theta)   0     d(2);
             0           0            1     d(3);
             0           0            0     1]; 
    end
end

end

