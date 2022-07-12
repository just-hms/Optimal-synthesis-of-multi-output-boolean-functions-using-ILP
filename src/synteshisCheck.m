function check = synteshisCheck(implicants, minterms, dontCares)
    arguments
        implicants (1,:) string ...
            {mustBeNonempty}
        
        minterms (1,:) double ...
            {mustBeInteger, mustBePositive, mustBeNonempty, utils.mustBeAscending} = []
        
        dontCares (1,:) double ...
            {mustBeInteger, mustBePositive, utils.mustBeAscending} = []
    end

    inputsNumber = strlength(implicants(1));
    check = true;
    truthTable = zeros(2 ^ inputsNumber);

    for i=1:length(implicants)
        
        implicant = implicants(i);

        for minterm=1:length(truthTable)
            
            if isCovered(dec2bin(minterm - 1, inputsNumber), implicant{1})  
                truthTable(minterm) = 1;
            end
        end
    end
    
    for i=1:length(truthTable)
        
        % if this element don't care skip it
        if any(dontCares == i) ; continue ; end
        
        % if it's a one
        if truthTable(i) == 1 
                
            % check wheter it's wrong
            if ~ any(minterms == i) 
                check = false;
                return
            end

            continue
        end

        % if it's a zero 
        % check wheter it's wrong

        if any(minterms == i)
            check = false;
            return
        end

    end

end


function res = isCovered(minterm, implicant)
    
    res = true;

    for i=1:length(minterm)

        if implicant(i) == '-'; continue ; end
        if implicant(i) ~= minterm(i)
            res = false;
            return
        end
    end

end