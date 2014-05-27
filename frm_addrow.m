function xdOut = frm_addrow(xd, afterRowN, rowToAdd)
%FRM_ADDROW: (tools-mh): add arow to a frame structure
%
%   xdOut = frm_addrow(xd, afterRowN, rowToAdd)
%  
%   rowToAdd - default [], which means fill the new row with empty/NaN by type
%       can be a frm_struct with one row (as produced by frm_extractrow)
%
% histed 120626

if nargin < 2, afterRowN = []; end
if nargin < 3, rowToAdd = []; end

if ~isempty(afterRowN), error('afterRowN not implemented now - fix this'); end

allFields = setdiff(fieldnames(xd), { 'colNames', 'nCols', 'nRows' });
nFields = length(allFields);
nextRowN = xd.nRows+1;

xdOut = xd;
for iF = 1:nFields
    tFN = allFields{iF};
    tFV = xd.(tFN);
    if isa(tFV, 'double')
        if isempty(rowToAdd)
            xdOut.(tFN)(nextRowN) = NaN;
        else
            xdOut.(tFN)(nextRowN) = rowToAdd.(tFN);
        end
    elseif iscell(tFV)
        if isempty(rowToAdd)
            xdOut.(tFN){nextRowN} = [];
        else
            xdOut.(tFN){nextRowN} = rowToAdd.(tFN){1};
        end
    elseif ischar(tFV)  % kludge special case: frames with one row where type normally cell may be type str
        error('does not handle these types of single-element frames - use matlab dataset')
        % in general our type support in these frm_ things is crap and we should switch to matlab's data
        % frames once they have a few revisions to bake
        if isempty(rowToAdd)
            xdOut.(tFN){nextRowN} = [];
        else
            xdOut.(tFN){nextRowN} = rowToAdd.(tFN){1};
        end
        
    else
        error('bug: unknown field type');
    end
end
xdOut.nRows = nextRowN;

