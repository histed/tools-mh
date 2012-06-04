function [rawOut, typeMat] = frm_xlsreadpoi(xlsFileName, sheetNum)
%FRM_XLSREADPOI: use Apache POI Java libraries to read excel files w/ type info etc.
%   [rawOut, typeMat] = FRM_XLSREADPOI(xlsFileName)
%
%   rawOut is a cell array with the contents of each cell as a matlab object
%   sheetNum is the sheet number, 1-origin (first sheet numbered 1 not zero)
%   typeMat is a numeric matrix of the same size (see xlsconstantsMH for
%       mapping from values to text).  Empty cells get CELL_TYPE_BLANK
%
%   Must call frm_javasetup.m first to set up java path w/ POI jar files
%
%   See also FRM_*
%
%  MH - http://github.com/histed/tools-mh

if nargin < 2, sheetNum = 1; end

import org.apache.poi.ss.usermodel.*;

if ~exist(xlsFileName, 'file')
    error('XLS input file not found');
end

jFH = java.io.FileInputStream(xlsFileName);
try
    b0 = Cell.CELL_TYPE_NUMERIC;
catch
    error('Java classes not found - did you run xlsjavasetupMH?');
end

wb = WorkbookFactory.create(jFH);
nSheets = wb.getNumberOfSheets();


tS = wb.getSheetAt(sheetNum-1);

% iter over rows
rowI = tS.rowIterator();
while true
    if rowI.hasNext()
        tRow = rowI.next();
    else
        break;
    end

    % iter over cells
    cellI = tRow.cellIterator();
    while true
        if cellI.hasNext()
            tC = cellI.next();
        else
            break;
        end

        iR = tC.getRowIndex();
        iC = tC.getColumnIndex();

        tType = tC.getCellType();
        switch tType
            case {Cell.CELL_TYPE_NUMERIC, Cell.CELL_TYPE_BOOLEAN}
                tVal = tC.getNumericCellValue();
            case Cell.CELL_TYPE_STRING
                tVal = char(tC.getStringCellValue());
            case Cell.CELL_TYPE_BLANK
                tVal = [];
            otherwise
                error('Unknown type %d', tType)
        end

        typeC{iR+1,iC+1} = tType;
        cOut{iR+1,iC+1} = tVal;
    end
end
rawOut = cOut;
typeMat = celleqel2mat_padded(typeC, Cell.CELL_TYPE_BLANK);
