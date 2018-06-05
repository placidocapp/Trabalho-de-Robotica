clear all
close all
clc


syms d1 d2 d3 d4 d5 d6  Q1 Q2 Q3 Q4 Q5 Q6 a1 a2 a3 a4 a5 a6 alfa1 alfa2 alfa3 alfa4 alfa5 alfa6

DH = [a1 0 0 Q1
    a2 0 0 Q2]


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
    end
end

ORI = [0
    0]

    A01 = simplify(A01)
    A02 = simplify(A01*A12)
    XYp = [ORI A01(1:2,4) A02(1:2,4)]


XY =  A02(1:2,4)
X= A02(1,4)
Y= A02(2,4)

J = [diff(X,Q1)   diff(X,Q2)
    diff(Y,Q1)   diff(Y,Q2)]

Jinv =inv(J)
clear d1 d2 d3 d4 d5 d6  Q1 Q2 Q3 Q4 Q5 Q6 a1 a2 a3 a4 a5 a6 alfa1 alfa2 alfa3 alfa4 alfa5 alfa6

a1 = 0.7
a2 = 0.9
XYo= [1
    1]
Q1 = pi/3
Q2 = -pi/3

XYP = eval(XYp) 

figure1 = figure('Color',[1 1 1], 'position',[1250 150 600 300]);
axes1 = axes('Parent',figure1,'Layer','top','XAxisLocation','bottom','FontSize',12,'FontName','Times New Roman');
box(axes1,'on');
hold(axes1,'all');
hold on
box on
grid on
xlabel('Tempo [s]','FontSize',12,'FontName','Times New Roman');
ylabel('Força  ACT [N]','FontSize',12,'FontName','Times New Roman');
set(plot (XYo(1,1),XYo(2,1),'r'),{'linewidth'},{2},'MarkerSize',15,'Marker','+');
set(plot (XYP(1,:),XYP(2,:),'k'),{'linewidth'},{2});
set(plot (XYP(1,:),XYP(2,:),'.y'),{'linewidth'},{5},'MarkerSize',10,'Marker','*');

    prompt = 'Iniciar Newton-Raphson?';
    str = input(prompt,'s');
for k = 1:5
    XYi = [eval(X)
        eval(Y)]
    
    ERRO = XYo-XYi;
    Qi = [Q1;Q2] + eval(Jinv)*(ERRO);  
    Q1= Qi(1,1)
    Q2= Qi(2,1)
    ERRO
    XYP = eval(XYp) 
    
    if k ==1
    set(plot (XYP(1,:),XYP(2,:),'g'),{'linewidth'},{2});
    set(plot (XYP(1,:),XYP(2,:),'.y'),{'linewidth'},{5},'MarkerSize',10,'Marker','*');
    set(plot (XYo(1,1),XYo(2,1),'r'),{'linewidth'},{2},'MarkerSize',15,'Marker','+');
    elseif k ==2
            set(plot (XYP(1,:),XYP(2,:),'m'),{'linewidth'},{2});
    set(plot (XYP(1,:),XYP(2,:),'.y'),{'linewidth'},{5},'MarkerSize',10,'Marker','*');
    set(plot (XYo(1,1),XYo(2,1),'r'),{'linewidth'},{2},'MarkerSize',15,'Marker','+');
     elseif k ==3
            set(plot (XYP(1,:),XYP(2,:),'c'),{'linewidth'},{2});
    set(plot (XYP(1,:),XYP(2,:),'.y'),{'linewidth'},{5},'MarkerSize',10,'Marker','*');
    set(plot (XYo(1,1),XYo(2,1),'r'),{'linewidth'},{2},'MarkerSize',15,'Marker','+');
     elseif k ==4
            set(plot (XYP(1,:),XYP(2,:),'r'),{'linewidth'},{2});
    set(plot (XYP(1,:),XYP(2,:),'.y'),{'linewidth'},{5},'MarkerSize',10,'Marker','*');
    set(plot (XYo(1,1),XYo(2,1),'r'),{'linewidth'},{2},'MarkerSize',15,'Marker','+');
    else
            set(plot (XYP(1,:),XYP(2,:),'b'),{'linewidth'},{2});
    set(plot (XYP(1,:),XYP(2,:),'.y'),{'linewidth'},{5},'MarkerSize',10,'Marker','*');
    set(plot (XYo(1,1),XYo(2,1),'r'),{'linewidth'},{2},'MarkerSize',15,'Marker','+');
    end
     
    prompt = 'Nova iterração?';
    str = input(prompt,'s');
    figure(1)
end

