function commentClrs(Folder,File)
    %   supressClears('C:\foo\foo\foo\foo.m')
    % Given the fullpath to an M-File, comments out the 'clear' commands in 
    % the file.
    contents = fileread(fullfile(Folder,File));
    indexClearN = strfind(contents,['clear',newline]);
    indexClearA = strfind(contents,'clear ');
    indexClear = [indexClearA, indexClearN];
    if ~isempty(indexClear)
        for i=1:length(indexClear)
            disp(['Clear found in following file, commenting out: ', File])
            contents = [contents(1:indexClear(i)-1), '%', contents(indexClear(i):end)];
            indexIncrement = indexClear>indexClear(i);
            indexClear(indexIncrement) = indexClear(indexIncrement)+1;
        end
    end
    fclose all;
    hFile = fopen(fullfile(Folder,File),'w');
    fwrite(hFile,contents);
    fclose(hFile);
end

