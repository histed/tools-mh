function datasetOut = frm_defToEmpty(datasetIn, defValue, newValue);
%
%  datasetOut = frm_defToEmpty(datasetIn, defValue, newValue);
%
%    Whereever dataset contains defValue, replace with newValue.
%    defValue: defaults to '__default' - for use with stropt_defaults
%    newValue: defaults to []
%   
% 
% histed 140525

if nargin < 2, defValue = '__default'; end
if nargin < 3, newValue = []; end

if ~strcmp(class(datasetIn), 'dataset')
    error('input must be a matlab dataset');
    % for now - could later change to work on frms
end

c = dataset2cell(datasetIn);
foundIx = cellfun(@(x)isequal(x,defValue), c);
[c{foundIx}] = deal(newValue);

datasetOut = cell2dataset(c);
    