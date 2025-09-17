% Example: Feedforward tracking control for the heat equation.
%
% Copyright (C) 2023 by Lassi Paunonen (lassi.paunonen@tuni.fi)

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

%%

% Choose the reference signal and express it in the standard form.

% % Reference signal sin(2*pi*t)+1
ref_w = [-2*pi 0 2*pi];
ref_c = [1i/2 1 -1i/2];

% % Triangle signal, only odd frequencies
% % required frequencies in the reference signal and the corresponding
% % coefficient vectors "a_k" (or in this case scalars, since p=1)
% ak = @(k) ((-1)^k-1)/(k^2*pi^2);
% ref_w = [-7*pi -5*pi -3*pi -pi 0 pi 3*pi 5*pi 7*pi];
% ref_c = [ak(-7) ak(-5) ak(-3) ak(-1) 0 ak(1) ak(3) ak(5) ak(7)];


% The heat system is unstable. However, we can stabilize it
% with state feedback K = -B^*, or designing K using the LQR method.
% Alternatively, the system is stabilizable with negative output feedback, 
% for example with u(t)=-k0*y(t)+u_{new}(t) where k0>0 is small.

% State feedback
% K = -B';
% Output feedback
K = -3*C;

% Transfer function of the stabilized plant
PKfun = @(s) (C+D*K)*((s*eye(size(A))-A-B*K)\B)+D;

ufun = LinSysTrackStab(ref_w,ref_c,PKfun);
yref_fun = LinSysTrackRef(ref_w,ref_c);

% tt = linspace(0,8,1001);
% plot(tt,ufun(tt),'linewidth',2)

%% Simulate the system

% The simulation is completed by applying the control "ufun" to the system
% (A+BK,B,C)

% Initial state of the heat system
% x0 = ones(n,1);
x0 = zeros(n,1);

tspan = [0 8];

sol = LinSysSim(A+B*K,B,x0,ufun,tspan);

tt = linspace(tspan(1),tspan(2),551);
xx = deval(sol,tt);
xx = real(xx); % ignore the complex part of the solution caused by numerical errors

% The output of the controlled system is C*x(t) = [C,zeros(p)]*x_e(t)
yy = C*xx+D*ufun(tt);


% Values of yref(t) for plotting
yrefvals = zeros(1,length(tt));
for ind = 1:length(tt), yrefvals(ind)=yref_fun(tt(ind)); end

figure(1)
% Plot the output and the reference
plot(tt,[real(yrefvals);yy],'Linewidth',2)
title(['Output of the controlled heat system.'],'Interpreter','Latex','Fontsize',16)

figure(2)

surf(tt(1:2:end),spgrid,xx(:,1:2:end))
set(gca,'ydir','reverse')
xlabel('time $t$','fontsize',18,'Interpreter','latex')
ylabel('position $\xi$','fontsize',18,'Interpreter','latex')

%%
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
