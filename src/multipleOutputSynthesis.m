function [implicants, v] = multipleOutputSynthesis(variables_number, outputs, diodes_cost)

    % TODO maybe use repeating arguments for the outputs
    arguments
        variables_number (1,1) double {mustBeInteger, mustBePositive}
        outputs (:,2) cell 
        diodes_cost (1,1) double {mustBeNumericOrLogical} = 1
    end

    % returns
    %   the minimal cost synthesis of the boolean outputs described by them
    
    implicants_set = [];
    implicants_counts = zeros(length(outputs), 1);
    A = [];
    minterms_len = 0;

    not_redundant_implicants = [];

    for i = 1:length(outputs) ; f = outputs(i); 

        minterms = f{1}{1}; 
        dont_cares = f{1}{2};
        
        if ~ utils.isInAscendingOrder(minterms)
            error('Minterms must be in ascending order')
        end
        
        if ~ utils.isInAscendingOrder(dont_cares)
            error('Dont_cares must be in ascending order')
        end
        
        [implicants_k, A_k] = getAllImplicants(variables_number, minterms, dont_cares);
        
        implicants_counts(i) = length(implicants_k);
        implicants_set = [implicants_set ; implicants_k];
        
        A = blkdiag(A, A_k);

        minterms_len = minterms_len + length(minterms);
        
    end

    % create the not redundant list of implicants_set
    for i = 1:length(implicants_set) ; implicant = implicants_set(i);
        if ~ any(strcmp(not_redundant_implicants, implicant))                
            not_redundant_implicants = [not_redundant_implicants ; implicant];
        end
    end
    
    E = eye(length(not_redundant_implicants));
    A = blkdiag(A, E);

    % choice costraints 
    for i = 1:length(not_redundant_implicants); implicant = not_redundant_implicants(i);
        A(minterms_len + i, implicants_set == implicant) = -1 / (length(outputs) + 1);
    end

    total_implicants_len = length(implicants_set) + length(not_redundant_implicants); 

    % ports cost
    C = ones(total_implicants_len, 1);
    C(1:length(implicants_set)) = 0;
    
    b = zeros(minterms_len + length(not_redundant_implicants), 1);
    b(1:minterms_len) = 1;
    
    % diodes cost
    if diodes_cost
        for i = 1:length(implicants_set)
            C(i) = 1; 
        end

        for i = 1:length(not_redundant_implicants)
            C(i + length(implicants_set)) =  utils.countMatches(not_redundant_implicants(i, :), "0" | "1");
        end
    end

    % all variables must be integers
    intcon = 1:total_implicants_len;
    
    % lower and upper bounds are 0s and 1s
    lb = zeros(total_implicants_len, 1);
    ub = ones(total_implicants_len, 1);
    
    [x, v] = intlinprog(C,intcon,- A, - b,[],[],lb,ub);

    % or port cost
    if ~ diodes_cost
        v = v + 1;
    end

    % build the result implicants (one array for every output)
    implicants = cell(length(outputs), 1);
    current_count = 1;
    j = 1;

    for i = 1:length(implicants_set)
        
        if x(i)
            
            if current_count > implicants_counts(j)
                j = j + 1;
            end

            implicants{j} = [implicants{j} ; implicants_set(i)];     
        end
        
        current_count = current_count + 1;

    end 

end