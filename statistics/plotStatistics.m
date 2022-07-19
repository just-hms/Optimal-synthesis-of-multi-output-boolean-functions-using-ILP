
delimiterIn = ' ';
maxInputsNumber = 6;
maxOutputsNumber = 16;

avgs = zeros(maxInputsNumber,maxOutputsNumber);
std_devs = zeros(maxInputsNumber,maxOutputsNumber);
errors = zeros(maxInputsNumber,maxOutputsNumber);
worst_error = 0;
best_save = 0;

% ALPHA = 0.95;
QUANTILE = 1.96;

for o = 1:maxOutputsNumber
    for i = 1:maxInputsNumber
        
        filename = sprintf('out_web/%d-%d.txt', o, i);
        A = importdata(filename,delimiterIn);
        filename = sprintf('out_dump/%d-%d.txt', o, i);
        B = importdata(filename,delimiterIn);

        if isempty(A) && isempty(B) ; continue ; end
        
        A = [A ; B];

        savings = (A(:,2) - A(:,3)) ./ A(:,2) * 100;
        
        
        avgs(i,o) = mean(savings);
        
        if mean(savings) > best_save
            best_save = mean(savings); 
        end 
        
        std_dev = sqrt(var(savings));
        error = std_dev / sqrt(length(savings)) * QUANTILE;

        if isnan(std_dev) ; continue ; end

        std_devs(i,o) = std_dev; 
        errors(i,o) = error;

        if error > worst_error ; worst_error = error; end
        
    end
end

input_legends = cell(1, maxInputsNumber);

for i = 1:2:maxInputsNumber * 2
    input_legends{i} = sprintf('%d', round(i/2));
    input_legends{i + 1} = '';
end

hold on

gaps = errors;

for i = 1:maxInputsNumber
    
    p = plot(avgs(i,:));

    p(1).LineWidth = 2;

    c = get(p,'Color');

    x = 1:length(avgs(i,:));
    curve1 = avgs(i,:) + gaps(i,:);
    curve2 = avgs(i,:) - gaps(i,:);
    x2 = [x, fliplr(x)];
    inBetween = [curve1, fliplr(curve2)];
    h = fill(x2, inBetween, c, 'LineStyle','none');
    h.FaceAlpha = 0.2;

end

grid on

ax = gca; 
ax.FontSize = 18; 

lgd = legend(input_legends{:}, 'Location','northwest', 'FontSize', 18);
title(lgd,' Entrate ', 'FontSize', 22)


xlabel({'Uscite', '',}, 'FontSize', 18);
ylabel({'Risparmio [%]', ''}, 'FontSize', 18);

% title({'Risparmi in base al numero di output', ''}, 'FontSize', 22)

fprintf('The worst error is %f\n', worst_error);
fprintf('The best median saving is %f\n', best_save);
