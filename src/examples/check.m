addpath(genpath("./../"))

y_1 = {[1,2,3,5] + 1, []};
y_2 = {[1,5,6,7] + 1, []};

[implicants_1, v_1] = oneOutputSynthesis(y_1{1}, y_1{2}, InputsNumber = 3);
[implicants_2, v_2] = oneOutputSynthesis(y_2{1}, y_2{2}, InputsNumber = 3);

if ~ synteshisCheck(implicants_1, y_1{1}, y_1{2})
    disp("ERROR: in the first output synthesis")
    return
end

if ~ synteshisCheck(implicants_2, y_2{1}, y_2{2})
    disp("ERROR: in the second output synthesis")
    return
end

displayImplicants({implicants_1})
displayImplicants({implicants_2})

y = {y_1, y_2};

[implicants, v] = multipleOutputSynthesis(3, y);

for j =1:length(implicants)
    y_j = y{j};
    if ~ synteshisCheck(implicants{j}, y_j{1}, y_j{2})
        disp("ERROR: multiple output synthesis")
        return
    end
end

displayImplicants(implicants)

savings = round((v_1 + v_2 - v) / (v_1 + v_2) * 100, 2);
fprintf('The gateInput cost is improoved by %.2f%% ', savings)
