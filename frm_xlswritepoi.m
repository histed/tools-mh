function frm_xlswritepoi(xlsFileName, rawCell, sheetNumOrStr, doMatInCellAsText, emptyMeansSkipCell)
%FRM_XLSWRITEPOI: use Apache POI Java libraries to write excel files w/ type info etc.
%
%   frm_xlswritepoi(xlsFileName, rawCell, sheetNumOrStr, doMatInCellAsText, emptyMeansSkipCell)
%
%
%
%   NOTE - empty elements of rawCell are untouched if excel file exists, unless emptyMeansSkipCell = False
%   (should come up with a better way to skip missing values, perhaps a separate bool mat)
%
%   Must call frm_javasetup first to set up java path w/ POI jar files
%
%   See also FRM_*
%
%  MH - http://github.com/histed/tools-mh

% notes: To include formulas, they will likely have to be stored as strings and 
% we will have to pass in the type mat from frm_xlsreadpoi.m

if nargin < 3 || isempty(sheetNumOrStr), sheetNumOrStr = 1; end
if nargin < 4 || isempty(doMatInCellAsText), doMatInCellAsText = true; end
if nargin < 5 || isempty(emptyMeansSkipCell), emptyMeansSkipCell = true; end

import org.apache.poi.ss.usermodel.*;

try
    b0 = Cell.CELL_TYPE_NUMERIC;
catch
    error('Java classes not found - did you run xlsjavasetupMH?');
end

%% set up
xc = frm_constants;
[xPath, xName, xExt] = fileparts(xlsFileName);
if isempty(xExt), xExt = '.xls'; end
switch lower(xExt)
    case '.xls'
        isXlsx = false;
    case '.xlsx'
        isXlsx = true;
    otherwise
        error('Unknown excel file extension: must be XLS or XLSX');
end
       
xlsFileName = fullfile(xPath, [xName xExt]);

if any(xlsFileName == '~')
    error('Tilde expansion not supported by Java POI library: use USER var or specify full dir');
end

%% read file if existing, else create
if exist(xlsFileName, 'file')
    jFH = java.io.FileInputStream(xlsFileName);
    wb = WorkbookFactory.create(jFH);
else
    % create it - based on desired type name
    if isXlsx
        wb = org.apache.poi.xssf.usermodel.XSSFWorkbook();
    else
        % xls
        wb = org.apache.poi.hssf.usermodel.HSSFWorkbook();
    end
end

% debug
%fileOut = java.io.FileOutputStream(xlsFileName);
%wb.write(fileOut);
%fileOut.close();

%% find sheet if existing, else create it
tS = [];
if isnumeric(sheetNumOrStr)
    nSheets = wb.getNumberOfSheets();
    if sheetNumOrStr <= nSheets
        tS = wb.getSheetAt(sheetNumOrStr-1);
    end
elseif ischar(sheetNumOrStr)
    tS = wb.getSheet(sheetNumOrStr);  % returns empty if not found
end
if isempty(tS)
    if isnumeric(sheetNumOrStr)
        sheetName = sprintf('Sheet%02d', sheetNumOrStr);
    else
        sheetName = sheetNumOrStr;
    end
    tS = wb.createSheet(sheetName);
end

%% compute types
%  we only use string and numeric for now (see above for formulas)
[nRows nCols] = size(rawCell);

charIx = cellfun(@ischar, rawCell);
numericIx = cellfun(@isnumeric, rawCell);
emptyIx = cellfun(@isempty, rawCell);

%% iterate over rows and cols and write data
for iR = 1:nRows
    tRow = tS.getRow(iR-1);
    if isempty(tRow)
        tRow = tS.createRow(iR-1);
    end
    
    for iC = 1:nCols
        tVal = rawCell{iR,iC};
        if emptyMeansSkipCell && isempty(tVal) 
            continue  % no value, so don't make any Java calls this iteration
        else
            tCell = tRow.getCell(iC-1);
            if isempty(tCell)
                tCell = tRow.createCell(iC-1);
            end
            
            if ischar(tVal)
                tCell.setCellType(Cell.CELL_TYPE_STRING);
                tCell.setCellValue(tVal);
            elseif isnumeric(tVal) && length(tVal) == 1  
                tCell.setCellType(Cell.CELL_TYPE_BLANK); % bug workaround.  
                % see http://apache-poi.1045710.n5.nabble.com/bug-in-cell-setCellType-Cell-CELL-TYPE-NUMERIC-POI-3-6-td2311592.html
                tCell.setCellType(Cell.CELL_TYPE_NUMERIC);
                tCell.setCellValue(tVal);
            elseif isempty(tVal)
                tCell.setCellType(Cell.CELL_TYPE_BLANK);
            elseif isnumeric(tVal) && length(tVal) > 1
                if doMatInCellAsText
                    tCell.setCellType(Cell.CELL_TYPE_STRING)
                    tCell.setCellValue(mat2str(tVal));
                else
                    error('Matrix found in cell, and doMatInCellAsText is false');
                end
            else
                error('unknown type');
            end
        end
    end
end

%% evaluate all formulas on write to update cache
% see http://poi.apache.org/spreadsheet/eval.html
t0 = wb.getCreationHelper();
evaluator = t0.createFormulaEvaluator();
evaluator.evaluateAllFormulaCells(wb);

%% write file to disk and close
isLocked = true;
% test to see if it is locked
while isLocked
    tJA = java.io.RandomAccessFile(xlsFileName, 'rw');
    tJC = tJA.getChannel();
    fLock = tJC.tryLock();
    if ~isempty(fLock)
        isLocked = false; 
        
        % unlock before write
        % 131022: this is a clear race condition but I'm not sure how to write the file and then release the lock:
        % throws a Bad FD exception below
        fLock.release();  
        tJA.close();
        continue
    else
        isLocked = true;
        % new gui method 140206
        respStr = frm_modallockdlg('Title', 'frm_xlswritepoi: writing file', ...
            'String', sprintf('Excel file is locked. To save changes, please unlock by closing the file in Excel and press Retry. \n%s', xlsFileName));
        if strcmp(strtrim(respStr), 'Retry')
            continue
        else
            error('Save aborted (changes lost). Output file is locked for writing: close Excel and try again (%s)', xlsFileName);
        end
    end
end

% turn it into an output stream
fileOut = java.io.FileOutputStream(xlsFileName);
wb.write(fileOut);
fileOut.close();


