function oneOutputSynthesis(variables_number, minterms, dont_cares, diodes_cost)
    
    arguments
        variables_number (1,1) double {mustBeInteger, mustBePositive}
        minterms (1,:) double {mustBeInteger, mustBePositive, utils.mustBeInAscendingOrder}
        dont_cares (1,:) double {mustBeInteger, mustBePositive, utils.mustBeInAscendingOrder} 
        diodes_cost (1,1) double {mustBeNumericOrLogical} = 1
    end

    % visualize
    %   the minimal cost synthesis of the boolean function described by them

    not_zeros = utils.merge_sorted(minterms, dont_cares);

    if ~ utils.isInAscendingOrder(not_zeros)
        error('Inputs minterms and dont_cares have an element in common')
    end

    % implicants' search is not influeced by the difference between minterms and dont_cares  
    [implicants, A] = getAllImplicants(variables_number, not_zeros);

    % remove dont_cares costraints from coverage matrix because they don't need to be covered
    for i = flip(dont_cares)
        A(:,not_zeros == i) = [];
    end

    % remove implicants that covered only dont_cares
    for i = length(implicants):-1:1
        if ~ any(A(i,:) == 1)
            A(i,:) = [];
            implicants(i) = [];
        end
    end

    % rotate the matrix 
    A = A.';


    % ports cost
    C = ones(length(implicants), 1);
    b = ones(length(minterms), 1);
    
    % diodes cost
    if diodes_cost
        for i = 1:length(implicants)
            C(i) = utils.countChars(implicants(i, :),'1') + utils.countChars(implicants(i, :),'0'); 
        end
    end

    % all variables must be integers
    intcon = length(implicants);
    
    % lower and upper bounds are 0s and 1s
    lb = zeros(length(implicants), 1);
    ub = ones(length(implicants), 1);
    
    [x, v] = intlinprog(C,intcon,- A, - b,[],[],lb,ub)
    
    % visualize synthesis
    for i = 1:length(x)
        if x(i)
            implicants(i,:)
        end
    end
end