function matOut = cellvect2mat_padded (cellIn, dim, padVal)
%CELL2MAT_PADDED (ps-utils): Convert cell vector of equal size els to matrix
%   MATOUT = CELLVECT2MAT_PADDED (CELLIN, DIM, PADVAL)
%   cellIn must be a cell vector
%   dim is the dimension over which to concatenate
%   Each element must be the same size as every other or empty
%   padval defaults to NaN
%
%   This is MUCH faster than CELL2MAT_PADDED when each entry is either the
%   same size or empty.  It's still not terribly fast.
%
%  MH - http://github.com/histed/tools-mh

assert(isvector(cellIn), 'Only cell vectors are supported now');

if nargin < 2 || isempty(dim), 
  dim = find(size(cellIn) ~= 1, 1);
  if isempty(dim), dim=2; end  % handle case where cellIn is a singleton
end
if nargin < 3, padVal = NaN; end

if isempty(cellIn), matOut = []; return; end

emptyIx = cellfun(@isempty, cellIn);
if all(emptyIx)
  matOut = repmat(padVal, size(cellIn));
  return
end

firstNonN = find(~emptyIx, 1, 'first');
tSize = size(cellIn{firstNonN});
padMat = repmat(padVal, tSize);

[cellIn{emptyIx}] = deal(padMat);

if isempty(dim)
  dim
  cellIn
end


matOut = cat(dim, cellIn{:});

