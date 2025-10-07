% A script for producing the phase plot for the nonlinear pendulum.
%
% Copyright (C) 2023 by Lassi Paunonen (lassi.paunonen@tuni.fi)


m = 1; l=1; g = 1; 
% Can experiment with different values of the damping coefficient
k = .1;
%k=.05;
k = 0;

f = @(x) [x(2,:);-(g/l)*sin(x(1,:)) - (k/m)*x(2,:)];
f1 = @(x,y) y;
f2 = @(x,y) -(g/l)*sin(x) - (k/m)*y;


% f = @(x) [x(2,:);-(g/l)*x(1,:) - (k/m)*x(2,:)];
% f2 = @(x,y) -(g/l)*x - (k/m)*y;

[xx,yy] = meshgrid(linspace(-5,10,20),linspace(-3,3,20));

hold off
cla
quiver(xx,yy,f1(xx,yy),f2(xx,yy))
hold on
xlabel('Angle $\theta(t)$','interpreter','latex','fontsize',16)
ylabel('Velocity $\dot{\theta}(t)$','interpreter','latex','fontsize',16)
xlim([-5,5])
axis equal
%%
odefun = @(t,x) [x(2);-(g/l)*sin(x(1)) - (k/m)*x(2)];

odefun = @(t,x) [x(2);-(g/l)*x(1) - (k/m)*x(2)];

%%
x0 = [pi/5;.35];
tspan = [0,16];

sol = ode45(odefun,tspan,x0);
tt = linspace(tspan(1),tspan(2),301);
thetas = deval(sol,tt);
plot(thetas(1,:),thetas(2,:),'r','LineWidth',2)


axis([-5,5,-3,3])
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
