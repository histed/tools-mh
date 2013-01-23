function rowN = frm_findrownum(xd, indexCell, varargin)
%FRM_FINDROWNUM: given a set of fields serving as an index, find row
%
%   rowN = frm_findrownum(xd, indexCell, [options])
%
%   Find the unique row(s) matching the index fields.
%   To specify multiple rows make the index values vectors/cell vectors
%  
%   Options: 
%        IgnoreMissing: true: return NaN if not found; 
%                             false (default): raise error
%
%   Example: 
%      rowN = frm_findrownum(xd, { 'File', 'ab', 'Extension', 'bc' };
%
% histed 120531

userDefs = { ...
    'IgnoreMissing', false, ...
    'AllowMultiple', false, ...  
    };

uo = stropt2struct(stropt_defaults(userDefs, varargin));

debug = 0;

% firstpass check if any data
if xd.nRows == 0
    if uo.IgnoreMissing
        rowN = NaN;
        return
    else
        error('No rows in data - no rows can be matched');
    end
end

desFNames = indexCell(1:2:end);
desFValues = indexCell(2:2:end);

nFields = length(desFNames);

% convert chars to singleton cells
strIx = cellfun(@ischar, desFValues) | cellfun(@isempty, desFValues);
newC = cellfun(@(x) {{x}}, desFValues(strIx));
desFValues(strIx) = newC;

nOut = length(desFValues{1});
rowNOut = nan([1 nOut]);

%: allow empties to find unfilled cells now MH 130123
% error checking
% zeroIx = cellfun(@length, desFValues)==0;
% if any(zeroIx)
%     error('Missing value in input: %s has length zero', desFNames{find(zeroIx,1)});
% end


for iN = 1:nOut
    desIx = true([1 xd.nRows]);
    for iF=1:nFields
        tFN = desFNames{iF};
        tFV = desFValues{iF};

        tFV = tFV(iN);
        if iscell(tFV) && length(tFV) == 1
            tFV = tFV{1};
        end

        if isempty(tFV)
            tDIx = cellfun(@isempty, xd.(tFN));
        elseif isnumeric(xd.(tFN))
            tDIx = tFV == xd.(tFN);
        else
            % assume always cell - maybe add other types later?!
            %assert(iscell(xd.(tFN)));
            %tDIx = cellfun(@(x) isequalwithequalnans(x,tFV), xd.(tFN));
            %%% equally slow %tDIx = cellfun(@(x) isequal(x,tFV), xd.(tFN));
                        
            tField = xd.(tFN);
            assert(iscell(tField));
            if isa(tFV, 'char')
                tDIx = strcmp(tField, tFV);
            elseif isa(tFV, 'double')
                tDIx = strcmp(tField, char(tFV));
            end
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
    elseif nD > 1
        if uo.AllowMultiple
            assert(nOut == 1, 'if AllowMultiple is true, each input field match must be length 1');
            rowN = find(desIx);
        else
            error('More than one match found - index fields must be unique');
        end
    elseif nD == 1
        rowN(iN) = find(desIx);
    end
end
%assert(~any(isnan(rowN)));
