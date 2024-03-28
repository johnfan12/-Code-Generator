draw_line_interpolation(10, 10, 60, 60, 2);
draw_line_interpolation(60, 60, 30, 20, 2);
function draw_line_interpolation(X0, Y0, Xe, Ye, h)
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
    pause(0.1);
end

xlabel('X')
ylabel('Y')
title(['四象限直线插补'])
hold on;
end


