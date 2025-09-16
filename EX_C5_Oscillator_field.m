% A script for producing the phase plot for the nonlinear harmonic
% oscillator.
%
% Copyright (C) 2023 by Lassi Paunonen (lassi.paunonen@tuni.fi)


% Mass of the pendulum m. The hardening spring produces force
% -k(1+aq(t)^2)q(t) with k,a>0
m = 1; k = 1; a = 0.5;

% Negative velocity feedback to stabilize the system, F(t)=-d \dot{q}(t)
d = .1;
%d = 0;

f = @(x) [x(2,:);-k*(1+a*x(1,:).^2).*x(1,:) - d*x(2,:)];
f1 = @(x,y) y;
f2 = @(x,y) -k*(1+a*x.^2).*x - d*y;

[xx,yy] = meshgrid(linspace(-2,2,20),linspace(-3,3,20));

hold off
cla
quiver(xx,yy,f1(xx,yy),f2(xx,yy))
hold on
xlabel('Angle $\theta(t)$','interpreter','latex','fontsize',16)
ylabel('Velocity $\dot{\theta}(t)$','interpreter','latex','fontsize',16)


odefun = @(t,x) f(x);

tspan = [0,40];

x0 = [pi/2;1];

sol = ode45(odefun,tspan,x0);
tt = linspace(tspan(1),tspan(2),301);
thetas = deval(sol,tt);


plot(thetas(1,:),thetas(2,:),'b','LineWidth',2)
%%
x0 = [-3;1.5];

sol = ode45(odefun,tspan,x0);
tt = linspace(tspan(1),tspan(2),301);
thetas = deval(sol,tt);

plot(thetas(1,:),thetas(2,:),'b','LineWidth',2)
%%
x0 = [pi/2;1.35];



sol = ode45(odefun,tspan,x0);
tt = linspace(tspan(1),tspan(2),301);
thetas = deval(sol,tt);

hold on
plot(thetas(1,:),thetas(2,:),'b','LineWidth',2)

%%
x0 = [pi/5;.35];

sol = ode45(odefun,tspan,x0);
tt = linspace(tspan(1),tspan(2),301);
thetas = deval(sol,tt);
plot(thetas(1,:),thetas(2,:),'b','LineWidth',2)


axis([-5,10,-3,3])
axis equal

%% 
figure(2)
plot(tt,sqrt(sum((1*[2*pi;0]*ones(1,length(tt))-thetas).^2,1)),'LineWidth',2)
axis([tt(1),tt(end),0,2.5])
grid on
%figure(3)
energy = (g/l)*(1-cos(thetas(1,:)))+ .5*thetas(2,:).^2;
plot(tt,energy,'LineWidth',2)
grid on
