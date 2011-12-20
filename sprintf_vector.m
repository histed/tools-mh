function outStr = sprintf_vector(pat, inVect)
%   outStr = SPRINTF_VECTOR(pat, inVect)
%
%   Given a pattern and a vector, return a cellstr, with sprintf(pat,...) called on
%   each entry in the vector.
%
%   histed 111219
%
% MH - http://github.com/histed/tools-mh

if isa(inVect, 'numeric')
    inCell = mat2cell_singleton(inVect);
elseif isa(inVect, 'cell')
    inCell = inVect;
else
    error('not implemented');
end

outStr = cellfun(@(x) sprintf(pat, x), inCell, 'UniformOutput', 0);
    
    

    
