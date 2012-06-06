function rowN = frm_findrownum(xd, indexCell)
%FRM_FINDROWNUM: given a set of fields serving as an index, find row
%
%   rowN = frm_findrownum(xd, indexCell)
%
%   Find the unique row matching the index fields.
%
%   Example: 
%      rowN = frm_findrownum(xd, { 'File', 'ab', 'Extension', 'bc' };
%
% histed 120531

debug = false;

desFNames = indexCell(1:2:end);
desFValues = indexCell(2:2:end);

nFields = length(desFNames);

desIx = true([1 xd.nRows]);
for iF=1:nFields
    tFN = desFNames{iF};
    tFV = desFValues{iF};
    
    if isnumeric(xd.(tFN))
        tDIx = tFV == xd.(tFN);
    else
        % assume always cell - maybe add other types later?!
        assert(iscell(xd.(tFN)));
        tDIx = cellfun(@(x) isequalwithequalnans(x,tFV), xd.(tFN));
    end
    if sum(tDIx) == 0
        error('Index value matched 0 rows: Field %s, desired value %s', ...
            tFN, mat2str(tFV));
    end

    if debug
        fprintf(1, 'Debug: Field %s val %s, restricted from %d to %d rows (matched %d)\n', ...
            tFN, mat2str(tFV), sum(desIx), sum(desIx & tDIx), sum(tDIx));
    end
    desIx = desIx & tDIx;
end

nD = sum(desIx);
if nD < 1
    error('No index matches found!');
end
if nD >= 2
    error('More than one match found - index fields must be unique');
end

rowN = find(desIx);