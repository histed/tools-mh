function f

% edit this for your path to the xunit package
[toolsMhRootDir,tName,tExt] = fileparts(which('runAllXunitTests'));
addpath(fullfile(toolsMhRootDir, '../third-git-tracked/matlab_xunit/xunit'));

runtests(fullfile(toolsMhRootDir,'xunit_tests/frm/'))
runtests(fullfile(toolsMhRootDir,'xunit_tests/misc/'))