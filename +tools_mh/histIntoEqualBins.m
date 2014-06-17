function binNs = histIntoEqualBins(inV, nBins)
% 
%    tools_mh.histIntoEqualBins(inV, nBins)
%   
%    Partition a vector into nBins bins with nearly the same number of elements in each bin.  Return bin
%    number in binNs.
%

% histed 140616

if nargin < 2, nBins = 10; end

binR = length(inV)/nBins;
nL = length(inV);
mat0 = cat(1,inV, 1:nL)';
mat1 = sortrows(mat0,1);
mat2 = cat(2, mat1, 1+floor((1:nL)'/(nL+1)*nBins));
mat3 = sortrows(mat2,2);
binNs = mat3(:,3);
if isrow(inV), binNs = binNs'; end