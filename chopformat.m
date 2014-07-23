function outStr = chopformat(Xin,n,unit,chopType)
%CHOPFORMAT (ps-utils) round to n significant figures and format to string
%   CHOPFORMAT(X,n,unit,chopType), rounds X to n sig figs
%   see CHOP for explanation of arguments
%
%   This is needed because the %g format specifier can switch to exponential notation at times.
%   This function always formats like %f, but keeps only sig digits including sig zeros.
%
%   See also: CHOP, ROUNDTO
%
%  MH - http://github.com/histed/tools-mh

if nargin < 3, unit = []; end
if nargin < 4, chopType = []; end

X = chop(Xin, n, unit, chopType);

integerDig = length(strrep(num2str(round(Xin)), '-', ''));
% this doesn't work because 99 and 100 are treated differently and should be the same.
% integerDig = ceil(log10(round(Xin)));
floatDig = max(0,n-integerDig);

isInt = floatDig == 0; % also works: epsnear(X,round(X))

if isInt
    outStr = sprintf('%d', X);
else
    fmtStr = sprintf('%%.%df', floatDig);
    outStr = sprintf(fmtStr, X);
end