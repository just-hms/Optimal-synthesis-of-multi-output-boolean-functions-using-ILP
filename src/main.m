
% variables_number = 4;
% minterms = [0, 2, 4, 5, 6, 9, 10];
% dont_cares = [7, 11, 12, 13, 14, 15];

getAllImplicants(4, [5, 9, 10, 11, 12, 13, 15, 16]);


function result_implicant = merge(first_implicant, second_implicant)
    
    result_implicant = first_implicant;

    count = 0;

    for i = 1:length(first_implicant{1})

        f = first_implicant{1}(i);
        s = second_implicant{1}(i);

        if (f == '-' || s == '-') && f ~= s
            result_implicant = "";
			return
        end
        
        if f ~= s
            result_implicant{1}(i) = '-';
            count = count + 1;
        end 

        if count > 1
            result_implicant = "";
            return
        end
    end
end

function checkInputs(minterms, combinations)
    for i = minterms        
        if i > combinations
            error('minterm index out of bounds')
        end
    end

    if length(minterms) <= 0 ; return ; end
    
    if length(minterms) == combinations
        error('this function is a 1')
    end  
    
end

function idx = getIndex(implicants, implicant)

    idx = -1;

    for i = 1:length(implicants)
        if strcmp(implicants(i, :), implicant)
            idx = i;
            return
        end
    end
    
end

function [A, implicants] = getAllImplicants(variables_number, minterms)    

    % given
    %   variables_number := integer (ex: 4)
    %   minterm := list of indexes (ex: [0, 2, 4, 6])
    % returns
    %   A := a matrix that indicates whether an implicant cover a minterm
    %   implicants := a list of all implicants
    
    implicants = [];
    A = [];
    combinations = 2 ^ variables_number;
    
    % give the indexes the values are this
    minterms_value = minterms - 1;
    binaries = dec2bin(minterms_value, variables_number);

    checkInputs(minterms, combinations);
    
    % first itation of QM
    groups = cell(variables_number + 1, 1);

    for i = 1:length(minterms)
        
        % get group index from number of ones
        index = length(strfind(binaries(i,:),'1')) + 1;
        % insert the minterm in the correct group
        groups{index} = [groups{index}, string(binaries(i,:))];    
    end

    % check for length (get length of vector)
    implicants = binaries;
    A = zeros(length(minterms), length(implicants));

    
    for i = 1:length(implicants)
        A(i,i) = 1;
    end
    
    % while groups is not empty
    while 1

        new_groups = cell(variables_number + 1, 1);
        
        for i = 1:length(groups) - 1 ; group = groups{i};
    
            if isempty(group) ; continue ; end
    
            group_to_check = groups{i + 1};
    
            for j = 1:length(group) ; implicant = group(j);
    
                for k = 1:length(group_to_check) ; to_check = group_to_check(k);
                    
                    result_implicant = merge(implicant, to_check);
    
                    if result_implicant == "" ; continue ; end

                    if ~any(strcmp(new_groups{i}, result_implicant))
                        
                        implicants = [implicants ; result_implicant{1}];
                        
                        % TODO this faster
                        % insert a new line
                        A(length(implicants),1) = 0;
                        
                        % get the two indexes
                        idx_implicant = getIndex(implicants, implicant{1});
                        idx_to_check = getIndex(implicants, to_check{1});
                        
                        % logical or for implicant cover
                        A(length(implicants), :) = A(idx_implicant, :) | A(idx_to_check, :);

                        new_groups{i} = [new_groups{i}, result_implicant];
                    end
                end
            end    
        end

        % check if groups are empty

        all_empty = 1;
        for i = 1:variables_number + 1
            if ~ isempty(new_groups{i})
                all_empty = 0;
            end
        end
    
        % exit while
        if all_empty ; break ; end 

        groups = new_groups;

    end

end