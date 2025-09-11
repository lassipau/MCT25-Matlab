% Example: Proportional-Integral control for a moving robot.
%
% Copyright (C) 2025 by Lassi Paunonen (lassi.paunonen@tuni.fi)

% Moving robot model
A = 0;
B = 1;
C = 1;
D = 0;

% 'yref' is the location where we want to go
yref_point = -1+2i;
yref = @(t) yref_point*ones(size(t));

% % Proportional control only

dist = @(t) zeros(size(t));
dist = @(t) .1*ones(size(t));

% Tracking error is e(t)=y(t)-yref, and if u(t)=K_P*e(t), our system has
% the form 
% x' = Ax+Bu = K_P*e(t) = K_P*(x(t)-yref)
% 
% If we have an external disturbance, we have
% x' = Ax+Bu+d= K_P*e(t) + d(t) = K_P*x(t)-K_P*yref+d

% Choose K_P negative
K_P=-.5;

x0=0;
tspan = [0,10];

sol = LinSysSim(K_P,1,x0,@(t)-K_P*yref(t)+dist(t),tspan);

tt = linspace(tspan(1),tspan(2),500);
xx = deval(sol,tt);

figure(1)
cla
hold on
plot(real(xx),imag(xx),'LineWidth',2)
plot(real(xx(:,1))',imag(xx(:,1))','bo','markersize',10,'markerfacecolor',[0, 0.4470, 0.7410],'markeredgecolor','k','linewidth',2);
grid on

% LinSysOutputPlot(sol,C,D,yref,301);


figure(2)
% Plot the output and the reference
yrefvals = yref(tt);
plot(tt,[real(yrefvals);imag(yrefvals);real(xx);imag(xx)],'Linewidth',2)
title('Position of the robot (x and y coordinates)','Interpreter','Latex','Fontsize',16)
grid on

figure(3)
% Plot the norm of the tracking error
yrefvals = yref(tt);
plot(tt,abs(xx-yrefvals),'Linewidth',2)
title('The tracking error $e(t)$','Interpreter','Latex','Fontsize',16)
grid on


%% Proportional-Integral control (no disturbance!)




% Construct the PI-controller
% Choose parameters K_P to stabilize A+B*K_P*C, 
% and the gain parameter eps>0

epsval = 0.13;
epsval = 0.05;
% epsval = .2;
% epsval = 3.5;

[Ae,Be,Ce,De] = LinSysPIClosedLoop(A,B,C,K_P,epsval);

% figure(2)
% LinSysPlotEigs(Ae,[-1,0,-3,3])


% %


yref = @(t) -4+3i;
% yref = @(t) (-4+3i)*(t<30) + (-2)*(t>=30);
% yref = @(t) 0.1*sin(0.05*t);


% The closed-loop system can be simulated with 'LinSysSim', now with the
% input function 'yref(t)'

% Initial state of the oscillator
x0 = 0;
% Initial state of the PI-controller
xc0 = 0;

tspan = [0 60];

sol = LinSysSim(Ae,Be,[x0;xc0],yref,tspan);

tt = linspace(tspan(1),tspan(2),500);
xxe = deval(sol,tt);

% The output of the controlled system is C*x(t) = [C,zeros(p)]*x_e(t)
yy = [C,0]*xxe;

% Tracking error

% Values of yref(t) for plotting
yrefvals = zeros(1,length(tt));
for ind = 1:length(tt), yrefvals(ind)=yref(tt(ind)); end

figure(2)
% Plot the output and the reference
hold off
cla
plot(tt,[real(yrefvals);imag(yrefvals);real(yy);imag(yy)],'Linewidth',2)
title(['Output for $K_P= ' num2str(K_P) '$ and $\varepsilon= ' num2str(epsval) '$'],'Interpreter','Latex','Fontsize',16)


figure(3)
hold off
cla
hold on
plot(real(yy),imag(yy),'LineWidth',2)
plot(real(yy(:,1))',imag(yy(:,1))','bo','markersize',10,'markerfacecolor',[0, 0.4470, 0.7410],'markeredgecolor','k','linewidth',2);
grid on

