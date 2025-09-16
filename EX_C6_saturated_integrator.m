% Illustration of the behaviour of the saturated integrator
%
% Copyright (C) 2023 by Lassi Paunonen (lassi.paunonen@tuni.fi)

umin = -.5;
umax = .5;

Sat = @(u,y) (u<=umin).*max(y,0)+(u>=umax).*min(y,0)+(u>umin && u<umax).*y;

u0 = 0; 
tspan = [0, 3];
yfun = @(t) 3*sin(pi*t);

odefun = @(t,x) Sat(x,yfun(t));

sol = ode15s(odefun,tspan,u0);

tt= linspace(tspan(1),tspan(2),601);
uu = deval(sol,tt);

y_posind = find(yfun(tt)>=0);
switch_ind = [1,find(y_posind(2:end)>y_posind(1:(end-1))+1)];
tt_single = linspace(0,1,201);

figure(1)
hold off, cla, hold on
title('State $u(t)$ of the constrained integrator.','Interpreter','latex','FontSize',18)
figure(2)
hold off, cla, hold on
title('Periodic input of the constrained integrator.','Interpreter','latex','FontSize',18)

for ind = 1:3
    tspan = [2*(ind-1),2*ind-1];
    sol = ode15s(odefun,tspan,u0);
    tt= linspace(tspan(1),tspan(2),101);
    figure(1)
    uu = deval(sol,tt);
    plot(tt,uu,'color',[0 0.4470 0.7410],'LineWidth',3)
    figure(2)
    plot(tt,yfun(tt),'color',[0 0.4470 0.7410],'LineWidth',3)

    u0 = uu(end);
    tspan = [2*ind-1,2*ind];
    sol = ode15s(odefun,tspan,u0);
    tt= linspace(tspan(1),tspan(2),101);
    uu = deval(sol,tt);
    figure(1)
    plot(tt,uu,'color',[0.8500 0.3250 0.0980],'LineWidth',3)
    figure(2)
    plot(tt,yfun(tt),'color',[0.8500 0.3250 0.0980],'LineWidth',3)

    u0 = uu(end);

end
set(gca,'xlim',[0,6])


% tt_blue = [tt_single;tt_single+2];
% plot(tt_blue',yfun(tt_blue)','color',[0 0.4470 0.7410],'LineWidth',2)
% grid on

% grid on
% axis([0,tspan(2),umin-.1,umax+.1])
% figure(2)
% plot(tt,yfun(tt),'LineWidth',2)
% axis([0,tspan(2),min(yfun(tt)),max(yfun(tt))])
% grid on
