function [mostFrequentRow, mostFrequentRowIndex] = Decide_BND(MAT)
[m, n] = size(MAT); % m: number of rows, n: number of columns

mostFrequentRow = zeros(1, n); % Initialize the row with zeros
maxFrequency = zeros(1, n); % Initialize the max frequency counts

for col = 1:n
    [uniqueValues, ~, frequency] = unique(MAT(:, col));
    counts = accumarray(frequency, 1);

    [maxCount, maxIndex] = max(counts);

    mostFrequentRow(col) = uniqueValues(maxIndex);
    maxFrequency(col) = maxCount;
end

% Display the most frequent row and its index
mostFrequentRowIndex = find(ismember(MAT, mostFrequentRow, 'rows'));
end

