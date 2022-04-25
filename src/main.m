% variables_number = 4;
% minterms = [0, 2, 4, 5, 6, 9, 10];
% dont_cares = [7, 11, 12, 13, 14, 15];

% https://github.com/int-main/Quine-McCluskey
% [implicants, A] = getAllImplicants(4, [5, 9, 11, 12, 13, 16], [10 15]);
% [implicants, A] = getAllImplicants(4, [5, 9, 10, 11, 12, 13, 15, 16], []);

% https://personal.utdallas.edu/~dodge/EE2310/lec5.pdf
% [implicants, A] = getAllImplicants(4, [5, 6, 13, 14], []);
% [implicants, A] = getAllImplicants(4, [2, 6, 8, 10, 14, 16], []);
% [implicants, A] = getAllImplicants(4, [1,2,3,5,7,11,13] + 1, []);

% https://www.gatevidyalay.com/k-maps-karnaugh-maps-solved-examples/
[implicants, A] = getAllImplicants(4, [0, 2, 8, 10, 14] + 1, [5, 15] + 1);

% costo a porte
C = 2 * ones(length(implicants), 1);
b = ones(length(A(:,1)), 1);

% costo a diodi
for i = 1:length(implicants)
    C(i) = length(strfind(implicants(i, :),'1')) + length(strfind(implicants(i, :),'0')); 
end

intcon = length(implicants);

lb = zeros(length(implicants), 1);
ub = ones(length(implicants), 1);

[x, v] = intlinprog(C,intcon,- A, - b,[],[],lb,ub)

for i = 1:length(x)
    if x(i)
        implicants(i,:)
    end
end

function result_implicant = mergeImplicants(first_implicant, second_implicant)
    
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

function checkInputs(minterms, dont_cares, variables_number)
    
    combinations = 2 ^ variables_number;

    last = 0;
    for i = minterms        
        if i > combinations
            error('minterm index out of bounds')
        end

        if i < last
            error('minterms must be in ascendent order')
        end

        if i == last
            error('minterm inserted multiple times')
        end
        
        last = i;
    end
    
    last = 0;
    for i = dont_cares        
        
        if i > combinations
            error('dont care index out of bounds')
        end
        
        if i < last
            error('dont cares must be in ascendent order')
        end

        
        if i == last
            error('dont care inserted multiple times')
        end
        
        last = i;
    end

    if length(minterms) <= 0
        error('this function is synthesizable with a 0')
    end  

    if length(minterms) + length(dont_cares) == combinations
        error('this function is synthesizable with a 1')
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

function res = merge_sorted(array_1,array_2)
    
    i_1 = 1;
    i_2 = 1;
    total_length = length(array_1) + length(array_2);
    res = zeros(total_length, 1);
    
    for i = 1: total_length
        
        if i_1 > length(array_1)
            res(i) = array_2(i_2);
            i_2 = i_2 + 1;
            continue
        end
        
        if i_2 > length(array_2)
            res(i) = array_1(i_1);
            i_1 = i_1 + 1;
            continue
        end
        
        if array_1(i_1) < array_2(i_2)
            res(i) = array_1(i_1);
            i_1 = i_1 + 1;
        else
            res(i) = array_2(i_2);
            i_2 = i_2 + 1;
        end
    end
end

function [implicants, A] = getAllImplicants(variables_number, minterms, dont_cares)    

    % given
    %   variables_number := integer (ex: 4)
    %   minterm := list of indexes (ex: [0, 2, 4, 6])
    %   dont_cares := list of indexes (ex: [1, 3])
    % returns
    %   implicants := a list of all implicants
    %   A := a matrix that indicates whether an implicant cover a minterm
    
    checkInputs(minterms, dont_cares, variables_number);
    
    implicants = [];
    A = [];
    
    % given the indexes the values are these
    not_zeros = merge_sorted(minterms, dont_cares);

    not_zeros_value = not_zeros - 1;
    binaries = dec2bin(not_zeros_value, variables_number);

    % first itation of QM
    groups = cell(variables_number + 1, 1);

    for i = 1:length(not_zeros)
        
        % get group index from number of ones
        index = length(strfind(binaries(i,:),'1')) + 1;
        % insert the minterm in the correct group
        groups{index} = [groups{index}, string(binaries(i,:))];  

    end

    % check for length (get length of vector)
    implicants = binaries;
    A = zeros(length(not_zeros), length(implicants));

    
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
                    
                    result_implicant = mergeImplicants(implicant, to_check);
    
                    if result_implicant == "" ; continue ; end

                    if ~any(strcmp(new_groups{i}, result_implicant))
                        
                        implicants = [implicants ; result_implicant{1}];
                        
                        % TODO find a way to get the index of an implicant in O(1)
                        
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

    % remove dont_cares from A
    for i = flip(dont_cares)
        A(:,find(not_zeros == i)) = [];
    end

    % TODO fix this
    A = A.';

end