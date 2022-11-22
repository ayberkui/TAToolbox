% clear all
close all
clc
inputName=inputdlg({'Assignment Number:', 'Problem Name:', 'Similarity Threshold (0.5 by default)', 'Do you want to save? (y/n)'}...
    ,'Sheet Name Input',[1 50],{'','','0.5','n'});
saveFlag = strcmp(inputName{4},'y');
threshold = str2double(inputName{3});
if saveFlag
    if isempty(inputName)
        disp('Operation cancelled by user.')
        return
    elseif isempty(inputName{1})||isempty(inputName{2})
        disp('Please enter an Assignment Number and Problem Name.')
        return
    end
    sheetName= strjoin(['Assignment',inputName{1},'_',inputName(2)],'');
    
end

MFC=mfilecompare(8);
n= length(MFC.overlap.text);
[num,txt,raw]=xlsread('Template.xlsx');
[maxRow maxCol] = size(raw);
for i =1:maxRow
    if strcmp(raw{i,2}(end),' ')
        raw{i,2} = raw{i,2}(1:end-1);
    end
end

numCheat = 1;
cheaters = {'File name', 'is similar to', 'by ratio'};
for i=1:n
    for j=1:n
        filenamei=MFC.filenames(i);
        stop=strfind(filenamei{1},'_');
        filenamei=filenamei{1}(1:stop(end)-1);
        filenamej=MFC.filenames(j);
        stop=strfind(filenamej{1},'_');
        filenamej=filenamej{1}(1:stop(end)-1);

        indexi=-1;
        indexj=-1;
        for k=2:maxRow
            if strcmp(raw{k,2},filenamei)
                indexi=k;
            end
            if strcmp(raw{k,2},filenamej)
                indexj=k;                 
            end
        end        
        if indexi>0 && indexj>0
            similarity = MFC.overlap.text(i,j);
            raw{indexj,indexi+2} = similarity;
            if ~strcmp(filenamei, filenamej)
                if similarity > threshold
                    cheaterIndex = 0;
                    for k = 1:numCheat
                        if strcmp(filenamei,cheaters{k,1})
                            cheaterIndex = k;
                            cheaters{k,1} = filenamei;
                            cheaters{k,2} = filenamej;
                            cheaters{k,3} = num2str(similarity);
                        end
                    end
                    if cheaterIndex == 0
                        numCheat = numCheat + 1;
                        cheaters{numCheat,1} = filenamei;
                        cheaters{numCheat,2} = filenamej;
                        cheaters{numCheat,3} = num2str(similarity);
                    end
                end
            end
        else
            disp(['not found:' filenamei '-' filenamej])
        end
    end
end
tableEnd = size(raw,1)+4;
raw{tableEnd-2,1} = 'Maximum similarity';
raw{tableEnd-2,2} = 'for each student';
raw{tableEnd-2,3} = ['over ', num2str(threshold)];
for i = 1:numCheat
    raw{tableEnd+i,1} = cheaters{i,1};
    raw{tableEnd+i,2} = cheaters{i,2};
    raw{tableEnd+i,3} = cheaters{i,3};
end

if saveFlag
    try
        xlswrite('OverlapText.xlsx',raw,sheetName)
    catch
        error('Can not write on the excel sheet. Try closing OverlapText.xlsx and try again.')
    end
    
    hExcel = actxserver('Excel.Application');
    hWorkbook = hExcel.Workbooks.Open(fullfile(pwd,'OverlapText.xlsx'));
    hExcel.Cells.Select;
    hExcel.Cells.EntireColumn.AutoFit;
    Range = hExcel.Range(['D2..',ExcelColumn(maxCol),num2str(maxRow)]);
    Range.ColumnWidth = 4;
    Range.FormatConditions.AddColorScale(3);
    
    Range.FormatConditions.Item(1).ColorScaleCriteria.Item(1).FormatColor.ColorIndex= 2;
    Range.FormatConditions.Item(1).ColorScaleCriteria.Item(2).FormatColor.ColorIndex= 2;
    Range.FormatConditions.Item(1).ColorScaleCriteria.Item(2).Value = 0;
    Range.FormatConditions.Item(1).ColorScaleCriteria.Item(3).FormatColor.Color = 7039480;
    
    hWorkbook.Save;
    hWorkbook.Close
    winopen('OverlapText.xlsx')
end