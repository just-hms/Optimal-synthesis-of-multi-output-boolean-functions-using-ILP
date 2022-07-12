addpath(genpath("./../"))

y_1 = {[1,2,3,5] + 1, []};
y_2 = {[1,5,6,7] + 1, []};

[implicants_1, v_1] = oneOutputSynthesis(y_1{1}, y_1{2}, InputsNumber = 3);
[implicants_2, v_2] = oneOutputSynthesis(y_2{1}, y_2{2}, InputsNumber = 3);
displayImplicants({implicants_1})
displayImplicants({implicants_2})

[implicants, v] = multipleOutputSynthesis(3, {y_1, y_2});
displayImplicants(implicants)

savings = round((v_1 + v_2 - v) / (v_1 + v_2) * 100, 2);
fprintf('The gateInput cost is improoved by %.2f%% ', savings)
