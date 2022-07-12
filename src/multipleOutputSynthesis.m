function [implicants,v,timedOut] = multipleOutputSynthesis(inputsNumber,outputs,options)

    arguments
        inputsNumber (1,1) double ...
            {mustBeInteger,mustBePositive}
        outputs (1,:) cell

        options.GatesInputCost (1,1) double ...
            {mustBeNumericOrLogical} = 1
        options.Verbose (1,1) double ...
            {mustBeNumericOrLogical} = 0
        options.Timeout (1,1) double ...
            {mustBeGreaterThanOrEqual(options.Timeout,0)} = 0
    end
    
    % returns
    %   the minimal cost synthesis
    
    % set of all implicants
    implicantsSet = [];
    outputsImplicantsCount = zeros(length(outputs),1);
    
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
        
        [implicants_k,A_k] = ...
            getAllImplicants(inputsNumber,minterms,dont_cares);
        
        outputsImplicantsCount(i) = length(implicants_k);
        implicantsSet = [implicantsSet ; implicants_k];
        
        % every coverage matrix' costraints are indipendent
        A = blkdiag(A,A_k);

        totalMintermLength = totalMintermLength + length(minterms);
        
        if options.Verbose
            fprintf('\nOutput %d:\n\n',i);
            fprintf('All possible implicants are:\n\n')
            disp(implicants_k)
            fprintf('The coverage matrix is:\n\n')
            disp(A_k)
        end

    end

    uniqueImplicants = unique(implicantsSet);

    % add one more costraint for every uniqueImplicants
    %   every uniqueImplicants must be chosen if 
    %   a corresponding implicant is chosen

    E = eye(length(uniqueImplicants));
    A = blkdiag(A,E);
    Phi = zeros(length(uniqueImplicants), length(implicantsSet));
    
    % choice matrix
    for i = 1:length(uniqueImplicants)
        
        uniqueImplicant = uniqueImplicants(i);
        
        Phi(i, implicantsSet == uniqueImplicant) = ...
            -1 / (length(outputs) + 1);
    end

    A(totalMintermLength + 1:end,1:length(implicantsSet)) = Phi;
    
    variablesLength = length(implicantsSet) + length(uniqueImplicants); 
    
    % literal cost
    % only the uniqueImplicants must be considered in the cost
    C = ones(variablesLength,1);
    C(1:length(implicantsSet)) = 0;
    
    % in the choice costraints the costant value is 0 
    % in the cover constraints the costant value is 1
    b = zeros(totalMintermLength + length(uniqueImplicants),1);
    b(1:totalMintermLength) = 1;
    
    % gateInput cost
    if options.GatesInputCost

        % 1 every time a port is used in an output
        for i = 1:length(implicantsSet)
            C(i) = 1; 
        end

        % c_i every time a port is chosen
        for i = 1:length(uniqueImplicants)
            C(i + length(implicantsSet)) = ...
                utils.countMatches(uniqueImplicants(i,:), "0" | "1");
        end
    end

    if options.Verbose
        fprintf('The not redundant implicants are:\n\n')
        disp(uniqueImplicants)

        fprintf('The choice matrix is (one implicant each column):\n\n')

        format bank
        disp(-Phi.')
        format default
        
        fprintf('The cost vector is:\n\n')
        disp(C.')
    end

    [x,v,timedOut] = utils.intlinprogWrap( ...
        C, ...
        -A, ...
        -b, ...
        variablesLength, ...
        options.Verbose, ...
        options.Timeout ...
    );

    % if it's literal cost add 1 for, everty OR/output
    if ~ options.GatesInputCost
        v = v + length(output);
    end

    if options.Verbose
        fprintf('Solution:\n\n')
        disp(x.')
        fprintf('The cost is:\n\n')
        disp(v)
    end

    % build the result implicants

    implicants = cell(length(outputs),1);
    
    outputIndex = 1;
    outputImplicantsIndex = 1;
    
    % cycle through every implicant
    for i = 1:length(implicantsSet)
        
        if outputImplicantsIndex > outputsImplicantsCount(outputIndex)
            outputImplicantsIndex = 1;
            outputIndex = outputIndex + 1;
        end
        
        % if the ith implicant is has been chosen add it
        if x(i)
            
            % if the outputImplicantsIndex overflow got to the next output

            implicants{outputIndex} = ...
                [implicants{outputIndex} ; implicantsSet(i)];     
        end
        
        % increment the current outputImplicantsIndex 
        outputImplicantsIndex = outputImplicantsIndex + 1;

    end 

end