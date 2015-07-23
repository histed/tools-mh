function relabelticks(axH, axStr, tickPos, tickLabelPos, tickLabelStrs)
%RELABELTICKS: (tools-mh)  drop some ticks for clarity
%
%    relabelticks(axH, axStr, tickPos, tickLabelPos, [tickLabelStrs])
%     
%    axStr: 'X' or 'Y' 
%    if tickLabelStrs is not specified, it is sprintf_vector('%g', tickLabelPos)
%

if nargin < 5 || isempty(tickLabelStrs), tickLabelStrs = sprintf_vector('%g', tickLabelPos); end

% set ticks
set(axH, sprintf('%sTick', axStr), tickPos);

% set ticklabels
if ~all(ismember(chop(tickLabelPos,8), chop(tickPos,8))) % use chop to avoid numeric imprecision not-equal
    keyboard
    error('all tick label positions must be in tickPos');
end
nTL = length(tickLabelPos);
desTickNs = zeros([1 nTL]);
for iLP = 1:nTL
    desTickNs(iLP) = find(tickPos == tickLabelPos(iLP));
end
[allStrs{1:length(tickPos)}] = deal('');
allStrs(desTickNs) = tickLabelStrs(:);
set(axH, sprintf('%sTickLabel', axStr), allStrs);

