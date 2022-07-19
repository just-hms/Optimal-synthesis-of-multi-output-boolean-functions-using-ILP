
delimiterIn = ' ';

% if this variables are not set, set them to default values
if exist('outputsNumber','var') ~= 1 ; outputsNumber = 8 ; end
if exist('inputsNumber','var') ~= 1 ; inputsNumber = 4 ; end
        
filename = sprintf('out_web/%d-%d.txt', outputsNumber, inputsNumber);
A = importdata(filename,delimiterIn);

filename = sprintf('out_dump/%d-%d.txt', outputsNumber, inputsNumber);
B = importdata(filename,delimiterIn);

if isempty(A) && isempty(B) ; return ; end

A = [A ; B];

savings = sort((A(:,2) - A(:,3)) ./ A(:,2) * 100);

h = histfit(savings);

h(1).FaceColor = [0.4 0.6 0.8];
h(1).FaceAlpha = 0.5;

h(2).Color = [.2 .2 .2];

ax = gca; 
ax.FontSize = 18; 
