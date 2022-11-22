Files = dir('*.m');
EgoName = mfilename;
EgoName = [EgoName, '.m'];


for i = 1:length(Files)
    name = Files(i).name;
    if strcmp(name,'.') || strcmp(name,'..') || strcmp(name,EgoName)
        continue
    end
    [fpath, fname, fext] = fileparts(name);
    newname = fname;
    newname(newname==' ') = '_';
    newname(newname=='Ç') = 'C';
    newname(newname=='Ğ') = 'G';
    newname(newname=='İ') = 'I';
    newname(newname=='Ö') = 'O';
    newname(newname=='Ş') = 'S';
    newname(newname=='Ü') = 'U';
    newname(newname=='ç') = 'c';
    newname(newname=='ğ') = 'g';
    newname(newname=='ı') = 'i';
    newname(newname=='ö') = 'o';
    newname(newname=='ş') = 'ş';
    newname(newname=='ü') = 'u';
    newname(newname=='(') = '_';
    newname(newname==')') = '_';
    newname(newname=='-') = '_';
    if length(newname)>56
        newname = [newname(1:56),fext];
    else
        newname = [newname,fext];
    end
    if ~strcmp(name,newname)
        if ~exist(newname,'file')
            movefile(name,newname,'f')
        else
            iExt = strfind(newname, '.');
            if isempty(iExt)
                newname = [newname, num2str(i)];
            else
                newname = [newname(1:iExt-1), num2str(i), fext];
            end
            movefile(name,newname,'f');
        end
    end
end