
delimiterIn = ' ';
maxInputsNumber = 6;
maxOutputsNumber = 16;

worst_error = 0;
worst_time_error = 0;
avgs = zeros(maxInputsNumber,maxOutputsNumber);
std_devs = zeros(maxInputsNumber,maxOutputsNumber);
avg_times = - ones(maxInputsNumber,maxOutputsNumber);

for o = 1:maxOutputsNumber
    for i = 1:maxInputsNumber
        
        filename = sprintf('out_web/%d-%d.log', o, i);
        A = importdata(filename,delimiterIn);
        filename = sprintf('out_dump/%d-%d.log', o, i);
        B = importdata(filename,delimiterIn);

        if isempty(A) && isempty(B) ; continue ; end
        
        A = [A ; B];

        savings = (A(:,2) - A(:,3)) ./ A(:,2) * 100;
        times = A(:, 4);
        
        % https://cdm.unimore.it/home/matematica/vernia.cecilia/distribuzioni.pdf
        % 1.282 1.645 1.960 2.054 2.326 2.576
        
        std_dev = sqrt(var(savings));
        error = std_dev / sqrt(length(savings)) * 2.576;
        
        
        avgs(i,o) = mean(savings);
        std_devs(i,o) = error; 
        
        avg_times(i,o) = mean(times);
        
        time_error = sqrt(var(times)) / sqrt(length(times)) * 1.282;
        
        if isnan(error) ; continue ; end
        
        if error > worst_error
            worst_error = error;
        end

        if error > worst_error
            worst_error = error;
        end

        if time_error > worst_time_error
            worst_time_error = time_error;
        end

    end
end

input_legends = cell(1,maxInputsNumber);

input_legends{i} = '1 entrata';
input_legends{i + 1} = '';

for i = 2:2:maxInputsNumber * 2
    input_legends{i} = sprintf('{%d} entrate', round(i/2));
    input_legends{i + 1} = '';
end

hold on

for i = 1:maxInputsNumber
    
    p = plot(avgs(i,:));

    p(1).LineWidth = 2;

    c = get(p,'Color');

    x = 1:length(avgs(i,:));
    curve1 = avgs(i,:) + std_devs(i,:);
    curve2 = avgs(i,:) - std_devs(i,:);
    x2 = [x, fliplr(x)];
    inBetween = [curve1, fliplr(curve2)];
    h = fill(x2, inBetween, c, 'LineStyle','none');
    h.FaceAlpha = 0.2;

end

legend(input_legends{:});
xlabel('uscite'), ylabel('Risparmio [%]')
title('Risparmi in base al numero di output', 'FontSize', 14)
