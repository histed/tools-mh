function ebH = basicerrorbar(lH, upperLength, lowerLength)
%BASICERRORBAR (mh): simplest errorbar you can imagine
%    ebH = basicerrorbar(lineH, upperLength, lowerLength)
%  
%    Main advantage of this over errorbar is that only one plot object is
%    generated with all of the errorbar lines, so it can be easily modified
%
% histed 120529 brought in from plotOnlineHist.m

if nargin < 3, lowerLength = upperLength; end

xv = get(lH, 'XData');
yv = get(lH, 'YData');
xvals = cat(1, xv, xv, xv);
yvals = cat(1, yv-lowerLength(:)', yv+upperLength(:)', yv*NaN);
xvals = reshape(xvals, [1 numel(xvals)]);
yvals = reshape(yvals, [1 numel(yvals)]);
ebH = plot(xvals, yvals);


set(ebH, 'Color', get(lH, 'Color'));
