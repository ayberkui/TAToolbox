function [IDNumber, rowIndex] = findStudentID(mail,classList)
%   IDNumber = findStudentID(name,surname)
%
%   Returns the ID number of a student given a name and a surname from a
%   class list.
%   Inputs:
%       mail : Student's mail address (most likely taken from a file name)
%       classList : 2D cell array where first column contains student
%       names, second column contains surnames, third column contains ID
%       Numbers.
%   Outputs:
%       IDNumber : ID number of the student in text format
%       rowIndex : Row number for the select student in the classList

numStd = size(classList,1);
IDNumber = [];
rowIndex = [];

for indexStd = 2:numStd
    NAME = classList{indexStd,1};
    SURNAME= classList{indexStd,2};
    name = nameDeLocalizer(NAME);
    surname = nameDeLocalizer(SURNAME);
    if isempty(strfind(mail,surname))
        continue
    end
    indexSpaces = strfind(name,' ');

    if isempty(indexSpaces) % Student has a single name
        names{1} = name;
        numNames = 1;
    else                    % Student has multiple names
        numNames = length(indexSpaces)+1;
        names = cell(numNames,1);
        for indexNames = 1:numNames
            if indexNames == 1
                nameBegin = 1;
            else
                nameBegin = indexSpaces(indexNames-1)+1;
            end
            if indexNames == numNames
                nameEnd = length(name);
            else
                nameEnd = indexSpaces(indexNames)-1;
            end
            names{indexNames} = name(nameBegin:nameEnd);
        end

    end
    for indexNames = 1:numNames
        if ~isempty(strfind(mail,names{indexNames}))
            IDNumber = classList{indexStd,3};
            rowIndex = indexStd;
            return
        end
    end
end

manualName = inputdlg(['Failed to match the file name ', mail, ...
    ' to any of the students in the class. Please provide the name of', ...
    ' the student below.']);
manualName = manualName{1};
if isempty(manualName)
    error('Student not found, operation aborted.')
%     return
end
manualName = nameDeLocalizer(manualName);
[IDNumber,rowIndex] = findStudentID(manualName,classList);
return
end
