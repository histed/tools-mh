function outName = homedir
%HOMEDIR (ps-utils): home directory, works both on windows and mac
%   T = HOMEDIR
%
%  MH - http://github.com/histed/tools-mh

if ispc
    homeDir = strcat(getenv('HOMEDRIVE'), getenv('HOMEPATH'));
else
    homeDir = getenv('HOME');
end

outName=homeDir;


