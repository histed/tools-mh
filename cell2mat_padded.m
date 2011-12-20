function matOut = cell2mat_padded (cellIn, dim, padVal)
%CELL2MAT_PADDED (ps-utils): Convert cell vector of unequal size els to matrix
%   MATOUT = CELL2MAT_PADDED (CELLIN, DIM, PADVAL)
%   functions like cell2mat except elements can be of
%   variable sizes, and each is padded as necessary with
%   padVal to be the same size as the largest element.
%   padVal is optional and defaults to 0.
%   dim is the dimension over which to concatenate
%
%   Notes
%   Right now this only handles cell vectors.  And each element can only be a
%   vector.
%   This should be expanded to handle cell matrices like cell2mat does.
%   see code notes below for what to do to fix #2. 
%
%   111215 - optimized for speed.  be careful not to make it much slower it if going to
%   multi-dim elements.
%   
%  MH - http://github.com/histed/tools-mh

if nargin < 2, padVal = 0; end
if nargin < 3, dim = 1; end

% check input
assert(isvector(cellIn), 'Only cell vectors are supported now');
nEls = length(cellIn);

%% calculate output size
maxDims = max(cellfun(@ndims, cellIn));
allSizes = cellfun(@size, cellIn, 'UniformOutput', false);
allSizeMat = cat(1, allSizes{:});
maxSizes = max(allSizeMat, [], 1);

oneOutSize = maxSizes;
outSize = maxSizes;
outSize(dim) = outSize(dim)*nEls;
matOut = repmat(padVal, outSize);


%% construct padded versions of output matrix
nonDim = setdiff(1:maxDims, dim);
cellOut = cellIn;
for iE = 1:nEls
    tSize = allSizeMat(iE,:);
    padSize = oneOutSize;
    padSize(nonDim) = padSize(nonDim) - tSize(nonDim);
    if padSize(nonDim) == 0
        continue;
    end
    % this should be replaced by a loop to handle elements that are not just vectors.
    tMat = cat(nonDim, cellIn{iE}, repmat(padVal, padSize));
    cellOut{iE} = tMat;
end

%% concatenate
matOut = cat(dim, cellOut{:});


