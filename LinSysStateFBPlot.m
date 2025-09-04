function [tt,uu] = LinSysStateFBPlot(sol,K,N,axlim,LineW)
% function [tt,yy] = LinSysStateFBPlot(sol,K,N,axlim,LineW)
%
% Plots the state feedback input u(t)=Kx(t) of a linear system. Here 'sol' 
% is the solution variable obtained from the ODE solver, K is the control
% gain matrix. Uses a uniform grid with N points. 'axlim' are the limits 
% for the axes (input '[]' for default) and 'LineW' is the line width.
%
% Copyright (C) 2025 by Lassi Paunonen (lassi.paunonen@tuni.fi)


tt = linspace(sol.x(1),sol.x(end),N);
uu = K*deval(sol,tt);

if nargin <= 6
    LineW = 2;
end


plot(tt,uu,'Linewidth',LineW);

if nargin >5 && ~isempty(axlim)
    axis(axlim)
end