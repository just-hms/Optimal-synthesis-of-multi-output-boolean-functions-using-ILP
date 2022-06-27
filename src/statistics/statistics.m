addpath(genpath("./../"))

rng('shuffle')

MAX_TEST_NUMBER = 400;
MAX_INPUTS_NUMBER = 14;
TIMEOUT = 420;

if exist('outputsNumber','var') ~= 1 ; outputsNumber = 8 ; end
if exist('startInputsNumber','var') ~= 1 ; startInputsNumber = 1 ; end
if exist('startTest','var') ~= 1 ; startTest = 1 ; end

if startTest > MAX_TEST_NUMBER
    startInputsNumber = startInputsNumber + 1;
    startTest = 1;
end

for inputsNumber = startInputsNumber:MAX_INPUTS_NUMBER

    fprintf(2,'output[%d, %d]\n', outputsNumber, inputsNumber);

    biggest_value = 2^inputsNumber;

    for test = startTest:MAX_TEST_NUMBER 
        
        outputs = cell(outputsNumber, 1); 
        one_out_cost = 0;

        for i = 1:outputsNumber
            
            p = randperm(biggest_value);

            minterms_count = round(biggest_value * rand(1,1));
            
            while minterms_count < 1   
                minterms_count = round(biggest_value * rand(1,1));
            end

            dontcares_count = round(biggest_value * rand(1,1));
            
            while (minterms_count + dontcares_count) > biggest_value   
                dontcares_count = round(biggest_value * rand(1,1));
            end

            p_1 = sort(p(1:minterms_count));
            
            if minterms_count < biggest_value
                p_2 = sort(p(minterms_count + 1: minterms_count + dontcares_count));
            else
                p_2 = [];
            end

            out = {p_1, p_2}; 

            [~, v, timedOut] = oneOutputSynthesis( ...
                out{1}, ...
                out{2}, ...
                InputsNumber = inputsNumber, ...
                Timeout = TIMEOUT ...
            );

            if timedOut ; break ; end

            one_out_cost = one_out_cost + v;

            outputs{i} = out;
        end 

        if timedOut ; fprintf('%d %d timed_out\n', inputsNumber, test) ; continue ; end

        [~, multiple_out_cost, timedOut] = multipleOutputSynthesis( ...
            inputsNumber, ...
            outputs, ...
            Timeout = TIMEOUT ...
        );
        
        if timedOut ; fprintf('%d %d timed_out\n', inputsNumber, test) ; continue ; end

        fprintf( ...
            '%d %d %f %f %f\n', ...
            inputsNumber, ... 
            test, ...
            one_out_cost, ... 
            multiple_out_cost, ... 
            (one_out_cost - multiple_out_cost) / one_out_cost ...
        )

    end

    startTest = 1;
end 
