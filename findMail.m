        for k=2:52
            if strcmp(raw{k,2},filenamei)
                indexi=k;
            end
        end
        
        raw{indexi,2}
        