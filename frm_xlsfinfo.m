function dsT = frm_xlsfinfo(xlsFileName)
%FRM_XLSFINFO: get information on XLS/XLSX file on disk
% 
%   os = FRM_XLS2FRM(xlsFileName)
%
%   xlsFileName can be an XLS, or XLSX file
%   On mac, xlsinfo does not work for XLSX files; this does.
%
%  MH - http://github.com/histed/tools-mh

% histed 140206: created in service of unit tests.  

xc = frm_constants;

import org.apache.poi.ss.usermodel.*;
import org.apache.poi.openxml4j.exceptions.*;
import java.io.*;

% look for filename, completing extension if not supplied
if ~exist(xlsFileName, 'file')
    foundXls = exist([xlsFileName '.xls'], 'file');
    foundXlsx = exist([xlsFileName '.xlsx'], 'file');
    if foundXls && foundXlsx, 
        error('extension not supplied and both XLS and XLSX files found: specify');
    elseif foundXls
        xlsFileName = [xlsFileName '.xls'];
    elseif foundXlsx
        xlsFileName = [xlsFileName '.xlsx'];
    else
        error('Input file not found: %s', xlsFilename);
    end
end
       
% open it
jFH = java.io.FileInputStream(xlsFileName);
wb = WorkbookFactory.create(jFH);
javaClass = char(wb.getClass());

switch javaClass
    case 'class org.apache.poi.hssf.usermodel.HSSFWorkbook'
        fileType = 'xls';
    case 'class org.apache.poi.xssf.usermodel.XSSFWorkbook'
        fileType = 'xlsx';
    otherwise
        error('Unknown class of Java object: perhaps POI has changed?  Bug.');
        % to fix this we could always match substrings inside the class name - prob not necessary here
end

% return outputs
dsT.fileType = fileType;