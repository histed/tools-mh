function mh_figpreppdf(figH, figSize, profileStr)
% MH_FIGPREPPDF:  common plot fixups for pdf export
if isempty(figSize), figSize = 6*[1 0.75]; end
if isempty(profileStr), profileStr = 'working'; end   % or final


axH = findobj(figH, 'Type', 'axes');

switch profileStr
    case 'working'
        labelTextSize = 7;
    case 'final'
        labelTextSize = 6;
    otherwise
        error('unknown profileStr %s', profileStr);
end

set(axH, .... 
    'TickDir', 'out', ...
    ...    %'TickLength', figSize ./ 200, ... % i.e. 0.015 for a 3x3 figure
    'TickLength', 0.015 * [1 1], ...% really need to figure out the number of subplots for this one
    'Box', 'on', ...
    'LineWidth', 0.25, ...
    'FontName', 'Arial', ...
    'FontSize', labelTextSize);

tH = findall(gcf, 'Type', 'text');
set(tH, 'FontName', 'arial', ...
    'fontsize', labelTextSize+1);


