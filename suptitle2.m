function textH = suptitle2(str) 
%SUPTITLE2 (ps-utils): title over all subplots; improved version (2)
%   SUPTITLE2('text') adds text to the top of the figure
%   above all subplots (a "super title"). 
% 
%   This is much simpler than the old SUPTITLE because it uses the new
%   OuterPosition property.  It also does not have the side effect of forcing a
%   screen redraw.
%
%   MH - http://github.com/histed/tools-mh

suptitleNormHeight = 0.04;

% save old axes
savedEntryAxesH = gca;

% adjust existing subplots
allAxH = findobj(gcf, 'Type', 'axes');
otherH = findobj(gcf, 'Type', 'axes', 'Tag', 'legend');
subH = setdiff(allAxH, otherH);

if any(strcmp('Colorbar', get(allAxH, 'Tag')))
    % this function needs to be updated to handle colorbars.  The problem is
    % that matlab's automatic colorbar positioning code is very complicated, 
    % resizes the axis, and it's hard to guess what it's going to do.  It
    % might be possible to call colorbar in some way to get it to update the
    % axis position-- but I couldn't figure out an easy way to do this.
    error('Draw colorbars after calling suptitle2');
end

%% goal here: scale y height and y position to shrink all axes.  To scale the
% whole set of plots correctly we must use the y end position not the start
% (i.e. pos(:,2)+pos(:,4) not pos(:,2)
opC = get(subH, 'OuterPosition');
opM = cat(1, opC{:});
yEndOld = opM(:,2)+opM(:,4);
yHtNew = opM(:,4)*(1-suptitleNormHeight);
yEndNew = yEndOld*(1-suptitleNormHeight);
opNew = [opM(:,1) (yEndNew-yHtNew) opM(:,3) yHtNew];
newC = mat2cell(opNew, ones([1,length(subH)]), 4);
set(subH, {'OuterPosition'}, newC);


invisH = axes('Units', 'normalized', ...
              'Position', [0 0 1 1], ...
              'Visible', 'off', ...
              'Tag', 'suptitle2');
textH = text(0.5, 1-(suptitleNormHeight*0.6), str, ...
             'Units', 'normalized', ...
             'HorizontalAlignment', 'center', ...
             'VerticalAlignment', 'middle', ...
             'Tag', 'suptitle2');

% restore old axis, without using a drawnow
set(gcf, 'CurrentAxes', savedEntryAxesH);



