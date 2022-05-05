function [implicants, v] = multipleOutputSynthesis(inputsNumber, outputs, options)

    arguments
        inputsNumber (1,1) double {mustBeInteger, mustBePositive}
        outputs (:,2) cell

        options.DiodesCost (1,1) double {mustBeNumericOrLogical} = 1
        options.Verbose (1,1) double {mustBeNumericOrLogical} = 0
    end
    
    % returns
    %   the minimal cost synthesis of the boolean outputs described by them
    
    % set of all implicants
    implicantsSet = [];
    outputsImplicantsCount = zeros(length(outputs), 1);
    
    A = [];
    totalMintermLength = 0;

    for i = 1:length(outputs) ; output = outputs(i); 

        minterms = output{1}{1}; 
        dont_cares = output{1}{2};
        
        if ~ utils.isInAscendingOrder(minterms)
            error('Minterms must be in ascending order')
        end
        
        if ~ utils.isInAscendingOrder(dont_cares)
            error('Dont_cares must be in ascending order')
        end
        
        [implicants_k, A_k] = getAllImplicants(inputsNumber, minterms, dont_cares);
        
        outputsImplicantsCount(i) = length(implicants_k);
        implicantsSet = [implicantsSet ; implicants_k];
        
        % every coverage matrix' costraints are indipendent
        A = blkdiag(A, A_k);

        totalMintermLength = totalMintermLength + length(minterms);
        
        if options.Verbose
            fprintf('\nOutput %d:\n\n',i);
            fprintf('All possible implicants are:\n\n') ; disp(implicants_k)
            fprintf('The coverage matrix is:\n\n')      ; disp(A_k)
        end

    end

    notRedundantImplicants = unique(implicantsSet);

    % one more costraint for every notRedundantImplicant
    %   every notRedundantImplicants must be chosen if a corresponding implicant is chosen

    E = eye(length(notRedundantImplicants));
    A = blkdiag(A, E);
    
    % choice costraints:
    %   Z_i > ∑ V_ij * 1/(length(outputs) + 1)

    for i = 1:length(notRedundantImplicants); notRedundantImplicant = notRedundantImplicants(i);
        A(totalMintermLength + i, implicantsSet == notRedundantImplicant) = -1 / (length(outputs) + 1);
    end
    
    variablesLength = length(implicantsSet) + length(notRedundantImplicants); 
    
    % ports cost
    % only the notRedundantImplicants must be considered in the cost
    C = ones(variablesLength, 1);
    C(1:length(implicantsSet)) = 0;
    
    % in the choice costraints the costant value is 0 
    % in the cover constraints the costant value is 1
    b = zeros(totalMintermLength + length(notRedundantImplicants), 1);
    b(1:totalMintermLength) = 1;
    
    % diodes cost
    if options.DiodesCost

        % 1 every time a port is used in an output
        for i = 1:length(implicantsSet)
            C(i) = 1; 
        end

        % c_i every time a port is chosen
        for i = 1:length(notRedundantImplicants)
            C(i + length(implicantsSet)) =  utils.countMatches(notRedundantImplicants(i, :), "0" | "1");
        end
    end

    if options.Verbose
        fprintf('The not redundant implicants are:\n\n')    ; disp(notRedundantImplicants)
        fprintf('The choice matrix is:\n\n')                ; disp(A(totalMintermLength + 1:end, :))
        fprintf('The cost vector is:\n\n')                  ; disp(C)
    end

    [x, v] = utils.intlinprogWrapper(C, -A, -b, variablesLength, options.Verbose);

    % one OR for output
    if ~ options.DiodesCost
        v = v + length(output);
    end

    if options.Verbose
        fprintf('Solution:\n\n')    ; disp(x)
        fprintf('The cost is:\n\n') ; disp(v)
    end

    % build the result implicants

    implicants = cell(length(outputs), 1);
    
    outputIndex = 1;
    outputImplicantsIndex = 1;
    
    % cycle through every implicant
    for i = 1:length(implicantsSet)
        
        % if the ith implicant is has been chosen add it
        if x(i)
            
            % if the outputImplicantsIndex overflow got to the next output
            if outputImplicantsIndex > outputsImplicantsCount(outputIndex)
                outputImplicantsIndex = 1;
                outputIndex = outputIndex + 1;
            end

            implicants{outputIndex} = [implicants{outputIndex} ; implicantsSet(i)];     
        end
        
        % increment the current outputImplicantsIndex 
        outputImplicantsIndex = outputImplicantsIndex + 1;

    end 

end