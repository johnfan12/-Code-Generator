
% 主函数
main(0.04); %插补时间间隔控制速度

function draw_line(X0, Y0, Xe, Ye, h, speed) % 脚本包装成函数
% 该函数用于在二维平面上，从起点(X0, Y0)到终点(Xe, Ye)进行直线插补绘图。
% 输入参数：
% X0, Y0 - 起点坐标
% Xe, Ye - 终点坐标
% h - 步长

x = [X0, Xe];
y = [Y0, Ye];
hold on;

Xe = Xe - X0;
Ye = Ye - Y0;
NXY = (abs(Xe) + abs(Ye)) / h;
step = 0;
Fm = 0;
Xm = X0;
Ym = Y0;
XOY = 1; % 默认象限，根据坐标变化进行调整

% 根据Xe和Ye的正负判断象限
if (Xe > 0 && Ye >= 0), XOY = 1; end
if (Xe <= 0 && Ye > 0), XOY = 2; end
if (Xe < 0 && Ye <= 0), XOY = 3; end
if (Xe >= 0 && Ye < 0), XOY = 4; end

Xe = abs(Xe);
Ye = abs(Ye);

% 根据不同象限进行插补绘图
while (step < NXY)
    switch XOY
        case 1
            if (Fm >= 0)
                x1 = [Xm, Xm + h];
                Fm = Fm - Ye;
                y1 = [Ym, Ym];
            else
                x1 = [Xm, Xm];
                y1 = [Ym, Ym + h];
                Fm = Fm + Xe;
            end
            % 类似的case 2, 3, 4逻辑
        case 2
            if(Fm>=0)
                x1=[Xm,Xm-h];
                Fm=Fm-Ye;
                y1=[Ym,Ym];
            else
                x1=[Xm,Xm];
                y1=[Ym,Ym+h];
                Fm=Fm+Xe;
            end
        case 3
            if(Fm>=0)
                x1=[Xm,Xm-h];
                Fm=Fm-Ye;
                y1=[Ym,Ym];
            else
                x1=[Xm,Xm];
                y1=[Ym,Ym-h];
                Fm=Fm+Xe;
            end
        case 4
            if(Fm>=0)
                x1=[Xm,Xm+h];
                Fm=Fm-Ye;
                y1=[Ym,Ym];
            else
                x1=[Xm,Xm];
                y1=[Ym,Ym-h];
                Fm=Fm+Xe;
            end
    end
    step = step + 1;
    plot(x1, y1, 'k-', 'linewidth', 3);
    Xm = x1(2);
    Ym = y1(2);
    hold on;
    pause(speed);
end

xlabel('X')
ylabel('Y')
title(['四象限直线插补'])
hold on;
end

