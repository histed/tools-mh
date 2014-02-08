function testReadWriteByExtension

subRunOneExt('xls');
disp('Success on XLS read/write');
subRunOneExt('xlsx');
disp('Success on XLSX read/write');

end


function subRunOneExt(ext)
frmOut.field1 = [1 2 3 4 5 6];
frmOut.field2 = [1 2 3 4 5 6]+10;

testFileName = fullfile(getTmpdir, ['test-frm' '.' ext]);
if exist(testFileName)
    delete(testFileName)
end

frm_frm2xls(frmOut, [testFileName]);


frmIn = frm_xls2frm(testFileName);

% fill out automatic fields for comparison
frmCmp = frmOut;
frmCmp.colNames = fieldnames(frmOut)';  % fieldnames returns a row vect, but frm_xls2frm makes it a col vect
frmCmp.nRows = max(structfun(@length,frmCmp));
frmCmp.nCols = length(frmCmp.colNames);

% check to make sure written and read are the same
assertEqual(orderfields(frmIn), orderfields(frmCmp), 'original frm and re-read frm are different');

% check type of file on disk
ns = frm_xlsfinfo(testFileName);
assertEqual(ext, lower(ns.fileType));

% alter file, write, read and make sure it does the right thing
frmOut2 = frmIn;
frmOut2.newField = frmOut2.field1*10;
frm_frm2xls(frmOut2, [testFileName]);
frmIn2 = frm_xls2frm(testFileName);

frmCmp2 = frmOut2;
frmCmp2.nCols = frmCmp2.nCols+1;
frmCmp2.colNames = setdiff(fieldnames(frmOut2), {'nRows', 'nCols', 'colNames'})';
assertEqual(orderfields(frmIn2), orderfields(frmCmp2));
% check type 
ns = frm_xlsfinfo(testFileName);
assertEqual(ext, lower(ns.fileType));

end