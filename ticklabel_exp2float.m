function ticklabel_exp2float(axH, axisStr)
%
%   outStrs = TICKLABEL_EXP2FLOAT(axH, axisStr)
%
%   axH specifies axes (leave empty for gca):
%   axisStr is 'x', 'y', or 'z' (Case insensitive), use X as an example below
%   if XScale is log, at each XTick, set the label to be the linear
%   representation.
%   i.e. when initially setting XScale to log, tick labels may be 10^-1,
%   10^0, 10^1; this function will make them 0.1, 1, 10
%
% created: histed 110903

if isempty(axH), axH = gca; end
if nargin < 2, error('Must specify axisStr'); end

switch lower(axisStr)
  case 'x'
    tStr = 'XTick';
  case 'y'
    tStr = 'YTick';
  case 'z'
    tStr = 'ZTick';
  otherwise
    error(sprintf('Invalid axisStr: %s', axisStr));
end
tLStr = [ tStr 'Label' ];

% almost ridiculously simple
tTL = cellstr(num2str(get(axH, tStr)', 4));
set(axH, tLStr, tTL);
    
    
