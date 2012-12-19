function matOut = celleqel2mat_padded (cellIn, padVal, castOutputType)
%CELLEQEL2MAT_PADDED (ps-utils): Convert cell mat of equal size els to matrix
%   MATOUT = CELLEQEL2MAT_PADDED (CELLIN, PADVAL)
%   cellIn - Each element must be the same size as every other or empty
%   padval defaults to NaN
%   castOutputType: if empty, uses matlab default promotion rules (if any
%       integer, make the whole array an int array.)
%       To cast all elements, pass 'double', 'int32' etc.
%
%   This is MUCH faster than CELL2MAT_PADDED when each entry is either the
%   same size or empty.  It's still not terribly fast.

%
%  MH - http://github.com/histed/tools-mh

if nargin < 2, padVal = NaN; end
if nargin < 3, castOutputType = []; end

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

w = warning('off', 'MATLAB:nonIntegerTruncatedInConversionToChar');
if isempty(castOutputType)
  matOut = cat(1, cellIn{:});
else
  castFH = str2func(castOutputType);
  matOut = cellfun(castFH, cellIn);
end
warning(w);

outSize = tSize .* size(cellIn);
matOut = reshape(matOut, outSize);

