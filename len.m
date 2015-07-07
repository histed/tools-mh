function out0 = len(in0)
% LEN (tools-mh): allow len() from Python to do the same as length() from matlab
%
%

%histed 150625 - this should be JITted in recent Matlab's so the extra fn call shouldn't matter.
out0 = length(in0);
