% https://github.com/int-main/Quine-McCluskey
% oneOutputSynthesis(4, [5, 9, 11, 12, 13, 16], [10 15]);                               % v
% oneOutputSynthesis(4, [5, 9, 10, 11, 12, 13, 15, 16], []);                            % v

% https://personal.utdallas.edu/~dodge/EE2310/lec5.pdf  
% oneOutputSynthesis(4, [5, 6, 13, 14], []);                                            % v
% oneOutputSynthesis(4, [2, 6, 8, 10, 14, 16], []);                                     % v
% oneOutputSynthesis(4, [1,2,3,5,7,11,13] + 1, []);                                     % v

% https://www.gatevidyalay.com/k-maps-karnaugh-maps-solved-examples/    
% oneOutputSynthesis(4, [0, 2, 8, 10, 14] + 1, [5, 15] + 1);                            % v but gives different solution

% mine
% oneOutputSynthesis(4, [0,1] + 1, [0] + 1);                                            % v
% oneOutputSynthesis(16, [0, 2, 8, 10, 14, 25, 29, 39, 132, 230 ] + 1, [5, 15] + 1);

% tesing
oneOutputSynthesis(4, [0, 2, 8, 10, 14] + 1, [5, 15] + 1);

% ⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯

% fun1 = { [4, 5, 12, 13 ] ,  []};
% fun2 = { [0, 2, 8, 10, 14] + 1 , [5, 15] + 1};

% multipleOutputSynthesis(4, {fun1 ,  fun2});
