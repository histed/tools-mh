function dsT = xlsread_textornum(xlsFileName, sheet)
%XLSREAD_TEXTORNUM (tools-mh): read xls with header row; convert to struct by col title
% 
%   ds = xlsread_textornum(xlsFileName)
%
%   ds is a structure.  The first row is treated as a header line and the
%   cell contents are used as field names in the structure. 
%   Each field is a vector from the column contents.  If there is mixed
%   numeric and string data, a raw cell vector is returned.  If only
%   numeric data we return a numeric vector, else a text vector.
%
%   Notes: should be smarter about parsing dates
%
%  MH - http://github.com/histed/tools-mh

% histed 120501: created

if nargin < 2, sheet = ''; end

warning('off', 'MATLAB:xlsread:Mode');
[num,text,raw] = xlsread(xlsFileName, sheet, '', 'basic');

% remove header line
dsT.colNames = raw(1,:);
raw = raw(2:end,:);  text = text(2:end,:);  num = num(2:end,:);
% convert to a struct
dsT.nCols = length(dsT.colNames);
dsT.nRows = size(raw,1);
nNumCols = size(num,2);

for iC=1:dsT.nCols
    tFN = dsT.colNames{iC};
    % sanitize fname
    if isnan(tFN)
        tFN = sprintf('Column%02d', iC);
    else
        tFN = strrep(tFN, sprintf('\n'), '');
        tFN = regexprep(tFN, '[-\(\)]', '_');  % misc punct w/ underscores
        tFN = genvarname(tFN);
        tFN = regexprep(tFN, '_$', '');  % misc punct w/ underscores
    end
    
    if iC > nNumCols
        isSomeNum = false;
    else
        isSomeNum = any(~isnan(num(:,iC)));
    end
    isSomeText = any(~cellfun(@isempty,text(:,iC)));
    if isSomeNum && isSomeText
        tV = raw(:,iC);
    elseif isSomeNum
        tV = num(:,iC);
    else
        tV = text(:,iC);
    end
        
    dsT.(tFN) = tV(:)';
end
