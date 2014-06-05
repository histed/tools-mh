function out = cat_cellornum(dim, varargin)
% 
% out = cat_cellornum(dim, varargin)
% 
% Concat each input along dimension.  If all are numeric, output is numeric.  If any is a cell, convert
% numeric to cell array (with each number in a cell) and return a cell.  Output length is always the sum of
% input lengths.
% Useful for concatenation of frm, dataset, or table variables when type of field is not known
% 
% See also: CAT
%
% histed 140605

nC = length(varargin);
isnum = cellfun(@isnumeric, varargin);
if all(isnum) || all(~isnum)
    out = cat(dim, varargin{:});  % just like cat
else
    % mixed types, promote num to cell
    tempC = {};
    for iC = 1:nC
        if isnum(iC)
            tempC{iC} = mat2cell_singleton(varargin{iC});
        else
            tempC{iC} = varargin{iC};
            assert(iscell(tempC{iC}), 'all inputs must be numeric or cell');
        end
    end
    out = cat(dim, tempC{:});
end

            