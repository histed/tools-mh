function N = argmin(inVect)
%ARGMAX (tools-mh): quick shorthand function for index of largest item
%   N = ARGMAX(inVect)
%
%   Same as
%     [maxV maxN] = max(inVect);
%     N = maxN
%
% MH - http://github.com/histed/tools-mh

[minV minN] = min(inVect);
N = minN;