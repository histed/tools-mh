function testReadWriteNumeric

frmOut.field1 = [1 2 3 4 5 6];
frmOut.field2 = [1 2 3 4 5 6]+10;

testFileName = fullfile(getTmpdir, 'test-frm');
if exist(testFileName)
    delete([testFileName '.xls']
    delete([testFileName '.xlsx']
end

frm_frm2xls(frmOut, testFileName);


frmIn = frm_xls2frm(testFileName);
 
% fill out automatic fields for comparison
frmCmp = frmOut;
frmCmp.colNames = fieldnames(frmOut)';  % fieldnames returns a row vect, but frm_xls2frm makes it a col vect
frmCmp.nRows = max(structfun(@length,frmCmp));
frmCmp.nCols = length(frmCmp.colNames);

% debug
%orderfields(frmIn)
%orderfields(frmCmp)
assertEqual(orderfields(frmIn), orderfields(frmCmp), 'original frm and re-read frm are different');
