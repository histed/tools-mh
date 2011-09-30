function cellout = mat2cell_singleton (mat)
% mat2cell_singleton (ps-utils): mat2cell but cell has singleton entries
%
% USAGE
%  function cellout = mat2cell_singleton (mat)
%
% Same as:
%   mat2cell (mat, 1, ones (size(mat,1), size(mat,2)));
% but shorthand
%
%   MH - http://github.com/histed/tools-mh

cellout = mat2cell (mat, 1, ones (size(mat,1), size(mat,2)));