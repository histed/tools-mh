function [ebH, statS] = scatterbins(x0, y0, bins, maxPrc)
%SCATTERBINS (tools-mh): bin a scatterplot and plot means/stderrs for each bin
%
%  ebH = SCATTERBINS(X,Y)
%  ebH = SCATTERBINS(X,Y,BINS)
%  ebH = SCATTERBINS(X,Y,BINS,MAXPRC)
%
% BINS can be a scalar, the number of bins to divide into keeping similar numbers of items in each bin
%   or a vector, in which it is the bin edges
%

% later, can extend to use different errorbar measures besides SEM
% MH 150705

if nargin < 3, bins = 8; end
if nargin < 4, maxPrc = 100; end

% construct bins
if isscalar(bins)
    nBins = bins;
    percentiles = linspace(0, maxPrc, nBins + 1);
    percentiles = percentiles(1:end);
    binEdges = prctile(x0, percentiles);
    binEdges(end) = Inf;
else
    binEdges = bins;
    nBins = length(binEdges) - 1;
end


xm = zeros([1, nBins]);
ym = zeros([1, nBins]);
ySem = zeros([1,nBins]);
nPtsPerBin = ySem*0;
for iB = 1:nBins
    desIx = x0 >= binEdges(iB) & x0 < binEdges(iB+1);
    xm(iB) = mean(x0(desIx));
    ym(iB) = mean(y0(desIx));
    nPtsPerBin(iB) = sum(desIx);
    ySem(iB) = std(y0(desIx)) / sqrt(nPtsPerBin(iB));
end

% plot
axH = newplot;
ebH = errorbar(xm, ym, ySem, 'LineStyle', 'none');

% output stats
statS(1).binEdges = binEdges;
statS(1).nBins = nBins;
statS.yMean = xm;
statS.yMean = ym;
statS.ySem = ySem;
statS.nPtsPerBin = nPtsPerBin;
