% Example: Output tracking of constant reference signals for the heat 
% equation using the constrained integrator.
%
% Copyright (C) 2023 by Lassi Paunonen (lassi.paunonen@tuni.fi)

% reference signal
yref = 1;

% Gain parameter \kappa>0 of the integrator
kappa = 1;

% Parameters of the heat equation:
alpha = 1; % heat diffusivity
b0 = 1; % control gain parameter
n = 20; % size of the Finite Difference approximation

% Construct the matrices A, B, and C of the approximation for the heat
% equation

spgrid = linspace(0,1,n);
ee = ones(n,1);
A = alpha*(n-1)^2*full(spdiags([ee,-2*ee,ee],-1:1,n,n));
A(1,2) = 2*alpha*(n-1)^2; A(n,n-1) = 2*alpha*(n-1)^2;
B = b0*(spgrid<1/2)';
C = 2/(n-1)*(spgrid>=1/2);
D = 0;

% The system is unstable because A has eigenvalue zero, but we will first
% pre-stabilize it with output feedback u(t)=K_0*y(t)+u_1(t) with K = -1.
K0 = -1;

A = A+B*K0*C;

% The limits of the integrator.
umin = 0.2;
umax = 1.2;

% Check that the reference can be produced by a control in the range
% (umin,umax)
P0 = -C*(A\B);
if yref<= umin*P0 || yref>P0*umax
    warning('The reference cannot be produced with a control in the range (umin,umax)!')
end

% Define the S-function of the integrator
Sfun = @(u,y) (u<=umin).*max(y,0) + (u<umax && u>umin).*y + (u>=umax).*min(y,0);

% Initial state of the heat system
x0 = 2*ones(n,1);
%x0 = zeros(n,1);
%x0 = (spgrid.*(1-spgrid))';
x0 = (3-1/2*tanh(10*(spgrid-1/2)))';

% Initial state of the integrator
u0 = 0.5;

xe0 = [x0;u0];

tspan = [0, 18];

% Since the nonlinear closed-loop system. We directly use ode45 to
% simulate the system
odefun = @(t,xe) [A*xe(1:n) + B*xe(end);Sfun(xe(end),kappa*(yref-C*xe(1:n)))];

sol = ode45(odefun,tspan,xe0);
tt = linspace(tspan(1),tspan(2),401);
xevals = deval(sol,tt);
yy = C*xevals(1:n,:);

% Plot the output and the reference signal
figure(1)
hold off, cla
plot(tt,yref*ones(size(tt)),'color',[0.8500 0.3250 0.0980],'Linewidth',2)
hold on
plot(tt,yy,'color',[0 0.4470 0.7410],'Linewidth',2)
title(['Output of the controlled heat system.'],'Interpreter','Latex','Fontsize',16)
grid on

% Plot the control input and the integrator limits umin and umax
figure(2)
hold off, cla
plot(tspan',[umax,umax;umin,umin]','color',[0 0.4470 0.7410],'Linewidth',2)
hold on
plot(tt,xevals(end,:),'color',[0.8500 0.3250 0.0980],'Linewidth',2)
title(['The control input of the heat system.'],'Interpreter','Latex','Fontsize',16)
grid on

% Plot the state of the controlled heat equation
figure(3)
plotskip = 1;
tt = unique([linspace(0,1/2,9),linspace(1/2,2,12),linspace(2,tspan(2),51)]);
xevals = deval(sol,tt);
surf(tt(1:plotskip:end),spgrid,xevals(1:n,1:plotskip:end))
set(gca,'ydir','reverse')
xlabel('time $t$','fontsize',18,'Interpreter','latex')
ylabel('position $\xi$','fontsize',18,'Interpreter','latex')


%%
tt = linspace(tspan(1),tspan(2),401);
xevals = deval(sol,tt);
xx = xevals(1:n,:);
axlims = [0,1,min(min(xx)),max(max(xx))];
figure(3)
  for ind = 1:size(xx,2)
    
    plot(spgrid,xx(:,ind).','Linewidth',2)
    axis(axlims)
    xlabel('$\xi$','Interpreter','latex','Fontsize',20)
    title(['Time $=\; ' num2str(tt(ind),'%.1f') '$'],'Interpreter','latex','Fontsize',20)
    drawnow
    pause(0.03)
    
  end
