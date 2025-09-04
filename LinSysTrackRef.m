function yref = LinSysTrackRef(ref_w,ref_c)
% function yref = LinSysTrackRef(ref_w,ref_c)
%
% Returns a function handle that computes the value of the reference signal
% y_ref at time t. The input arguments are the frequencies of the reference
% signal "ref_w" (real values) and the corresponding coefficient vectors
% "a_k" given as columns of "ref_c". 
%
% The function yref can not be evaluated for a vector.
%
% Copyright (C) 2023 by Lassi Paunonen (lassi.paunonen@tuni.fi)

yref = @(t) ref_c*exp(1i*ref_w(:)*t);