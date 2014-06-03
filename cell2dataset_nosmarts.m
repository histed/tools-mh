function ds = cell2dataset_nosmarts(c, numericColList)
%
%    This function straight converts a cell to dataset.  It functions like cell2dataset.m from Mathworks,
%         except it does not try to guess the type of each field.  If field listed in numericColLIst, it's
%         numeric, else it's cell.
%
% histed 140527

if nargin < 2, numericColList = ''; end

%% t
wState = warning;
warning('off', 'stats:dataset:subsasgn:DefaultValuesAdded');

nCols = size(c,2);
ds = dataset([]);
for iC = 1:nCols
    tVName = c{1,iC};
    if any(ismember(numericColList, tVName))
        % numeric
        ds.(tVName) = cat(1,c{2:end,iC});  % will throw if not numeric, catch in caller
    else
        % cell
        ds.(tVName) = c(2:end,iC);
    end
end
ds.Var1 = [];

warning(wState);






return
%% test this
c = { 'a', 'b', 'num'; 1, 2 3; 3, 'a', 2 };
cell2dataset_nosmarts(c, {'num'})
