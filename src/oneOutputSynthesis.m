function [implicants, v] = oneOutputSynthesis(minterms, dontCares, options)
    
    arguments
        
        minterms (1,:) double {mustBeInteger, mustBePositive, mustBeNonempty, utils.mustBeInAscendingOrder}
        dontCares (1,:) double {mustBeInteger, mustBePositive, utils.mustBeInAscendingOrder} 
        
        options.InputsNumber (1,1) double {mustBeInteger, mustBePositive} = utils.minimumBits([minterms, dontCares])
        options.DiodesCost (1,1) double {mustBeNumericOrLogical} = 1
        options.Verbose (1,1) double {mustBeNumericOrLogical} = 0
    end

    % returns
    %   the minimal cost synthesis of the boolean function described by them

    if options.Verbose
        fprintf('\nThe inputs number is:\n\n')                  ; disp(options.InputsNumber)
    end

    [implicants, A] = getAllImplicants(options.InputsNumber, minterms, dontCares);

    % ports cost for every AND port
    C = ones(length(implicants), 1);
    b = ones(length(minterms), 1);
    
    % diodes cost
    if options.DiodesCost
        for i = 1:length(implicants)
            C(i) = utils.countMatches(implicants(i, :), "0" | "1") + 1; 
        end
    end

    if options.Verbose
        fprintf(newline, 'All possible implicants are:\n\n')    ; disp(implicants)
        fprintf('The coverage matrix is:\n\n')                  ; disp(A)
        fprintf('The cost vector is:\n\n')                      ; disp(C)
    end

    [x, v] = utils.intlinprogWrapper(C, -A, -b, length(implicants), options.Verbose);

    if ~ options.DiodesCost
        v = v + 1;
    end

    if options.Verbose
        fprintf('Solution:\n\n')    ; disp(x)
        fprintf('The cost is:\n\n') ; disp(v)
    end

    % remove all implicants that are not used
    for i = flip(x)
        implicants(x == 0) = []; 
    end
    
end