classdef utils
   
    methods (Static)
        
        function res = mergeSorted(array_1,array_2)
            
            arguments
                array_1 (1,:) double ...
                    {mustBeInteger,mustBePositive,utils.mustBeAscending} 
                array_2 (1,:) double ...
                    {mustBeInteger,mustBePositive,utils.mustBeAscending} 
            end

            % returns
            %   a sorted array
            
            i_1 = 1;
            i_2 = 1;
            total_length = length(array_1) + length(array_2);
            res = zeros(1,total_length);
            
            for i = 1: total_length
                
                if i_1 > length(array_1)
                    res(i) = array_2(i_2);
                    i_2 = i_2 + 1;
                    continue;
                end
                
                if i_2 > length(array_2)
                    res(i) = array_1(i_1);
                    i_1 = i_1 + 1;
                    continue;
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

        function res = mergeStrings(a,b,substitute_char)

            arguments
                a string
                b string
                substitute_char char
            end

            a_chars = a{1}; 
            b_chars = b{1}; 
            res = a_chars;
            
            if length(a_chars) ~= length(b_chars)
                res = "";
            end

            count = 0;
        
            for i = 1:length(a_chars)
        
                a_char = a_chars(i);
                b_char = b_chars(i);
                
                % if the chars differ
                if a_char ~= b_char

                    % if one of the chars is the substitue_char  
                    if a_char == substitute_char ...
                    || b_char == substitute_char
                        res = "";
                        return;
                    end

                    res(i) = substitute_char;
                    count = count + 1;
                end 
        
                if count > 1
                    res = "";
                    return;
                end
            end

            res = string(res);

        end

        function idx = findString(string_array,string)

            idx = -1;
        
            for i = 1:length(string_array)
                if strcmp(string_array(i,:),string)
                    idx = i;
                    return;
                end
            end
            
        end

        function count = countMatches(char_array,pat)

            arguments
                char_array string
                pat pattern
            end

            % returns
            %    how many times the pattern is found

            count = length(strfind(char_array,pat));
        end


        function res = areAllCellsEmpty(cell_array)
        
            res = 1;
            for i = 1:length(cell_array)
                if ~ isempty(cell_array{i})
                    res = 0;
                    return;
                end
            end
        end


        function mustBeAscending(a)

            if utils.isInAscendingOrder(a) ; return ; end

            eidType = 'mustBeAscending:notInAscendingOrder';
            msgType = 'Input must be in ascending order';
            throwAsCaller(MException(eidType,msgType))
        end

        function res = isInAscendingOrder(a)

            res = 1;
            last = 0;

            for i = a 

                if i <= last
                    res = 0;
                    return;
                end
                last = i;
            end 

        end 

        function res = minimumBits(numbers)
            res = ceil(log2(max(numbers)));
        end

        function [x,v,timedOut] = intlinprogWrap(C,A,b,variablesNumber,verbose,timeout)
            
            % calls intrlinprog 
            %   setting intcon,lb,ub with the specified variablesNumber
            %   sets on or off the display using the verbose parameter

            intcon = 1:variablesNumber;
            lb = zeros(variablesNumber,1);
            ub = ones(variablesNumber,1);

            if timeout <= 0
                timeout = 7200;
            end

            if verbose
                intlinprogOptions = ...
                    optimoptions('intlinprog',MaxTime = timeout);
            else
                intlinprogOptions = optimoptions( ...
                    'intlinprog',...
                    Display = 'off',...
                    MaxTime = timeout ...
                );
            end

            [x,v,exitflag] = ...
                intlinprog(C,intcon,A,b,[],[],lb,ub,intlinprogOptions);
            
            timedOut = exitflag == 2;

            if exitflag ~= 1
                fprintf(2, 'Intlinprog finished with exit flag %d\n', exitflag)
            end
        end

    end
end