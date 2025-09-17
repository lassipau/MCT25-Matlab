% Example: Feedforward tracking control for the harmonic oscillator.
%
% Copyright (C) 2019 by Lassi Paunonen (lassi.paunonen@tuni.fi)

r = 0; k = 1; m = 1;

A = [0 1;-k/m -r/m];
B = [0;1/m];
C = [1, 0];
D = 0;


% Choose the reference signal and express it in the standard form.
% Reference signal sin(2*pi*t)+1
ref_w = [-2*pi, 0, 2*pi];
ref_c = [1i/2, 1, -1i/2];

% Without damping, the system is unstable. However, we can stabilize it
% with state feedback using the matrix K=[0,-1].

K = [0,-1];

% Transfer function of the stabilized plant
PKfun = @(s) (C+D*K)*((s*eye(size(A))-A-B*K)\B)+D;

ufun = LinSysTrackStab(ref_w,ref_c,PKfun);
yref_fun = LinSysTrackRef(ref_w,ref_c);

tt = linspace(0,4,301);
uvals = zeros(1,length(tt));
for ind = 1:length(tt)
    uvals(ind) = ufun(tt(ind));
end
plot(tt,[uvals; k+2*pi*cos(2*pi*tt) + (k-4*m*pi^2)*sin(2*pi*tt)]);


%% Simulate the system

% The simulation is completed by applying the control "ufun" to the system
% (A+BK,B,C+DK,D)

r = 0; k = 1.1; m = .9;

A = [0 1;-k/m -r/m];
B = [0;1/m];


% Initial state of the oscillator
x0 = [-1;1];

tspan = [0, 14];

sol = LinSysSim(A+B*K,B,x0,ufun,tspan);

tt = linspace(tspan(1),tspan(2),500);
xx = deval(sol,tt);

% The output of the controlled system is C*x(t) = [C,zeros(p)]*x_e(t)
yy = C*xx+D*ufun(tt);


% Values of yref(t) for plotting
yrefvals = zeros(1,length(tt));
for ind = 1:length(tt), yrefvals(ind)=yref_fun(tt(ind)); end

figure(1)
% Plot the output and the reference
plot(tt,[yrefvals;yy],'Linewidth',2)
%plot(tt,yy-yrefvals,'Linewidth',2)
title(['Output of the controlled oscillator.'],'Interpreter','Latex','Fontsize',16)

%% Animate the motion of the oscillator


figure(2)
massfig = [0,0,2,2;-1/6,1/6,1/6,-1/6];
axis([-6,6,-1,1])
hold on
for ind = 1:length(tt)
  cla
  
  patch(yy(ind)+massfig(1,:),massfig(2,:),[.7,0,0.5])
  plot(yy(ind)+[0,0],[0,-0.4],'k','linewidth',2)
  title(['time = ' num2str(round(tt(ind),1))])
  drawnow
  pause(0.01)
end
