function [hand, b0, b1, r2, pval] = scatter_linearfit (xdata, ydata, robust, ...
                                                       plot_params, text_to_add, ...
                                                       line_xdata, do_draw_cis, ...
                                                       ci_alpha)
%SCATTER_LINEARFIT (ps-utils): add regression line to scatterplot
%   [HAND, B0, B1, R2] = SCATTER_LINEARFIT (XDATA, YDATA, ROBUST, PLOT_PARAMS)
%   You must draw the scatter plot yourself
%   robust: 'robust', 'leastsq', 
%       or 'orthogonal': to minimize the perpendicular direction
%
%       orthogonal regression uses principal components, and bartlett's
%       test to compute pvalues
% 
%  MH - http://github.com/histed/tools-mh

if nargin < 3 || isempty(robust), robust = 'leastsq'; end
if nargin < 4 || isempty(plot_params), plot_params = {'k'}; end
if nargin < 5 || isempty(text_to_add), text_to_add = { 'slope', 'offset', 'r^2', 'p' }; end
if nargin < 6 || isempty(line_xdata), line_xdata = linspace(min(xdata),max(xdata)); end  
if nargin < 7 || isempty(do_draw_cis), do_draw_cis = false; end
if nargin < 8 || isempty(ci_alpha), ci_alpha = 5; end
assert(ci_alpha == 5, 'code only draws 95% CIs now');

xdata = squeeze(xdata);  % scatter.m does this (or at least shows this
ydata = squeeze(ydata);  % behavior),  so we should too

if isvector(xdata), xdata = xdata(:); end  % make sure a col vector
if isvector(ydata), ydata = ydata(:); end  

numx = length(xdata);
X = ones(numx,2);
X(:,2) = xdata;

if ~ischar(robust)
    error(['Robust parameter must be a string.  See help ' ...
           'SCATTER_LINEARFIT']);
end

switch robust
    case 'robust'
        rStr = 'on';
    case 'leastsq'    
        rStr = 'off';
    case 'orthogonal'
        assert('error, this code needs to be checked');
        % take out each mean
        xM = mean(xdata);
        yM = mean(ydata);
        yd0 = ydata - yM;
        xd0 = xdata - xM;
        
        X = [xd0 yd0];
        [coeff,score,roots] = princomp(X);
        
        % eq for best fit line
        eig1 = coeff(:,1);
        b(2) = eig1(2)/eig1(1);  % slope of best fit line is given by first
        % eigenvector direction
        b(1) = yM - b(2)*xM;     % offset given by inverting y = mx+b
        
        pctVar = roots' ./ sum(roots);
        r2 = pctVar(1);
        
        [ndim,pv] = barttest(X, 0.9999);  % use high alpha, we don't care
        % about ndims
        
        pval = pv;
    otherwise
    error('Invalid value for robust parameter');
end

%mdl = fitlm(X(:,[2:end]), ydata, 'robust', rStr);
mdl = LinearModel.fit(X(:,[2:end]), ydata, 'robust', rStr);
pval = coefTest(mdl);
b = mdl.Coefficients.Estimate;
bint = mdl.coefCI;
r2 = mdl.Rsquared.Ordinary;
%keyboard
%r2 = mdl.

%         mdl = fitlm(X(
%     %[b,st] = robustfit(X(:,[2:end]), ydata);
%     pval = st.p(2);
%     r = st.coeffcorr(2);
%     
%     tss = nansum( st.w .* (ydata - nanmean(ydata)) .^ 2);
%     yhat = b(1) + xdata * b(2);
%     ess = nansum( st.w .* (ydata - yhat) .^ 2);
%     r2 =  1 - ess / tss;
%     se = st.se;
%     assert(ci_alpha == 5, 'only 95% CIs now');
%     bint = [b + se*1.96; b - se*1.96];
%   case 'leastsq'
%     [b bint crap2 crap3 stats] = regress(ydata,X);
%     pval = stats(3);
%     r2 = stats(1);
%     r = sqrt(r2) .* sign(b(2));
% 
    
    


b0 = b(1);
b1 = b(2);    

%xrange = [min(xdata) max(xdata)];
hand(1) = plot(line_xdata, line_xdata*b1 + b0, plot_params{:});
if do_draw_cis
    hand(1) = plot(line_xdata, line_xdata*b1 + b0, plot_params{:});
    [ypred, yci] = predict(mdl, line_xdata', 'Simultaneous', 'on');
    pColor = [145 84 93]/255;
    pH=patch([line_xdata(:)', fliplr(line_xdata(:)')], [yci(:,1)' fliplr(yci(:,2)')], pColor);
    set(pH, 'EdgeColor', 'none');
    anystack(pH, 'bottom');
    hand(3) = pH;
    %upY = 
    %yP = [lowX
    %hand(1) = patch(
end

% label plot
tStr = [];
if any(ismember(text_to_add, 'slope'))
    tStr = [tStr sprintf('\\beta_1 = %g\n', chop(b1,3))];
end
if any(ismember(text_to_add, 'offset'))
    tStr = [tStr sprintf('\\beta_0 = %g\n', chop(b0,3))];
end
if any(ismember(text_to_add, 'r^2'))
    tStr = [tStr sprintf('r^2 = %3.2f\n', r2)];
end
if any(ismember(text_to_add, 'p'))
    tStr = [tStr sprintf('p = %g\n', chop(pval,2))];
end
if any(ismember(text_to_add, 'r'))
    tStr = [tStr sprintf('r = %3.2f\n', sqrt(r2))];
end

hand(2)=text(0,0, tStr);


set(hand(2), 'Units', 'normalized', ...
        'Position', [0.02 0.98], ...
        'VerticalAlignment', 'top', ...
        'HorizontalAlignment', 'left', ...
        'FontSize', 10, ...
        'Tag', 'scatter_linearfit-text');


