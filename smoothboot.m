function [smoothCurve, smoothCiU, smoothCiL, bootreps] = smoothWithBoot(xv,yv,varargin);
% smoothWithBooth (tools-mh):  
%  
%  Note: caches/memoizes results to /tmp

%% arg processing
userDefs = { ...
    'NBootReps', 100, ...
    'Method', 'lowess', ...
    'Span', [], ...
    'CiAlpha', 2.5, ...  % 2.5 for two-sided test equiv to 5 for one-sided interval
    'MemoizeDir', '/tmp'};
     
uo = stropt2struct(stropt_defaults(userDefs, varargin));

smFH = @(x,y) subSmooth(x,y, uo.Span, uo.Method);
smoothCurve = smFH(xv(:), yv(:));
    
% bootstrap out errorbars

% check cache
cClass = mfilename;
cacheKey = { mfilename, xv, yv, uo.Span, uo.NBootReps, uo.Method };
outdatedKey = {}; 
cDir = uo.MemoizeDir;
cDat = disk_cache('get', cacheKey, 'allowMissing', cClass, outdatedKey, 'cacheDir', cDir);
if isempty(cDat)
    % recalc
    yboot2 = bootstrp(uo.NBootReps,smFH,xv(:),yv(:));
    disk_cache('set', {yboot2}, cacheKey, outdatedKey, 'allowDups', cClass, 'cacheDir', cDir);
else
    yboot2 = deal(cDat{:});
end

smoothCiU = prctile(yboot2, 100-uo.CiAlpha/2, 1);
smoothCiL = prctile(yboot2, uo.CiAlpha/2, 1);

bootreps = yboot2;

end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%     
     
function out = subSmooth(xv, yv, span, method)
    % need a separate function for sorting the data
    [x0 xns] = sort(xv);
    out = smooth(x0, yv(xns),span, method);
end