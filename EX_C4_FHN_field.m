% A script for producing the phase plot for the FitzHugh-Nagumo model.
%
% Copyright (C) 2025 by Lassi Paunonen (lassi.paunonen@tuni.fi)



alpha = 1;
beta = 1400;
gamma = 1000;

beta-gamma
2*beta-3*gamma+1

f = @(x) [-alpha*x(1,:).^3 + beta*x(1,:) - gamma*x(2,:);-x(2,:)+x(1,:)];
f1 = @(x,y) -gamma*x-alpha*y.^3+beta*y;
f2 = @(x,y) -x+y;

% alpha = 2;
% 
% 
% -6*alpha^2+7*alpha+1
% 
% f = @(x) [alpha*(x(1,:)-x(1,:).^3/3) - x(2,:);-x(2,:)+x(1,:)];
% f1 = @(x,y) -x+alpha*(y-y.^3/3);
% f2 = @(x,y) -x+y;


% f = @(x) [x(2,:);-(g/l)*x(1,:) - (k/m)*x(2,:)];
% f2 = @(x,y) -(g/l)*x - (k/m)*y;

[xx,yy] = meshgrid(linspace(-5,10,20),linspace(-3,3,20));

hold off
cla
quiver(xx,yy,f1(xx,yy),f2(xx,yy))
hold on
xlabel('$x_1$','interpreter','latex','fontsize',26)
ylabel('$x_2$','interpreter','latex','fontsize',26)
xlim([-5,5])
axis equal
% %
odefun = @(t,x) [-alpha*x(1,:).^3 + beta*x(1,:) - gamma*x(2,:);-x(2,:)+x(1,:)];

% odefun = @(t,x) [alpha*(x(1,:)-x(1,:).^3/3) - x(2,:);-x(2,:)+x(1,:)];

%
x0 = [pi/5;.35];
tspan = [0,10];

sol = ode45(odefun,tspan,x0);
tt = linspace(tspan(1),tspan(2),1301);
thetas = deval(sol,tt);
plot(thetas(1,:),thetas(2,:),'r','LineWidth',2)


% axis([-5,5,-3,3])
axis equal


%%
x0 = [pi/2;0];

sol = ode45(odefun,tspan,x0);
tt = linspace(tspan(1),tspan(2),301);
thetas = deval(sol,tt);


plot(thetas(1,:),thetas(2,:),'r','LineWidth',2)
xlim([-5,5])
% axis equal

%%
x0 = [pi/2;1.35];



sol = ode45(odefun,tspan,x0);
tt = linspace(tspan(1),tspan(2),301);
thetas = deval(sol,tt);

hold on
plot(thetas(1,:),thetas(2,:),'r','LineWidth',2)

%%
x0 = [-3;1.5];

sol = ode45(odefun,tspan,x0);
tt = linspace(tspan(1),tspan(2),301);
thetas = deval(sol,tt);

plot(thetas(1,:),thetas(2,:),'r','LineWidth',2)
xlim([-5,5])
%axis equal


%% Plot the total energy (kinetic + potential energy) of the pendulum as a function of time
figure(2)
plot(tt,sqrt(sum((1*[2*pi;0]*ones(1,length(tt))-thetas).^2,1)),'LineWidth',2)
axis([tt(1),tt(end),0,2.5])
grid on
%figure(3)
energy = (g/l)*(1-cos(thetas(1,:)))+ .5*thetas(2,:).^2;
plot(tt,energy,'LineWidth',2)
grid on
