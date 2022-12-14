clc
close all
clearvars -except indexFile folder Assessment* CLASSLIST Grading

fprintf('\nWelcome to the RunMFiles! Thanks for choosing Umur''s TA emporium! \n')
fprintf('  A couple of friendly reminders:\n')
fprintf('   - If you haven''t specified a directory yet (no string named ''folder'' in the workspace) you will be asked to choose \n')
fprintf('     the directory containing the M-Files you want me to run back to back.\n')
fprintf('   - The workspace will be cleared except for a few variables that I need to function between each M-File\n')
fprintf('   - If at any point, you need to stop and take a look at the workspace generated by an M-File, you can stop me with ctrl+c. \n')
fprintf('     As long as you don''t delete the variables named ''folder'' and ''indexFile'', I will pick up where we left off when you run me again.\n')
fprintf('   - If you are assessing FUNCTIONS, you can create a variable named ''AssessmentIsFun'' in the workspace to let me know.\n')
fprintf('     In that case, you need to create a cell array named ''AssessmentInputs'' with each element being an input to the functions.\n')
fprintf('     Also, you need to create a cell array named ''AssessmentOutputs'' with each element being a variable name for the outputs.')
fprintf('     I will try my best to call each M-File within the directory with the inputs specidied in ''AssessmentInputs''\n')
fprintf('   - My new skill; I can now fill in the grades and feedback for your students if you provide me an excel sheet containing student names, surnames and IDNumbers \n')
fprintf('     If you do not provide me an excel sheet, I will just run each M-File normally.\n')
fprintf('  Now get ready for the ride, brace yourself and PRESS ANY KEY to continue... \n')
pause()
if ~exist('folder')
    folder  = uigetdir;
end
if ~exist('CLASSLIST')
    [xlsFile,xlsPath] = uigetfile('*.xls;*.xlsx','Select the class list');
    if xlsFile == 0
        Grading = false;
    else
        [~,~,CLASSLIST] = xlsread(fullfile(xlsPath,xlsFile));
        [CLASSLIST{:,4:end}] = deal(' ');
        CLASSLIST{1,4} = 'Grade';
        CLASSLIST{1,5} = 'Feedback';
        Grading = true;
    end
end
try
    indexStart = indexFile;
catch
    indexStart = 1;
end
list    = dir(fullfile(folder, '*.m'));
n       = length(list);
% editor  = com.mathworks.mlservices.MLEditorServices;
% app=editor.getEditorApplication;

cd(folder)
fprintf('\nGetting rid of clear commands...\n')
for indexFile=indexStart:n
    file=list(indexFile).name;
    commentClrs(folder,file);
end

for indexFile=indexStart:n
    file=list(indexFile).name;
    open(fullfile(folder,file));
    try
        if exist('AssessmentIsFun')
            callString = file(1:end-2);
            callString = [callString, '('];
            for indexInput = 1:length(AssessmentInputs)
                callString = [callString, 'AssessmentInputs{',...
                                num2str(indexInput),'},'];
            end
            callString(end) = ')';
            outputString = '[';
            for i=1:length(AssessmentOutputs)
                outputString = strcat(outputString, [AssessmentOutputs{i}, ',']);
            end
            outputString(end) = ']';
            evalString = strcat(outputString,'=',callString);
            eval(evalString)
        else
            run(fullfile(folder,file));
        end
    catch ME
%         disp('error');
%         rethrow(ME);
        fprintf(2,['\nERROR in file :  ',file, '\n'])
        fprintf(2,[ME.identifier,' :: ', ME.message,'\n'])
%         display('ERROR!')
%         display([ME.identifier,' :: ', ME.message])
    end
    pause();
    if Grading
        [IDNumber, rowIndex] = findStudentID(file,CLASSLIST);
        prompt = {'Enter grade:','Enter feedback:'};
        dlgtitle = ['Student ID : ',IDNumber];
        dims = [1,100; 10 100];
        definput = {'0','No submission'};
        answer = inputdlg(prompt,dlgtitle,dims,definput);
        if isempty(answer)
            fprintf(2,'\nNo grade submitted, moving onto next student.\n')
        else
            CLASSLIST{rowIndex,4} = str2num(answer{1});
            CLASSLIST{rowIndex,5} = answer{2};
        end
%         pause();
    end

%     act=app.getActiveEditor;
%     act.closeNoPrompt;
    act = matlab.desktop.editor.getActive;
    act.closeNoPrompt;

    clc
    close all
    clearvars -except indexFile folder file list n editor app act Assessment* CLASSLIST Grading
end
fprintf('\nHooray! That was the last M File in the directory! \n')
if Grading
    fprintf('I am saving the grades to an excel sheet named ''TempGrades'' in this directory. \n')
    xlswrite('TempGrades', CLASSLIST);
end
fprintf('Now if you want to select a different directory, don''t forget to clear the variables named ''folder'' and ''indexFile''.\n')
fprintf('I hope you had fun... I sure did ^^ \n')
