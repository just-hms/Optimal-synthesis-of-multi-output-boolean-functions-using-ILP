% https://github.com/int-main/Quine-McCluskey
% implicants = oneOutputSynthesis(4, [5, 9, 11, 12, 13, 16], [10 15])                                % v
% implicants = oneOutputSynthesis(4, [5, 9, 10, 11, 12, 13, 15, 16], [])                             % v

% https://personal.utdallas.edu/~dodge/EE2310/lec5.pdf  
% implicants = oneOutputSynthesis(4, [5, 6, 13, 14], [])                                             % v
% implicants = oneOutputSynthesis(4, [2, 6, 8, 10, 14, 16], [])                                      % v
% implicants = oneOutputSynthesis(4, [1,2,3,5,7,11,13] + 1, [])                                      % v

% https://www.gatevidyalay.com/k-maps-karnaugh-maps-solved-examples/    
% implicants = oneOutputSynthesis(4, [0, 2, 8, 10, 14] + 1, [5, 15] + 1)                             % v but gives different solution

% mine
% implicants = oneOutputSynthesis(4, [0,1] + 1, [0] + 1)                                             % v
% implicants = oneOutputSynthesis(16, [0, 2, 8, 10, 14, 25, 29, 39, 132, 230 ] + 1, [5, 15] + 1) 

% testing
% implicants = oneOutputSynthesis(4, [0, 2, 8, 10, 14] + 1, [5, 15] + 1) 

% ⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯

% equal functions should work fine
% fun1 = { [4, 5, 12, 13 ] ,  []};
% fun2 = { [4, 5, 12, 13 ] ,  []};
% multipleOutputSynthesis(4, {fun1 ,  fun2})                                            % v

% on 15'th minterm, in the first fun there's a 1x2 implicant
% it should be avoided because it's already covered by the minterm in the second
% function

% TODO error 5x1 not 6x1 (seem to work)
fun1 = { [0, 2, 8, 10, 14] + 1, [5, 15] + 1}; 
fun2 = { [14] + 1, []}; 
implicants = multipleOutputSynthesis(4, {fun1 ,  fun2})                                 % v                                    

