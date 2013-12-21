function sOut = cleanfields(sIn)
%CLEANFIELDS (tools-mh): make sure each field of a structure has a valid name
%   sOut = cleanfields(sIn)
%
%   This is typically needed when a structure was created by a different language/program
%   example:
%   tS = 
%       #announceStimulus: {1633x1 cell}
%   cleanfields(tS)
%   ans = 
%       #announceStimulus: {1633x1 cell}
% 
%  MH - http://github.com/histed/tools-mh


fNs = fieldnames(sIn);
sCell = struct2cell(sIn);
cleanedNames = genvarname(fNs);
sOut = cell2struct(sCell, cleanedNames);
        