function testExcelLocks

disp('To use this test, wait for Excel to open.  When modal dialog appears, press Retry, then close Excel and press Retry again.  Run again to test Discard path if desired');

subWriteAFileWithLock('xls');

end

function subStartExcelOnFile(fName);
% tons of mac and system-specific stuff in here, will require tweaking on any environment change

% check if running
[status psOut] = system('ps aux | grep "Microsoft Excel.app" | grep -v grep');
if status == 0
    isExcelRunning = true;
else
    isExcelRunning = false;
end
if isExcelRunning
    error('To start this test, Excel must not be running: close it');
end

% check Excel location
% Use hardcoded name.  We could use a mac/defaults/app registry method to find the Excel app but that's too
%     hard for now for a simple test
if ~exist('/Applications/Microsoft Office 2011')
    error('Microsoft Office 2011 not found - change this test or reinstall');
end

% Open excel on file
system(sprintf('open -a "/Applications/Microsoft Office 2011/Microsoft Excel.app" "%s"', fName));

end


function subWriteAFileWithLock(ext)
frmOut.field1 = [1 2 3 4 5 6];
frmOut.field2 = [1 2 3 4 5 6]+10;

testFileName = fullfile(getTmpdir, ['test-lock-frm' '.' ext]);
if exist(testFileName)
    delete(testFileName);
end
frm_frm2xls(frmOut, testFileName);

% open it in excel
subStartExcelOnFile(testFileName);
pause(2)

frm_frm2xls(frmOut, testFileName);

%% read and ensure it worked
frmIn = frm_xls2frm(testFileName);
% fill out automatic fields for comparison
frmCmp = frmOut;
frmCmp.colNames = fieldnames(frmOut)';  % fieldnames returns a row vect, but frm_xls2frm makes it a col vect
frmCmp.nRows = max(structfun(@length,frmCmp));
frmCmp.nCols = length(frmCmp.colNames);

assertEqual(orderfields(frmIn), orderfields(frmCmp), 'original frm and re-read frm are different');

end