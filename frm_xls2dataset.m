function d = frm_xls2dataset(fileName, numericFieldList)
%
%    d = frm_xls2dataset(fileName, numericFieldList)
%
%    if numericFieldList is NaN, ignore types of fields.  Otherwise, force columns to numeric or cell based
%    on numericFieldList (cell array of strings, field names to make numeric)
%
% histed 140527

% 140528: removed this because biffparse/xlsreadBasic.m sometimes gives warning about unparsable data and then
% returns incomplete data
%   
% %  for now, we use the dataset import.  We may want POI import in the future
% wState = warning('off', 'MATLAB:codetools:ModifiedVarnames');
% dbstop if warning   % make sure to catch the 'skipping text' warning that should be an error
% descripX = dataset('XLSFile', fileName);
% warning(wState);
% dbclear if warning

if nargin < 2, numericFieldList = NaN; end

tFrm = frm_xls2frm(fileName);
d = frm_frm2dataset(tFrm);

%% force fields to specified type
if ~(isnumeric(numericFieldList) && isnan(numericFieldList))
    vNames = get(d, 'VarNames');
    assert(all(ismember(numericFieldList, vNames)), 'specified numericFieldName not in column name list');

    for iC = 1:size(d,2)
        tN = vNames{iC};
        tV = d.(vNames{iC});
        if any(strcmpi(numericFieldList, tN))
            % desired: numeric
            
            % may someday wish to do some auto-conversion here
            if ~ isnumeric(tV)
                error('Column %s is not numeric: change in excel', tN);
            end
        else
            % desired: cell
            if isnumeric(tV)
                tV = num2cell(tV);
            end
            isContentsCellIx = cellfun(@iscell, tV);
            assert( ~any(isContentsCellIx), 'No nested cell arrays allowed');
            % write back
            d.(vNames{iC}) = tV;
        end
    end
end


return
%% test this
% fName = '/Users/histed/Repositories/behaviorAnalysisHADC8-MH/rigDailyFits/exampleData/indices/threshSubjDescripByDay.xls';
% d1 = frm_xls2dataset(fName, {'Subject'});