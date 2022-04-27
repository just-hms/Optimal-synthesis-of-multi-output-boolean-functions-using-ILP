% https://github.com/int-main/Quine-McCluskey
% one_output_synthesis(4, [5, 9, 11, 12, 13, 16], [10 15]);                               % v
% one_output_synthesis(4, [5, 9, 10, 11, 12, 13, 15, 16], []);                            % v

% https://personal.utdallas.edu/~dodge/EE2310/lec5.pdf  
% one_output_synthesis(4, [5, 6, 13, 14], []);                                            % v
% one_output_synthesis(4, [2, 6, 8, 10, 14, 16], []);                                     % v
% one_output_synthesis(4, [1,2,3,5,7,11,13] + 1, []);                                     % v

% https://www.gatevidyalay.com/k-maps-karnaugh-maps-solved-examples/    
% one_output_synthesis(4, [0, 2, 8, 10, 14] + 1, [5, 15] + 1);                              % v but gives different solution

% mine
% one_output_synthesis(4, [0,1] + 1, [0] + 1);                                            % v
% one_output_synthesis(16, [0, 2, 8, 10, 14, 25, 29, 39, 132, 230 ] + 1, [5, 15] + 1);


% tesing
one_output_synthesis(4, [0, 2, 8, 10, 14] + 1, [5, 15] + 1);
 

function one_output_synthesis(variables_number, minterms, dont_cares, diodes_cost)
    
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

    % remove dont_cares from A because they don't need to be covered
    for i = flip(dont_cares)
        A(:,not_zeros == i) = [];
    end

    % rotate the matrix 
    A = A.';

    % ports cost
    C = 2 * ones(length(implicants), 1);
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
    
    % visualize implicants
    for i = 1:length(x)
        if x(i)
            implicants(i,:)
        end
    end
end

function [implicants, A] = getAllImplicants(variables_number, not_zeros)    

    arguments
        variables_number (1,1) double {mustBeInteger, mustBePositive}
        not_zeros (1,:) double {mustBeInteger, mustBePositive, utils.mustBeInAscendingOrder} 
    end

    % returns
    %   implicants := a list of all implicants generated using QM algorithm
    %   A := a coverage matrix that indicates whether an implicant covers or not a not_zero
    
    % given the indexes the values are these
    not_zeros_value = not_zeros - 1;
    not_zeros_binaries = string(dec2bin(not_zeros_value, variables_number));

    % first iteration of QM

    groups = cell(variables_number + 1, 1);
    for i = 1:length(not_zeros)
        
        % get group index from number of ones
        index = utils.countChars(not_zeros_binaries(i,:),'1') + 1;
        
        % insert the not_zero in the correct group
        groups{index} = [groups{index}, not_zeros_binaries(i,:)];  

    end

    % at first 
    %   implicants are minterms
    %   and the A matrix is an identity because every not_zero is cover by its minterm 
    implicants = not_zeros_binaries;
    A = eye(length(implicants));
    
    % other iterations of QM

    while ~ utils.allCellsEmpty(groups)

        next_iteration_groups = cell(variables_number + 1, 1);
        
        % compare every implicant of a i-group with every implicant of the (i+1)-group
        % if they merge :
        %   insert the merged_implicant into a new group for the next QM iteration
        %   insert the merged_implicant into the implicant list

        for i = 1:length(groups) - 1 ; group = groups{i};
    
            if isempty(group) ; continue ; end
            
            group_to_compare_with = groups{i + 1};

            if isempty(group_to_compare_with) ; continue ; end

            for j = 1:length(group) ; implicant = group(j);
                
                for k = 1:length(group_to_compare_with) ; implicant_to_compare_with = group_to_compare_with(k);
                    
                    merged_implicant = utils.mergeStrings(implicant, implicant_to_compare_with, '-');
    
                    % if the merged_implicant is empty continue
                    if merged_implicant == "" ; continue ; end
                    
                    % if the merged_implicant is redundant continue
                    if any(strcmp(next_iteration_groups{i}, merged_implicant)) ; continue ; end
                                        
                    % if merged_implicant is correct then add it to the implicants
                    implicants = [implicants ; merged_implicant];
                                        
                    % insert a new line in the coverage matrix
                    A(length(implicants),1) = 0;
                    
                    % get the two implicants' indexes
                    idx_implicant = utils.findString(implicants, implicant{1});
                    idx_to_check = utils.findString(implicants, implicant_to_compare_with{1});
                    
                    % the merged_implicant covers the OR bitmap of the two generator implicants by definitions
                    A(length(implicants), :) = A(idx_implicant, :) | A(idx_to_check, :);
                    
                    % add the merged_implicant in the next_iteration_groups
                    next_iteration_groups{i} = [next_iteration_groups{i}, merged_implicant];

                end
            end    
        end

        groups = next_iteration_groups;

    end
end