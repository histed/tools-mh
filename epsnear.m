function bool = epsnear(float1, float2, epsilon)
%EPSNEAR (ps-utils): are two floating point numbers equal?
%   BOOL = ISWITHINTOL(FLOAT1, FLOAT2, EPSILON)
%   returns 1 if arguments' relative difference is less than epsilon
%
%   EPSILON defaults to eps x 10^2
%
%  140614: use relative difference
%  MH - http://github.com/histed/tools-mh

if nargin < 3, epsilon = eps*10^2; end

m = (float1+float2)./2;
bool = ( abs( (float1-float2)./m) < epsilon);

