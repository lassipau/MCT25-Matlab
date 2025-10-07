% Example: Stabilizing the undamped harmonic oscillator with a constraint
% on the magnitude of the force input F(t)
%
% Copyright (C) 2023 by Lassi Paunonen (lassi.paunonen@tuni.fi)


r = 0; % Consider the undamped oscillator
k = 1; m = 2;

A = [0 1;-k/m -r/m];
B = [0;1/m];
C = [0,1]; % velocity measurement
D = 0;

% Define Q so that A is Q-dissipative
Q = diag([k,m]);

Fmin = -.5;
Fmax = .5;
% Fmin = -100
% Fmax = 100;

% Define the saturation function
phi = @(u) max(min(u,Fmax),Fmin);

x0 = [1;1]; % Initial position and velocity
tspan = [0, 50];

% Control is of the form F(t)=\phi(-\kappa*B^T*Q*x(t)) with \kappa>0
% (Alternatively, we could write F(t)=\phi(-\kappa*y(t)) )
kappa = 1;

% Since the differential equation is nonlinear, we directly use ode45 to
% simulate the system
odefun = @(t,x) A*x + B*phi(-kappa*B.'*Q*x);

sol = ode45(odefun,tspan,x0);

figure(1)
LinSysStatePlot(sol,301,[tspan 1.1*[min(min(sol.y)) max(max(sol.y))]],2);
title('The position $q(t)$ (blue) and the velocity $\dot q(t)$ (red)','Interpreter','latex','FontSize',18)
grid on

% %
% LinSysStatePlot(sol,100,[],2);
figure(2)
% Compute and plot the control input 
tt = linspace(tspan(1),tspan(2),701);
uvals = phi(-kappa*B.'*Q*deval(sol,tt));
plot(tt,uvals,'LineWidth',2)
axis([tspan(1),tspan(2),Fmin-.2,Fmax+.2])
title('The control input $F(t)$','Interpreter','latex','FontSize',18)
grid on

%% Plot the vector field of the nonlinear system
figure(3)
f = @(x) [x(2,:);-(k/l)*x(1,:) + (1/m)*phi(-kappa*m*x(2,:))];
f1 = @(x,y) y;
f2 = @(x,y) -(k/m)*x + (1/m)*phi(-kappa*m*y);



[xx,yy] = meshgrid(linspace(-5,5,20),linspace(-5,5,20));

hold off
cla
quiver(xx,yy,f1(xx,yy),f2(xx,yy))
hold on
xlabel('Angle $\theta(t)$','interpreter','latex','fontsize',16)
ylabel('Velocity $\dot{\theta}(t)$','interpreter','latex','fontsize',16)
xlim([-5,5])
axis equal

xvals = deval(sol,tt);
plot(xvals(1,:),xvals(2,:),'LineWidth',2)



%% Animate the motion of the oscillator

qq = [1,0]*deval(sol,tt);
figure(4)
massfig = [0,0,2,2;-1/6,1/6,1/6,-1/6];
axis([-6,6,-1,1])
hold on
for ind = 1:length(tt)
  cla
  
  patch(qq(ind)+massfig(1,:),massfig(2,:),[.7,0,0.5])
  plot(qq(ind)+[0,0],[0,-0.4],'k','linewidth',2)
  title(['time = ' num2str(round(tt(ind),1))])
  drawnow
  pause(0.01)
end

%% Investigate the possibility of an exponential decay rate of the solutions
figure(5)
epsval = .1;
xvals = deval(sol,tt);
solnorms = sqrt(xvals(1,:).^2+xvals(2,:).^2); % compute the norm ||x(t)|| of the solution
plotfun = exp(epsval*tt).*solnorms/norm(x0);
plot(tt,plotfun,'LineWidth',2)
ylim([0,max(plotfun)])
