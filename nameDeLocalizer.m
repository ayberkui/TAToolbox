function newname = nameDeLocalizer(name)
%   newname = nameDeLocalizer(name)
%
%   Convert accented Turkish characters to English counterparts and
%   lowercase the name.
%   Inputs:
%       name : character array containing the name
%   Outputs:
%       newname : converted character array

    newname = name;
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

    newname = lower(newname);
end