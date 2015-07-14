function y = transform_anscombe(x)
%TRANSFORM_ANSCOMBE (toolsmh): var-stabilizing Anscombe transformation
%   transformedData = TRANSFORM_ANSCOMBE(inputData)
%
%  MH - http://github.com/histed/tools-mh

y = 2*sqrt(x + (3/8));

