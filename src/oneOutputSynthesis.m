function [implicants, v] = oneOutputSynthesis(variables_number, minterms, dont_cares, diodes_cost)
    
    arguments
        variables_number (1,1) double {mustBeInteger, mustBePositive}
        minterms (1,:) double {mustBeInteger, mustBePositive, utils.mustBeInAscendingOrder}
        dont_cares (1,:) double {mustBeInteger, mustBePositive, utils.mustBeInAscendingOrder} 
        diodes_cost (1,1) double {mustBeNumericOrLogical} = 1
    end

    % returns
    %   the minimal cost synthesis of the boolean function described by them

    [implicants, A] = getAllImplicants(variables_number, minterms, dont_cares);

    % ports cost
    C = ones(length(implicants), 1);
    b = ones(length(minterms), 1);
    
    % diodes cost
    if diodes_cost
        for i = 1:length(implicants)
            C(i) = utils.countMatches(implicants(i, :), "0" | "1") + 1; 
        end
    end

    % all variables must be integers
    intcon = 1:length(implicants);
    
    % lower and upper bounds are 0s and 1s
    lb = zeros(length(implicants), 1);
    ub = ones(length(implicants), 1);
    
    [x, v] = intlinprog(C,intcon,- A, - b,[],[],lb,ub);

    % remove all implicants that are not used
    for i = flip(x)
        implicants(x == 0) = []; 
    end

    % or port cost
    if ~ diodes_cost
        v = v + 1;
    end
    
end