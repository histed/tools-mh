function hash = hash_recurse(inArr)
%HASH_RECURSE (ps-utils): MD5 hash arrays, handles cell/struct recursively
%   hash = HASH_RECURSE(inArr)
%
%   hash is a 16-element vector of uint8 values
%   To turn into a 16-char hex string: 
%     c = cellstr(dec2hex(hash);
%     hashStr = lower([c{:}]);
%
%   This can be slow, don't call it in a loop.
%     Two options for calculating MD5:
%        'CalcMD5' (c, mex, from file exchange); fast but requires install
%        'java': calls java library from matlab: duplicates memory for java copy but
%           is installed with every version of matlab
%
%  
%
%  MH - http://github.com/histed/tools-mh

hashMethod = 'CalcMD5';
%hashMethod = 'Java';

hashLen = 16;  % bytes
emptyHash = [125  234   53   43   63  172  142    0, ...  % chosen at random
             149  106   73   82  163  212  244  116];     % rowvect

if isempty(inArr)
    hash = emptyHash;
    return
    
elseif isnumeric(inArr) || ischar(inArr) || islogical(inArr)
    % just hash it
    inArr = inArr(:);  % make it a vector
    % convert strings and logicals into uint8 format
    if ischar(inArr) || islogical(inArr);
        inArr = uint8(inArr);
    else % convert everything else into uint8 format without loss of data
        inArr = typecast(inArr,'uint8');
    end
    method = 'MD5';

    % create hash
    switch lower(hashMethod)
        case 'java'
            x=java.security.MessageDigest.getInstance(method);
            x.update(inArr);
            hash = typecast(x.digest,'uint8')';  % row vect
            return
        case lower('CalcMD5')
            x = CalcMD5(inArr);
            hash = uint8(hex2dec(reshape(x',2,[])')');
    end            
    
elseif iscell(inArr)
    % hash all its elements
    inArr = inArr(:);
    h = repmat(NaN,hashLen,length(inArr));
    for iE=1:length(inArr)
        h(1:hashLen,iE) = hash_recurse(inArr{iE});
    end
    hash = hash_recurse(h);
    return
    % one idea for speeding up: take all the elements in the cell array of
    % similar class, concat them, then call hash_recurse only once on them.  
elseif isstruct(inArr)
    h1 = hash_recurse(struct2cell(inArr));
    h2 = hash_recurse(fieldnames(inArr));
    hash = hash_recurse([h1 h2]);
elseif isa(inArr, 'function_handle')
    % hash its string representation.
    % * Does not ensure it does the same thing, but then neither do function
    % handles.  Matlab runs whatever you've got on disk at the time the
    % function handle is called (as of R14)
    % * we don't handle non-scalar function handles (deprecated in R14)
    hash = hash_recurse(func2str(inArr));
else
    error('Don''t know how to hash type: %s', class(inArr));
end