function circle(X0, Y0, Xe, Ye, pace, RNSS)
R=sqrt(X0*X0+Y0*Y0); 
alpha=0:pi/20:0.5*pi;
xx=R*cos(alpha); 
yy=R*sin(alpha); 
plot(xx,yy,'--k','linewidth',3);
grid on;
hold on;
xlabel('X');
ylabel('Y');
title('圆弧插补');
axis equal;
XM=X0;
YM=Y0;
Xe=Xe-X0;
Ye=Ye-Y0;
NXY=(abs(Xe)+abs(Ye))/pace;
step=0;
F=0;
%针对跨象限运行时对ZF初始化(由于在跨象限运行时不改变ZF值所以必须对其初始化)
ZF=(RNSS==1)*(((Y0==0)*((X0>0)*4+(X0<0)*3))+((X0==0)*((Y0>0)*1+(Y0<0)*2)))+...
    (RNSS~=1)*(((Y0==0)*((X0>0)*3+(X0<0)*4))+((X0==0)*((Y0>0)*2+(Y0<0)*1)));

  %象限判断(RNS为1,2,3,4分别代表1,2,3,4象限
if(RNSS==2)

if(XM>0&YM>=0)
RNS=1;
end
if(XM<=0&YM>0)
RNS=2;
end
 if(XM<0&YM<=0)
RNS=3;
end
if(XM>=0&YM<0)
RNS=4;
end
while (step<NXY)
F=XM*XM+YM*YM-X0*X0-Y0*Y0;
%走步计算(RNS百位为1表示逆时针画圆,十位为1表示F>=0,个位数字表示所在象限,ZF代表走步方向)
    switch RNS+((F>=0)*10)+(RNSS~=1)*100                      
        case 001
            ZF=1;
        case 002
            ZF=3;
        case 003
            ZF=2;
        case 004
            ZF=4;
        case 011
            ZF=4;
        case 012
            ZF=1;
        case 013
            ZF=3;
        case 014
            ZF=2; 
        case 101
            ZF=3;
        case 102
            ZF=2;
        case 103
            ZF=4;
        case 104
            ZF=1;
         case 111
            ZF=2;
        case 112
            ZF=4;
        case 113
            ZF=1;
        case 114
            ZF=3;
    end
%步进电机走步(由ZF控制走步方向由pace控制步长) 
    switch ZF                        
        case 1
            x1=[XM,XM+pace];         
            y1=[YM,YM];
        case 2
            x1=[XM,XM-pace];
            y1=[YM,YM];
        case 3
            x1=[XM,XM];
            y1=[YM,YM+pace];
        case 4
            x1=[XM,XM];
            y1=[YM,YM-pace];
    end
    step=step+1;
    plot(x1,y1,'k-','linewidth',3);                 %由此点和前一点坐标组成的2个向量画直线
    XM=x1(2);                    %保存此点坐标供下次作图和比较时使用
    YM=y1(2);
    hold on;                                                   
    pause(0.05);                    %延时程序形参为每走一步所用时间  
end
end





%象限判断(RNS为1,2,3,4分别代表1,2,3,4象限
if(RNSS==1)

if(XM>=0&YM>0)
RNS=1;
end
if(XM<0&YM>=0)
RNS=2;
end
 if(XM<=0&YM<0)
RNS=3;
end
if(XM>0&YM<=0)
RNS=4;
end
while (step<NXY)
F=XM*XM+YM*YM-X0*X0-Y0*Y0;
%走步计算(RNS百位为1表示顺时针画圆,十位为1表示F>=0,个位数字表示所在象限,ZF代表走步方向)
    switch RNS+((F>=0)*10)+(RNSS==1)*100                      
        case 001
            ZF=3;
        case 002
            ZF=2;
        case 003
            ZF=4;
        case 004
            ZF=1;
        case 011
            ZF=2;
        case 012
            ZF=4;
        case 013
            ZF=1;
        case 014
            ZF=3; 
        case 101
            ZF=1;
        case 102
            ZF=3;
        case 103
            ZF=2;
        case 104
            ZF=4;
         case 111
            ZF=4;
        case 112
            ZF=1;
        case 113
            ZF=3;
        case 114
            ZF=2;
    end
%步进电机走步(由ZF控制走步方向由pace控制步长) 
    switch ZF                        
        case 1
            x1=[XM,XM+pace];         
            y1=[YM,YM];
        case 2
            x1=[XM,XM-pace];
            y1=[YM,YM];
        case 3
            x1=[XM,XM];
            y1=[YM,YM+pace];
        case 4
            x1=[XM,XM];
            y1=[YM,YM-pace];
    end
    step=step+1;
    plot(x1,y1,'k-','linewidth',3);                 %由此点和前一点坐标组成的2个向量画直线
    XM=x1(2);                    %保存此点坐标供下次作图和比较时使用
    YM=y1(2);
    hold on; 
                                                  
    pause(0.1);                    %延时程序形参为每走一步所用时间  
end
end
hold on;
end

function main (speed)
    % 填入生成的代码👇


    % 填入生成的代码👆
end