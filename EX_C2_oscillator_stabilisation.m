%% Stabilise the harmonic oscillator


r = 0; % no damping in the oscillator
k = 1;
m = 1;


A = [0 1;-k/m -r/m];
B = [0;1/m];
C = [1 0];
D = 0;

x0 = [1;0.1];
% x0 = rand(2,1)-1/2;
tspan = [0 20];

% Design K in such a way that A+BK is stable
% note the conventions on the minus signs!

% % Pole placement
K = -place(A,B,[-.5+1i,-.5-1i]);
% K = -place(A,B,[-3,-3.01])

% 
% % Q-dissipativity
% Q = diag([k;m]);
% K = -B'*Q;
% 
% % LQR
% R = .5;
% K = -lqr(A,B,eye(2),R,zeros(2,1));

% PlotEigs(A,[-4,.5,-3,3]) % Eigenvalues of the original system
PlotEigs(A+B*K,[-4,.5,-3,3]) % Eigenvalues of the stabilised system



%% Simulate the behaviour of the stabilised oscillator (with state feedback u=Kx)
%ufun = @(t) sin(t).*cos(t);
% ufun = @(t) sin(t).^2;
ufun = @(t) zeros(size(t));
% ufun = @(t) ones(size(t));


sol = LinSysSim(A+B*K,B,x0,ufun,tspan);

% figure(1)
%LinSysStatePlot(sol,100,[tspan 1.1*[min(min(sol.y)) max(max(sol.y))]],2);
% LinSysStatePlot(sol,1001,[],2);
figure(2)
LinSysOutputPlot(sol,C+D*K,D,ufun,401,[],2);
%LinSysFigAdjust(axis)
%hold on
%plot([tspan(1) tspan(2)],[0 0],'k','Linewidth',1)
%set(gca,'tickdir','out','box','off','xtick',0:5:20)
grid on
% set(gca,'tickdir','out','box','off','xtick',0:2:10,'ytick',0:.5:1)
% axis([tspan -.15 1.1])
% %
figure(3)
LinSysPhasePlot(sol,4001,[],2);
set(gca,'tickdir','out','box','off')
grid on
xlabel('$q(t)$','Interpreter','latex',FontSize=20)
ylabel('$\dot q(t)$','Interpreter','latex',FontSize=20)



% % %
% % Plot the control input
% figure(4)
% ttu = linspace(tspan(1),tspan(2),200);
% plot(ttu,ufun(ttu),'LineWidth',2)
% % axis([tspan [min(ufun(ttu)) max(ufun(ttu))]+(max(ufun(ttu))-min(ufun(ttu)))/20*[-1 1]])
% grid on

%% Animate the motion of the oscillator


figure(5)
tt = linspace(tspan(1),tspan(2),401);
qq = [1,0]*deval(sol,tt);
AnimateOsc(tt,qq);
