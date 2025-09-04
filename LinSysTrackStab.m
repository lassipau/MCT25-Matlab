function ufun = LinSysTrackStab(ref_w,ref_c,Pfun)
% function control = LinSysTrackStab(ref_w,ref_c,Pfun)
%
% Generates the control input "ufun" to achieve output tracking of the
% reference signal with frequencies given in "ref_w" (real values) and
% corresponding coefficient vectors "a_k" given as columns of "ref_c". 
% "Pfun" is a function handle that evaluates the transfer function of the 
% system at a given point.
%
% Note that ufun can not be evaluated for a vector argument
%
% Copyright (C) 2023 by Lassi Paunonen (lassi.paunonen@tuni.fi)


% number of frequencies
N = length(ref_w);

% find out the number of inputs
m = size(Pfun(1i*ref_w(1)),2);

% store the coefficient vectors of the control output
ukvecs = zeros(m,N);


for ind = 1:N

    Pval = Pfun(1i*ref_w(ind));

    % If the coefficient vector ref_c(ind) is not in the range space of 
    % P(iw), produce a warning 
    if rank(Pval) < rank([Pval ref_c(:,ind)])
        warning('Tracking problem may not be solvable!')
    end
    
    % The operator "\" corresponds to the multiplication with the
    % pseudoinverse of P(iw)
    ukvecs(:,ind) = Pval\ref_c(:,ind);
end

% Construct the control function, u(t) = sum(exp(1i*wk*t)*uk,k=-q..q)
ufun = @(t) ukvecs*exp(1i*ref_w(:)*t);