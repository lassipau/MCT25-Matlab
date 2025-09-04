% Example: Simulating the behaviour of the cart with two pendulums in 
% Exercise 3.3 of Jacob & Zwart 2012.
%
% Copyright (C) 2019 by Lassi Paunonen (lassi.paunonen@tuni.fi)

m = 1;
M = 10;
g = 1;
l1 = 1;
l2 = 2;

A0 = [0,m*g/M,m*g/M;0,-(1+m/M)*g/l1,-m*g/(M*l1);0,-m*g/(M*l2),-(1+m/M)*g/l2];
B0 = [1/M;-1/(M*l1);-1/(M*l2)];


A = [zeros(3),eye(3);A0,zeros(3)];
B = [zeros(3,1);B0];
C = [eye(3),zeros(3)];
D = zeros(3,1);

x0 = [1;1;1;0;0;0];
tspan = [0, 20];

figure(3)
subplot(211)
LinSysPlotEigs(A,[-3,1,-3,3])
title('Eigenvalues of the original system.')

% Stabilization
R = .02;
K = -lqr(A,B,eye(6),R,zeros(6,1));
K = -place(A,B,[-.4+1i,-.4-1i,-.4+.2i,-.4-.2i,-.4+.7i,-.4-.7i]);
A = A+B*K;

subplot(212)
LinSysPlotEigs(A,[-3,1,-3,3])
title('Eigenvalues of the stabilised system.')


% %

ufun = @(t) zeros(size(t));
% ufun = @(t) ones(size(t));
% ufun = @(t) sin(t).*cos(t);
% ufun = @(t) sin(t).^2;
% ufun = @(t) sqrt(t);
% ufun = @(t) rem(t,2)<=1;
%  ufun = @(t) t<=2;

sol = LinSysSim(A,B,x0,ufun,tspan);

figure(1)
LinSysStatePlot(sol,401,[tspan 1.1*[min(min(sol.y)) max(max(sol.y))]],2);
% LinSysStatePlot(sol,100,[],2);
figure(2)
LinSysOutputPlot(sol,C,D,ufun,401,[],2);

% %
figure(5)
LinSysStateFBPlot(sol,K,401);