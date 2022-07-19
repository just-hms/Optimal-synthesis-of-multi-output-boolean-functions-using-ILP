addpath(genpath('./../src/'))

diary verbose.out

y_1 = {[1,2,3,5] + 1, []};
y_2 = {[1,5,6,7] + 1, []};

[implicants_1, v_1] = oneOutputSynthesis(y_1{1},y_1{2}, Verbose=true);
displayImplicants({implicants_1})

[implicants_2, v_2] = oneOutputSynthesis(y_2{1}, y_2{2}, Verbose=true);
displayImplicants({implicants_2})

[implicants, v] = multipleOutputSynthesis(3, {y_1, y_2}, Verbose=true);
displayImplicants(implicants)

diary off