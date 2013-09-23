function dirs = directories
%DIRECTORIES (tools-mh): configure directory locations for file read/write
%
%   edit this file to configure directory locations
%  

hName = hostname;

if ispc
    % windows
    userDir= getenv('USERPROFILE');
else
    userDir= getenv('HOME');
end

dirs.toolsSnapshots = fullfile(userDir, 'Desktop');

% example: switch by machine name
switch hName
  case 'machine1'
      dirs.toolsSnapshots = '/Users/test/shared/snapshots';
  case 'machine2'
      dirs.toolsSnapshots = '/tmp';
end


