function ticklabelSubset(axH, axisStr, tickLocs, tickNsToLabel)
%ticklabelSubset (tools-mh): keep only some ticklabels, locking current tick locations.
%
%   ticklabelSubset(axH, axisStr, tickLocs, tickNsToLabel)
%
%   axH specifies axes (leave empty for gca):
%   axisStr is 'x', 'y', or 'z' (Case insensitive), use X as an example below
%
% created: histed 140725


if isempty(axH), axH = gca; end
if nargin == 1
    if ischar(axH)
        axisStr = axH;
        axH = gca;
    elseif nargin < 2, error('Must specify axisStr'); end
end

tickStr = sprintf('%sTick', upper(axisStr));
tlabStr = sprintf('%sTickLabel', upper(axisStr));

set(axH, tickStr, tickLocs);
tLabs = cellstr(get(axH, tlabStr));
blankIx = true(size(tLabs));
blankIx(tickNsToLabel) = false;
[tLabs{find(blankIx)}] = deal('');

set(axH, tlabStr, tLabs);
