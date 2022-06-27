function displayImplicants(outputs_implicants,options)
    arguments
        outputs_implicants (1,:) cell
        
        options.LatexSyntax (1,1) double ...
            {mustBeNumericOrLogical} = 0
    end

    if options.LatexSyntax
        error('unimplemented')
    end

    fprintf('Solution: ')

    for i = 1:length(outputs_implicants)
        implicants = outputs_implicants{i};

        fprintf('[');

        for j = 1:length(implicants)
            
            implicant = implicants{j};

            for k = 1:length(implicant)
                
                letter = implicant(k);
                
                if strcmp(letter,'-') ; continue ; end

                fprintf('x%d',length(implicant) - k + 1)

                if strcmp(letter,'1') ; continue ; end
                
                fprintf('`')
            end

            if j == length(implicants) ; continue ; end
            fprintf(' + ')

        end

        fprintf(']');
        
    end
    fprintf('\n')
end