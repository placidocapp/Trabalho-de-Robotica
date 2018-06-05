clear all
close all
clc


syms d1 d2 d3 d4 d5 d6  Q1 Q2 Q3 Q4 Q5 Q6 a1 a2 a3 a4 a5 a6 alfa1 alfa2 alfa3 alfa4 alfa5 alfa6

DH = [0 -pi/2 0 Q1
      0  pi/2 d2 Q2
      0  0  d3 0
      0 -pi/2 0 Q4
      0 pi/2 0 Q5
      0 0 d6 Q6]


GD = size(DH);
GDL = GD(1,1);

for k =1:GDL
    a = DH(k,1);
    alfa = DH(k,2);
    d = DH(k,3);
    Q = DH(k,4);
    
    A = [cos(Q) -sin(Q)*cos(alfa)  sin(Q)*sin(alfa) a*cos(Q)
        sin(Q)  cos(Q)*cos(alfa) -cos(Q)*sin(alfa) a*sin(Q)
        0          sin(alfa)         cos(alfa)        d
        0              0              0               1] ;
    if k==1
        A01 = A
    elseif k ==2
        A12 = A
    elseif k ==3
        A23 = A
    elseif k ==4
        A34 = A
    elseif k ==5
        A45 = A
    elseif k ==6
        A56 = A
    end
end

ORI = [0
    0
    0]

    A01 = simplify(A01)
    A02 = simplify(A01*A12)
    A03 = simplify(A01*A12*A23)
    A04 = simplify(A01*A12*A23*A34)
    A05 = simplify(A01*A12*A23*A34*A45)
    A06 = simplify(A01*A12*A23*A34*A45*A56)
    XYZp = [ORI A01(1:3,4) A02(1:3,4)  A03(1:3,4) A04(1:3,4) A05(1:3,4) A06(1:3,4)]
    XYZ =  A06(1:3,4)

% return
X= XYZ(1,1)
Y= XYZ(2,1)
Z= XYZ(3,1)

J = [diff(X,Q1)   diff(X,Q2) diff(X,d3)  diff(X,Q4) diff(X,Q5) diff(X,Q6)
    diff(Y,Q1)   diff(Y,Q2)  diff(Y,d3) diff(Y,Q4) diff(Y,Q5) diff(Y,Q6)
    diff(Z,Q1)   diff(Z,Q2)  diff(Z,d3) diff(Z,Q4) diff(Z,Q5) diff(Z,Q6)]

% Jinv = J'*inv(J*J')

% Jinv =simplify(inv(J))

% return
clear d1 d2 d3 d4 d5 d6  Q1 Q2 Q3 Q4 Q5 Q6 a1 a2 a3 a4 a5 a6 alfa1 alfa2 alfa3 alfa4 alfa5 alfa6

d2 = 0.5
d6 =0.7

XYZo= [1
    1
    1]

Q1 = 0.1
Q2 = 0.5
d3 = 0.4
Q4 = 0.2
Q5 = 0.1
Q6 = 0.3

XYZP = eval(XYZp)

figure1 = figure('Color',[1 1 1], 'position',[800 150 800 500]);
axes1 = axes('Parent',figure1,'Layer','top','XAxisLocation','bottom','FontSize',12,'FontName','Times New Roman');
box(axes1,'on');
hold(axes1,'all');
hold on
box on
grid on
xlabel('Tempo [s]','FontSize',12,'FontName','Times New Roman');
ylabel('Força  ACT [N]','FontSize',12,'FontName','Times New Roman');
plot3 (XYZo(1,1),XYZo(2,1),XYZo(3,1) ,'r','MarkerSize',15,'Marker','+','linewidth',3);
plot3 (XYZP(1,:),XYZP(2,:),XYZP(3,:) ,'k','linewidth',2);
plot3 (XYZP(1,:),XYZP(2,:),XYZP(3,:) ,'.y','linewidth',2,'MarkerSize',10,'Marker','*');
view(axes1,[45 45]);


prompt = 'Iniciar Newton-Raphson?';
str = input(prompt,'s');
for k = 1:10
    XYZi = [eval(X)
        eval(Y)
        eval(Z)]
    
    Jn = eval(J)
    Jinv = Jn'*inv(Jn*Jn')
    
    ERRO = XYZo-XYZi;
    Qi = [Q1;Q2;d3;Q4;Q5;Q6] + Jinv*ERRO;
    Q1= Qi(1,1)
    Q2= Qi(2,1)
    d3= Qi(3,1)
    Q4= Qi(4,1)
    Q5= Qi(5,1)
    Q6= Qi(6,1)
    ERRO
    XYZP = eval(XYZp)
    
    if k ==1
        plot3 (XYZP(1,:),XYZP(2,:),XYZP(3,:) ,'g','linewidth',2);
        plot3 (XYZP(1,:),XYZP(2,:),XYZP(3,:) ,'.y','linewidth',2,'MarkerSize',10,'Marker','*');
        plot3 (XYZo(1,1),XYZo(2,1),XYZo(3,1) ,'r','MarkerSize',15,'Marker','+','linewidth',3);
    elseif k ==2
        plot3 (XYZP(1,:),XYZP(2,:),XYZP(3,:) ,'m','linewidth',2);
        plot3 (XYZP(1,:),XYZP(2,:),XYZP(3,:) ,'.y','linewidth',2,'MarkerSize',10,'Marker','*');
        plot3 (XYZo(1,1),XYZo(2,1),XYZo(3,1) ,'r','MarkerSize',15,'Marker','+','linewidth',3);
    elseif k ==3
        plot3 (XYZP(1,:),XYZP(2,:),XYZP(3,:) ,'c','linewidth',2);
        plot3 (XYZP(1,:),XYZP(2,:),XYZP(3,:) ,'.y','linewidth',2,'MarkerSize',10,'Marker','*');
        plot3 (XYZo(1,1),XYZo(2,1),XYZo(3,1) ,'r','MarkerSize',15,'Marker','+','linewidth',3);
    elseif k ==4
        plot3 (XYZP(1,:),XYZP(2,:),XYZP(3,:) ,'r','linewidth',2);
        plot3 (XYZP(1,:),XYZP(2,:),XYZP(3,:) ,'.y','linewidth',2,'MarkerSize',10,'Marker','*');
        plot3 (XYZo(1,1),XYZo(2,1),XYZo(3,1) ,'r','MarkerSize',15,'Marker','+','linewidth',3);
    elseif k ==5
       plot3 (XYZP(1,:),XYZP(2,:),XYZP(3,:) ,'b','linewidth',2);
        plot3 (XYZP(1,:),XYZP(2,:),XYZP(3,:) ,'.y','linewidth',2,'MarkerSize',10,'Marker','*');
        plot3 (XYZo(1,1),XYZo(2,1),XYZo(3,1) ,'r','MarkerSize',15,'Marker','+','linewidth',3);
    else
        plot3 (XYZP(1,:),XYZP(2,:),XYZP(3,:) ,'k','linewidth',2);
        plot3 (XYZP(1,:),XYZP(2,:),XYZP(3,:) ,'.y','linewidth',2,'MarkerSize',10,'Marker','*');
        plot3 (XYZo(1,1),XYZo(2,1),XYZo(3,1) ,'r','MarkerSize',15,'Marker','+','linewidth',3);
    end
    
    prompt = 'Nova iterração?';
    str = input(prompt,'s');
    figure(1)
end

