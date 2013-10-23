function newLimits = axlim_union(axesHandles, xyzStr)
%AXLIM_UNION (mh): set all axis limits to the min/max over all specified
%
%   newLimits = axlim_union(axesHandles, xyzStr)
%
%   Example: 
%     for iA=1:10, axH(iA) = subplot(1,10,iA); plot(dataCell{iA}); end
%     newLimits = axlim_union(axH, 'Y');
%     % newLimits is [minY maxY] and all YLim's are set to newLimits
%
% histed 131015

limStr = sprintf('%1sLim', upper(xyzStr));

tL = get(axesHandles, limStr);
tLM = cat(1, tL{:});
minY = min(tLM(:,1));
maxY = max(tLM(:,2));
set(axesHandles, limStr, [minY maxY]);

if nargout > 0, newLimits = [minY maxY]; end