function AnimateOsc(tt,qq,axlim)
% function AnimateOsc(tt,qq)
%
% Animate the movement of the harmonic oscillator. 'qq' is the position 
% of the oscillator at the time instances 'tt'.
%
% Copyright (C) 2025 by Lassi Paunonen (lassi.paunonen@tuni.fi)


massfig = [0,0,2,2;-1/6,1/6,1/6,-1/6];

if nargin < 3
    axlim = [min(qq)-2,max(qq)+4];
end
% axis([-6,6,-1,1])
axis([axlim,-1,1])
hold on
for ind = 1:length(tt)
  cla
  
  patch(qq(ind)+massfig(1,:),massfig(2,:),[.7,0,0.5])
  plot(qq(ind)+[0,0],[0,-0.4],'k','linewidth',2)
  title(['time = ' num2str(round(tt(ind),1))])
  drawnow
  pause(0.01)
end
