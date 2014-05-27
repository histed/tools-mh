function datasetOut = frm_frm2dataset(frmIn)
%FRM_FRM2DATASET: convert a FRM in memory to a Matlab 2013+ 'dataset'
%
%   function DATASETOUT = FRM_FRM2XLS(FRIMIN)
%
%   Must call FRM_JAVASETUP first to set up java path w/ POI jar files
%
%   See also FRM_*
%
%  MH - http://github.com/histed/tools-mh

% t
f0 = frmIn;
f0 = rmfield(f0, 'nRows');
f0 = rmfield(f0, 'nCols');
f0 = rmfield(f0, 'colNames');

fNames = fieldnames(f0);
% fields must be col vectors or you end up with a dataset with one observation, each a col vector
for iF=1:length(fNames);
    f0.(fNames{iF}) = f0.(fNames{iF})(:);
end
datasetOut = struct2dataset(f0);


return

%% does not work: returns dataset with one obs, each a col vect

% %% 
% wState = warning;
% warning('off', 'stats:dataset:subsasgn:DefaultValuesAdded');
% datasetOut = dataset([]);
% for iC = 1:frmIn.nCols
%     tName = frmIn.colNames{iC};
%     
%     % not sure if this output type structure is what we want - may need tweaking 140520
%     if iscell(frmIn.(tName))
%         print 'nonm'
%         datasetOut.(tName)(1:frmIn.nRows) = nominal(frmIn.(tName));
%     else
%         datasetOut.(tName)(1:frmIn.nRows) = double(frmIn.(tName));
%     end
% end
% datasetOut.Var1 = [];
%warning(wState)