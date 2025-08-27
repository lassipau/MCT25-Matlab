%% Simulate the harmonic oscillator

r = 0.5;
% r = 0.01; % For testing "resonance"
% r = 2;
k = 1;
m = 1;


A = [0 1;-k/m -r/m];
B = [0;1/m];
C = [1 0];
D = 0;

x0 = [1;0.1];
% x0 = rand(2,1)-1/2;
tspan = [0 20];

%ufun = @(t) sin(t).*cos(t);
% ufun = @(t) sin(t).^2;
% ufun = @(t) sqrt(t);
% ufun = @(t) rem(t,2)<=1;
ufun = @(t) zeros(size(t));
% ufun = @(t) 1./(1+t).^(1/2);
% ufun = @(t) exp(-0.1*t);
% ufun = @(t) ones(size(t));

% ufun = @(t) sin(t); % For testing "resonance"


sol = LinSysSim(A,B,x0,ufun,tspan);

% figure(1)
%LinSysStatePlot(sol,100,[tspan 1.1*[min(min(sol.y)) max(max(sol.y))]],2);
% LinSysStatePlot(sol,1001,[],2);
figure(2)
LinSysOutputPlot(sol,C,D,ufun,401,[],2);
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



% %
figure(4)
ttu = linspace(tspan(1),tspan(2),200);
plot(ttu,ufun(ttu),'LineWidth',2)
% axis([tspan [min(ufun(ttu)) max(ufun(ttu))]+(max(ufun(ttu))-min(ufun(ttu)))/20*[-1 1]])
grid on