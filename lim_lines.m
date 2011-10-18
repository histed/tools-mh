function pH = lim_lines(posVect, alongAxesStr, varargin)
%
%   pH = lim_lines(posVect, alongAxesStr, lineprops)
%
%   Like vert_lines but works on all axes and has no 'update'
%   For vertical lines, alongAxesStr = 'Y'
%
% histed 111016

if nargin < 2
    alongAxesStr = 'X'; ...
end
if nargin < 3, 
    lineProps = {'k'}; 
else
    lineProps = varargin;
end

%%
tagStr = sprintf('%sLim', upper(alongAxesStr));

tLim = get(gca, tagStr);
switch upper(alongAxesStr)
  case 'X'
    pH = plot((ones(size(posVect(:)))*tLim)', ...
              (posVect(:)*[1 1])', ...
              lineProps{:});
  case 'Y'
    pH = plot((posVect(:)*[1 1])', ...
              (ones(size(posVect(:)))*tLim)', ...
              lineProps{:});
end


set(pH, 'Tag', sprintf('%sLimLines', alongAxesStr));
