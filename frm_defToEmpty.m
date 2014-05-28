function datasetOut = frm_defToEmpty(datasetIn, defValue, newValue, numericFieldList);
%
%  datasetOut = frm_defToEmpty(datasetIn, defValue, newValue);
%
%    Whereever dataset contains defValue, replace with newValue.
%    defValue: defaults to '__default' - for use with stropt_defaults
%    newValue: defaults to []
%
%    This can't work without knowing the desired type of each field, so it must be passed in as
%    numericFieldList
%   
% 
% histed 140525

if nargin < 2, defValue = '__default'; end
if nargin < 3, newValue = []; end
if nargin < 4, error('must specify numericFieldList'); end

if ~strcmp(class(datasetIn), 'dataset')
    error('input must be a matlab dataset');
    % for now - could later change to work on frms
end

c = dataset2cell(datasetIn);
f0 = @(x)isequalwithequalnans(x,defValue);
foundIx = cellfun(f0, c);
[c{foundIx}] = deal(newValue);


datasetOut = cell2dataset_nosmarts(c, numericFieldList);
    