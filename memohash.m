function fmem = memohash(f)
%MEMOHASH MEMOHASH_STOREs/memoizes function results to avoid recalculation
%   FMEM = MEMOIZE(F) accepts a function handle, F, and returns a function
%   handle to a memoized version of the same function. The following
%   restrictions apply to the input function:
%
%   - (mh needs check) F must be called with at least one argument 
%   - (mh needs check) nargout(F) must be positive, and when called F must actually return
%       this number of results
%
% F may have a variable number of arguments.
% The arguments are hashed using hash_recurse.m (from tools-mh). 
%  No collision-checking is performed.  Hashing may take a long time if
%  parameters are large
%
% The first time FMEM is called with a given argument list, F is called to
% compute the results, which are returned and also MEMOHASH_STOREd. If FMEM is
% called again with the same argument list, the MEMOHASH_STOREd results are
% returned.
%
% Example
%
%   existM = memohash(@exist);
%
%   existM(matlabroot)
%   existM(matlabroot, 'dir')   % existM is used just like exist
%
% Calling existM may be faster than calling exist, especially for finding
% out out about disk files, but the results from existM will be out of date
% if there are changes between calls with the same arguments.
%
% Based on memoize.m/MapN.m by David Young
% histed 130618


% Copyright David Young 2011

global MEMOHASH_STORE

if isempty(MEMOHASH_STORE)
    MEMOHASH_STORE = containers.Map;
end
nOut = nargout(f);

fmem = @memoN;
if nOut == -1
    error('tools-mh:variableNargout', ...
        'Function must have definite number of outputs');
end


    function varargout = memoN(varargin)
        % Wraps multiple results up into a cell array for storage
        hashChars = num2str(hash_recurse(varargin));
        keyHash = sprintf('%2x', hashChars);  % hex string for Map class
        if isKey(MEMOHASH_STORE, keyHash)
            result = MEMOHASH_STORE(keyHash);
        else
            [result{1:nOut}] = feval(f, varargin{:});
            MEMOHASH_STORE(keyHash) = result;
            disp('memohash: caching result')
        end
        varargout = result(1:nargout);
    end

end