function [implicants, A] = getAllImplicants(inputsNumber, minterms, dontCares)    
    
    arguments
        inputsNumber (1,1) double {mustBeInteger, mustBePositive}
        minterms (1,:) double {mustBeInteger, mustBePositive, utils.mustBeInAscendingOrder} 
        dontCares (1,:) double {mustBeInteger, mustBePositive, utils.mustBeInAscendingOrder} = []
    end

    % uses
    %   QM algorithm to retrieve a list of all implicants
    % returns
    %   implicants := a list of all implicants generated using QM algorithm
    %   A := a coverage matrix that indicates whether an implicant covers or not a not_zero
    
    notZeros = utils.mergeSorted(minterms, dontCares);

    if inputsNumber < utils.minimumBits(notZeros)
        error('Variables number: %d  is too small', inputsNumber)
    end

    if ~ utils.isInAscendingOrder(notZeros)
        error('Inputs minterms and dontCares have an element in common')
    end

    % given the indexes, get the value (-1) and then convert it to binary
    notZerosBinaries = string(dec2bin(notZeros - 1, inputsNumber));

    % first iteration of QM

    groups = cell(inputsNumber + 1, 1);
    for i = 1:length(notZeros)
        
        % get group index from number of ones
        index = utils.countMatches(notZerosBinaries(i,:),"1") + 1;
        
        % insert the not_zero in the correct group
        groups{index} = [groups{index}, notZerosBinaries(i,:)];  

    end

    % at first 
    %   implicants are minterms
    %   and the A matrix is an identity because every not_zero is cover by its minterm 
    implicants = notZerosBinaries;
    A = eye(length(implicants));
    
    % other iterations of QM

    while ~ utils.areAllCellsEmpty(groups)

        nextIterationGroups = cell(inputsNumber + 1, 1);
        
        % compare every implicant of a i-group with every implicant of the (i+1)-group
        % if they merge :
        %   insert the mergedImplicant into a new group for the next QM iteration
        %   insert the mergedImplicant into the implicant list and update which minterms covers

        for i = 1:length(groups) - 1 ; group = groups{i};
    
            if isempty(group) ; continue ; end
            
            groupToCompareWith = groups{i + 1};

            if isempty(groupToCompareWith) ; continue ; end

            for j = 1:length(group) ; implicant = group(j);
                
                for k = 1:length(groupToCompareWith) ; implicantToCompareWith = groupToCompareWith(k);
                    
                    mergedImplicant = utils.mergeStrings(implicant, implicantToCompareWith, '-');
    
                    % if the mergedImplicant is empty continue
                    if mergedImplicant == "" ; continue ; end
                    
                    % if the mergedImplicant is redundant continue
                    if any(strcmp(nextIterationGroups{i}, mergedImplicant)) ; continue ; end
                                        
                    % if mergedImplicant is correct then add it to the implicants
                    implicants = [implicants ; mergedImplicant];
                                        
                    % insert a new line in the coverage matrix
                    A(length(implicants), 1) = 0;
                    
                    % get the two implicants' indexes
                    implicantIndex = utils.findString(implicants, implicant{1});
                    toCompareWithIndex = utils.findString(implicants, implicantToCompareWith{1});
                    
                    % the mergedImplicant covers the OR bitmap of the two generator implicants by definitions
                    A(length(implicants), :) = A(implicantIndex, :) | A(toCompareWithIndex, :);
                    
                    % add the mergedImplicant in the nextIterationGroups
                    nextIterationGroups{i} = [nextIterationGroups{i}, mergedImplicant];

                end
            end    
        end

        groups = nextIterationGroups;

    end

    % remove dontCares costraints from coverage matrix because they don't need to be covered
    for i = flip(dontCares)
        A(:,notZeros == i) = [];
    end

    % remove implicants that covered only dontCares
    for i = length(implicants):-1:1 
        if ~ any(A(i,:) == 1)
            A(i,:) = [];
            implicants(i) = [];
        end
    end
    
    A = A.';
    
end