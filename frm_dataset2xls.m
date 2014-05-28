function frm_dataset2xls(dsT, xlsFileName, sheetNumOrStr)
%  MH - http://github.com/histed/tools-mh

%   Must call FRM_JAVASETUP first to set up java path w/ POI jar files

if nargin < 3, sheetNumOrStr = 1; end
if ~strcmp(class(dsT), 'dataset'), error('First argument must be a dataset: is argument order wrong?'); end

%% massage colnames for output
fNames = get(dsT, 'VarNames');
tColNames = fNames;
tColNames = regexprep(tColNames, '([A-Z])', ' $1'); % add spaces before each capital
tColNames = regexprep(tColNames, '([0-9]*)', ' $1');  % add spaces before runs of numbers
tColNames = regexprep(tColNames, '^ ', '');  % remove any leading spaces; easier to do this than use lookbehind




% %% write using export
% %% Does  not work on a mac
%set(dsT, 'VarNames', tColNames);
% export(dsT, 'XLSFile', xlsFileName, 'Sheet', sheetNumOrStr);

%% create a raw cell matrix
rawCell = dataset2cell(dsT); % very similar to the way I built frm_xlswritepoi
rawCell(1,:) = tColNames(:);

frm_xlswritepoi(xlsFileName, rawCell, sheetNumOrStr, [], false);

% %% create the raw cell matrix
% nCols = length(fNames);
% nRows = length(dsT.(fNames{1}));
% rawCell = cell(nRows+1, nCols);
% rawCell(1,:) = tColNames;
% 
% for iC = 1:nCols
%     tVals = dsT.(fNames{iC});
%     if isnumeric(tVals)
%         tValsO = mat2cell_singleton(tVals);
%         [tValsO{isnan(tVals)}] = deal([]);
%         tVals = tValsO;
%     end   % else we keep as a cell vector
%     if length(tVals) ~= nRows
%         error('malformed data struct - each field must have same number of rows');
%     end       
%     rawCell(2:end,iC) = tVals(:);
% end
% 
% %% write
% frm_xlswritepoi(xlsFileName, rawCell, sheetNumOrStr);
% 
