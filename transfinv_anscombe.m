function y = transfinv_anscombe(x)
%TRANSFINV_ANSCOMBE (toolsmh): inverse Anscombe transf
%   Y = TRANSFINV_ANSCOMBE(X)
%
%  MH - http://github.com/histed/tools-mh

y = (x*0.5).^2 - (3/8);
% preserve sign
y = y.*sign(x);

% testing
%xv = linspace(0,10);
%transfinv_anscombe(transform_anscombe(xv)) - xv
%transfinv_anscombe(-transform_anscombe(xv)) + xv