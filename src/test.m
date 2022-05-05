% https://github.com/int-main/Quine-McCluskey
    % implicants = oneOutputSynthesis([5, 9, 11, 12, 13, 16], [10 15], Verbose = true)
    % implicants = oneOutputSynthesis([5, 9, 10, 11, 12, 13, 15, 16], [])

% https://personal.utdallas.edu/~dodge/EE2310/lec5.pdf  
    % implicants = oneOutputSynthesis([5, 6, 13, 14], [])
    % implicants = oneOutputSynthesis([2, 6, 8, 10, 14, 16], [])
    % implicants = oneOutputSynthesis([1,2,3,5,7,11,13] + 1, [])

% https://www.gatevidyalay.com/k-maps-karnaugh-maps-solved-examples/    
    % implicants = oneOutputSynthesis([0, 2, 8, 10, 14] + 1, [5, 15] + 1)

% stress test

    % diary tmp.txt

    % p = randperm(2000);
    % p1 = sort(p(1:500));
    % p2 = sort(p(600:800));

    % implicants = oneOutputSynthesis(p1, p2, Verbose = false)
    
    % diary off


% ⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯

% equal functions
    fun1 = { [4, 5, 12, 13 ] ,  []};
    fun2 = { [4, 5, 12, 13 ] ,  []};
    [implicants, v] = multipleOutputSynthesis(4, {fun1 ,  fun2}, Verbose = true)
    implicants{1}
    implicants{2}

% on 15'th minterm, in the first fun there's a 1x2 implicant
% it should be avoided because it's already covered by the minterm in the second
% function
    % fun1 = { [0, 2, 8, 10, 14] + 1, [5, 15] + 1}; 
    % fun2 = { [14] + 1, []}; 
    % implicants = multipleOutputSynthesis(4, {fun1 ,  fun2}, Verbose = true);                                    
    % implicants{1}
    % implicants{2}


% comparison test

    % fun1 = { [0, 2, 8, 10, 14] + 1, [5, 15] + 1}; 
    % fun2 = { [14] + 1, []}; 

    % [~, v1] = oneOutputSynthesis(fun1{1},fun1{2});
    % [~, v2] = oneOutputSynthesis(fun2{1},fun2{2});

    % [~, v_1_2] = multipleOutputSynthesis(4, {fun1 ,  fun2});                                    

    % fprintf('the one output synthesis cost is %d, the multiple output synthesis cost is %d', v1 + v2, v_1_2)
