function [eiglocs,kvals,k_opt] = LinSysRootLocus(A,B,C,krange)
% function [eiglocs,kvals,k_opt] = LinSysRootLocus(A,B,C,krange)
% 
% Root locus plot for the locations of eigenvalues of A+k*B*C with k>0.
%
% Input parameters:
% A = n x n matrix
% B = n x 1 matrix
% C = 1 x n matrix
% krange = (positive) values for the parameter k. Either 2-vector containing
%          the range of the values of k, or a vector of length at least 3
%          containing the particular values of k.
%
% Output parameters:
% eiglocs = a matrix containing the locations of the eigenvalues at the
%           computed values of k
%
% kvals = computed values of k
%
% k_opt = the value of k for which the real parts of the eigenvalues are as
%         far away from the imaginary axis as possible
%
% Copyright (C) 2023 by Lassi Paunonen (lassi.paunonen@tuni.fi)


sys = ss(A,B,C,0);
[eiglocs,kvals] = rlocus(sys,-krange);
rlocus(sys,-krange);
linehand = findall(gcf,'Type','line');
set(linehand(6:end),'LineWidth',2);

[~,ind] = min(max(real(eiglocs),[],1));
k_opt = -kvals(ind);