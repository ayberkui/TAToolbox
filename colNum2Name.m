%% Didnt work, use ExcelColumn instead

function ColName = colNum2Name(n)
    nAlph = length('A':'Z')+1;
    nChar = ceil(log(n)/log(nAlph)+eps); % number of characters needed to represent column
    
    ColName = zeros(1,nChar);
    for i = nChar:-1:1
        ColName(nChar-i+1) = char('@' + floor(mod(n,nAlph^i)/(nAlph^(i-1))));
    end
    ColName = char(ColName);
    ColName(ColName=='@') = 'Z';
end

