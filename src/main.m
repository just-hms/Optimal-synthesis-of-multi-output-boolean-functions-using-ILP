% https://github.com/int-main/Quine-McCluskey
% synthesize(4, [5, 9, 11, 12, 13, 16], [10 15]);
% synthesize(4, [5, 9, 10, 11, 12, 13, 15, 16], []);

% https://personal.utdallas.edu/~dodge/EE2310/lec5.pdf
% synthesize(4, [5, 6, 13, 14], []);
% synthesize(4, [2, 6, 8, 10, 14, 16], []);
% synthesize(4, [1,2,3,5,7,11,13] + 1, []);

% https://www.gatevidyalay.com/k-maps-karnaugh-maps-solved-examples/
synthesize(4, [0, 2, 8, 10, 14] + 1, [5, 15] + 1);

function synthesize(variables_number, minterms, dont_cares)

    % given
    %   variables_number := integer (ex: 4)
    %   minters := ordered list of indexes (ex: [0, 2, 4, 6])
    %   dont_cares := ordered list of indexes (ex: [1, 3])
    % shows
    %   the minimal cost synthesis 

    not_zeros = utils.merge_sorted(minterms, dont_cares);
    
    checkInputs(variables_number, minterms, dont_cares, not_zeros);
    
    % implicants search is not influeced by the difference between minterms and dont_cares  
    [implicants, A] = getAllImplicants(variables_number, not_zeros);

    % remove dont_cares from A because they don't need to be covered
    for i = flip(dont_cares)
        A(:,find(not_zeros == i)) = [];
    end

    % rotate the matrix 
    A = A.';

    % ports
    C = 2 * ones(length(implicants), 1);
    b = ones(length(A(:,1)), 1);
    
    % diodes
    for i = 1:length(implicants)
        C(i) = utils.countChars(implicants(i, :),'1') + utils.countChars(implicants(i, :),'0'); 
    end
    
    % all variables must be integers
    intcon = length(implicants);
    
    % lower and upper bounds are 0s and 1s
    lb = zeros(length(implicants), 1);
    ub = ones(length(implicants), 1);
    
    [x, v] = intlinprog(C,intcon,- A, - b,[],[],lb,ub)
    
    for i = 1:length(x)
        if x(i)
            implicants(i,:)
        end
    end
end

function checkInputs(variables_number, minterms, dont_cares, not_zeros)

    combinations = 2 ^ variables_number;

    last = 0;
    for i = minterms 

        if i > combinations ; error('minterm index out of bounds') ; end

        if i < last ; error('minterms must be in ascendent order') ; end

        if i == last ; error('minterm inserted multiple times') ; end
        
        last = i;
    end
    
    last = 0;
    for i = dont_cares        
        
        if i > combinations ; error('dont care index out of bounds') ; end
        
        if i < last ; error('dont cares must be in ascendent order') ; end

        if i == last ; error('dont care inserted multiple times') ; end
        
        last = i;
    end

    last = 0;
    for i = not_zeros        
        
        if i == last ; error('minterms and dont care collide') ; end      

        last = i;
    end

    if length(minterms) <= 0 ; error('this function is synthesizable with a 0') ; end  

    if length(minterms) + length(dont_cares) == combinations
        error('this function is synthesizable with a 1')
    end  
    
end

function [implicants, A] = getAllImplicants(variables_number, not_zeros)    

    % given
    %   variables_number := integer (ex: 4)
    %   not_zeros := ordered list of indexes (ex: [0, 2, 4, 6])
    % returns
    %   implicants := a list of all implicants
    %   A := a coverage matrix that indicates whether an implicant covers or not  a not_zero
    
    implicants = [];
    A = [];
    
    % given the indexes the values are these
    not_zeros_value = not_zeros - 1;
    % converts an int to a binary string with minimun length of variables_number
    not_zeros_binaries = dec2bin(not_zeros_value, variables_number);
    
    % first itation of QM

    groups = cell(variables_number + 1, 1);
    for i = 1:length(not_zeros)
        
        % get group index from number of ones
        index = length(strfind(not_zeros_binaries(i,:),'1')) + 1;
        
        % insert the not_zero in the correct group
        groups{index} = [groups{index}, string(not_zeros_binaries(i,:))];  

    end

    % at first 
    %   implicants are minterms
    %   and the A matrix is and identity because every not_zero is cover by its minterm 
    implicants = not_zeros_binaries;
    A = eye(length(implicants));
    
    % other iterations of QM

    while ~ utils.allCellsEmpty(groups)

        next_groups = cell(variables_number + 1, 1);
        
        for i = 1:length(groups) - 1 ; group = groups{i};
    
            if isempty(group) ; continue ; end
            
            % in QM you need to compare with the next group
            group_to_compare_with = groups{i + 1};
                
            for j = 1:length(group) ; implicant = group(j);
                
                for k = 1:length(group_to_compare_with) ; implicant_to_compare_with = group_to_compare_with(k);
                    
                    result_implicant = utils.mergeStrings(implicant, implicant_to_compare_with, '-');
    
                    % if the result_implicant is empty continue
                    if result_implicant == "" ; continue ; end
                    
                    % if the result_implicant is already in redundant continue
                    if any(strcmp(next_groups{i}, result_implicant)) ; continue ; end
                    
                    % if result_implicant is correct then add it to the implicants
                    implicants = [implicants ; result_implicant{1}];
                    
                    % TODO find a way to get the index of an implicant in O(1)
                    
                    % insert a new line in the coverage matrix
                    A(length(implicants),1) = 0;
                    
                    % get the two implicants' indexes
                    idx_implicant = utils.findString(implicants, implicant{1});
                    idx_to_check = utils.findString(implicants, implicant_to_compare_with{1});
                    
                    % the result implicant covers the OR bitmap of the two generator implicants by definitions
                    A(length(implicants), :) = A(idx_implicant, :) | A(idx_to_check, :);
                    
                    % add the result implicant in the next groups
                    %   i indicates the next_groups' current group
                    next_groups{i} = [next_groups{i}, result_implicant];
                end
            end    
        end

        groups = next_groups;

    end
end