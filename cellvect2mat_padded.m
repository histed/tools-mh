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
%   See also CELLEQEL2MAT_PADDED - which should be used instead.  
%
%  MH - http://github.com/histed/tools-mh

% this is just here for backward compat

assert(isvector(cellIn)||isempty(cellIn), 'Only cell vectors are supported now');
assert(nargin < 2 || isempty(dim), 'dim arg not supported, do your own transposition');
if nargin < 3, padVal = NaN; end

matOut = celleqel2mat_padded(cellIn, padVal);
