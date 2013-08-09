function bool = epsnear(float1, float2, epsilon)
%EPSNEAR (ps-utils): are two floating point numbers equal?
%   BOOL = ISWITHINTOL(FLOAT1, FLOAT2, EPSILON)
%   returns 1 if arguments differ by less than epsilon
%
%   EPSILON defaults to eps x 10^2
%
%  MH - http://github.com/histed/tools-mh
if nargin < 3, epsilon = eps*10^2; end

bool = ( abs(float1 - float2) < epsilon);

