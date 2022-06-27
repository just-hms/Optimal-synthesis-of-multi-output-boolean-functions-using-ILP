addpath(genpath("./../"))

y_1 = {[2,3,7,12,15] + 1, [4,5,13] + 1};
y_2 = {[4,7,9,11,15] + 1, [6,12,14] + 1};

[implicants_1, v_1] = oneOutputSynthesis(y_1{1}, y_1{2}, InputsNumber = 4);
[implicants_2, v_2] = oneOutputSynthesis(y_2{1}, y_2{2}, InputsNumber = 4);
displayImplicants({implicants_1})
displayImplicants({implicants_2})

[implicants, v] = multipleOutputSynthesis(4, {y_1, y_2});
displayImplicants(implicants)

savings = round((v_1 + v_2 - v) / (v_1 + v_2) * 100, 2);
fprintf('The diodes cost is improoved by %.2f%% ', savings)
