function matOut = cell2matpad (cellIn, padVal)
%CELL2MATPAD (tools-mh): Convert cell mat of unequal size els to matrix
%   MATOUT = CELL2MATPAD (CELLIN, PADVAL)
%   functions like cell2mat except elements can be of
%   variable sizes, and each is padded as necessary with
%   padVal to be the same size as the largest element.
%   padVal is optional and defaults to 0.
%
%   111215 - optimized for speed.  be careful not to make it much slower it if going to
%   multi-dim elements.
%   130612 - totally rewrote algorithm; now pads each element of cellarray
%      and then uses cat.  Will need to test, check for speed
%      Note: concat dimension has been removed! to match cell2mat syntax
%
%  MH - http://github.com/histed/tools-mh



if isempty(cellIn), matOut = []; return; end

if nargin < 2, padVal = 0; end

%% calculate output size
r0 = cellfun(@ndims, cellIn);
maxDims = max(r0(:));
allSizes = cellfun(@size, cellIn, 'UniformOutput', false);
dimMaxIx = maxDims == cellfun(@ndims, cellIn);
allSizeMat = cat(1, allSizes{dimMaxIx});
maxSizes = max(allSizeMat, [], 1);

% construct an all-pad array same size as each cell element
oneOutSize = maxSizes;  
if isnan(padVal)
    matOut = nan(oneOutSize); % mathworks says these special funcs are faster
elseif padVal == 0
    matOut = zeros(oneOutSize);
else
    matOut = repmat(padVal, oneOutSize);
end



%% iterate through cellIn, padding each matrix
% proceed linearly through indices
nEls = prod(size(cellIn)); 

for iE = 1:nEls
    tM = cellIn{iE};
    
    tMPad = matOut;
    % construct index matrix
    ixC = {};
    for iD=1:ndims(tM)
        ixM{iD} = 1:size(tM,iD);
    end
    tMPad(ixM{:}) = tM;
    cellIn{iE} = tMPad;
end

%% concatenate
matOut = cell2mat(cellIn);


