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

    while ~ utils.areAllCellsEmpty(groups)

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