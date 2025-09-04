function [tt,yy] = LinSysPhasePlot(sol,N,axlim,LineW)
% function [tt,yy] = LinSysPhasePlot(sol,C,D,ufun,N)
%
% Plots the phase plot of a 2-dimensional system when 'sol' is the solution
% variable obtained from the ODE solver. Uses a uniform grid with N points. 
% 'axlim' are the limits for the axes (input '[]' for default) and 'LineW' 
% is the line width.
%
% Copyright (C) 2025 by Lassi Paunonen (lassi.paunonen@tuni.fi)


tt = linspace(sol.x(1),sol.x(end),N);
xx = deval(sol,tt);

if size(xx,1) ~= 2
    error('LinSysPhasePlot only works for systems on R^2!')
end

if nargin <= 3
    LineW = 2;
end


plot(xx(1,:),xx(2,:),'Linewidth',LineW);

if nargin >2 && ~isempty(axlim)
    axis(axlim)
end