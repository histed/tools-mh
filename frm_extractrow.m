function x1d = frm_extractrow(xd, desN)
%FRM_GETROW
%
%   x1d = frm_getrow(xd, desN)
%
%   Extract a single row from a data frame structure, xd
%
% histed 120531

assert(length(desN)==1, 'Only one row match should be found');

fNames = fieldnames(xd);
for iF = 1:length(fNames)
    tFN = fNames{iF};
    if any(ismember({'colNames', 'nCols', 'nRows' }, tFN))
        continue
    else
        tF = xd.(tFN);
        if iscell(tF)
            x1d(1).(tFN) = tF{desN};
        elseif isnumeric(tF)
            x1d(1).(tFN) = tF(desN);
        else
            error('unknown field type');
        end
    end
end



