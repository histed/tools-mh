function rowN = frm_findrownum(xd, indexCell, varargin)
%FRM_FINDROWNUM: given a set of fields serving as an index, find row
%
%   rowN = frm_findrownum(xd, indexCell, [options])
%
%   Find the unique row matching the index fields.
%   Options: 
%        IgnoreMissing: true: return NaN if not found; 
%                             false (default): raise error
%
%   Example: 
%      rowN = frm_findrownum(xd, { 'File', 'ab', 'Extension', 'bc' };
%
% histed 120531

userDefs = { 'IgnoreMissing', false }; 

uo = stropt2struct(stropt_defaults(userDefs, varargin));

debug = 0;

desFNames = indexCell(1:2:end);
desFValues = indexCell(2:2:end);

nFields = length(desFNames);

% convert chars to singleton cells
strIx = cellfun(@ischar, desFValues);
newC = cellfun(@(x) {{x}}, desFValues(strIx));
desFValues(strIx) = newC;

nOut = length(desFValues{1});
rowNOut = nan([1 nOut]);

% error checking
zeroIx = cellfun(@length, desFValues)==0;
if any(zeroIx)
    error('Missing value in input: %s has length zero', desFNames{find(zeroIx,1)});
end


for iN = 1:nOut
    desIx = true([1 xd.nRows]);
    for iF=1:nFields
        tFN = desFNames{iF};
        tFV = desFValues{iF};

        tFV = tFV(iN);
        if iscell(tFV) && length(tFV) == 1
            tFV = tFV{1};
        end

        if isnumeric(xd.(tFN))
            tDIx = tFV == xd.(tFN);
        else
            % assume always cell - maybe add other types later?!
            assert(iscell(xd.(tFN)));
            tDIx = cellfun(@(x) isequalwithequalnans(x,tFV), xd.(tFN));
        end
        if sum(tDIx) == 0 && ~uo.IgnoreMissing
            error('Index value matched 0 rows: Field %s, desired value %s', ...
                tFN, mat2str(tFV));
        end
        
        if debug
            nM = sum(desIx&tDIx);
            if nM <= 3
                mStr = [', rows: ' mat2str(find(desIx&tDIx))];
            else
                mStr = '';
            end
            
            fprintf(1, 'Debug: Field %s val %s, restricted from %d to %d rows (matched %d)%s\n', ...
                tFN, mat2str(tFV), sum(desIx), sum(desIx&tDIx), sum(tDIx), mStr);
        end
        desIx = desIx & tDIx;
    end
    
    nD = sum(desIx);
    if nD < 1
        if ~uo.IgnoreMissing
            outStr = evalc('columnNames = desFNames, valuesToMatch = desFValues');
            error('No index matches found: \n %s', outStr);
        else
            rowN(iN) = NaN;
            continue
        end
    end
    if nD >= 2
        error('More than one match found - index fields must be unique');
    end

    rowN(iN) = find(desIx);
end
%assert(~any(isnan(rowN)));
