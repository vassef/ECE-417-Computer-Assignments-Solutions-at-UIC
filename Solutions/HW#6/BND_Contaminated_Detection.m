function [EST_BND] = BND_Contaminated_Detection(unknown_signal, mu, std, WE)

Input = [];
filename = 'Experiment_result.xlsx';

for i = 1:20
    Noise = mu + std * randn(length(unknown_signal),1);
    New = unknown_signal + Noise;
    Input = [Input;transpose(diff(New.^2))];
end
   

INFO = EXP_INFO(Input, std);
T = cell2table(INFO,...
'VariableNames',{'Exp_Number' 'Lower','Upper','Threshold','N_Boundries', 'Bounds'});
filteredTable = T(T.N_Boundries == 4, :);
sortedTable = sortrows(filteredTable, {'Lower','Upper','Threshold'});
if WE
    writetable(sortedTable,filename,'Sheet','4Bounds')
end

NEW_TB = sortedTable(:,{'Lower','Upper','Threshold','N_Boundries'});
[~,indexToUniqueRows,indexBackFromUnique] = unique(NEW_TB);
% Get unique values and their counts while preserving order
[uniqueValues, ~, idx] = unique(indexBackFromUnique, 'stable');
counts = accumarray(idx, 1);
% Create a table with unique values and their counts
uniqueTable = table(uniqueValues, counts, 'VariableNames', {'Value', 'Count'});
sortedUniqueTable = sortrows(uniqueTable, 'Count', 'descend');
% idx2 -> The true index of unique entries in sortedUniqueTable
[~, idx2, ~]= unique(sortedUniqueTable{:,{'Count'}},'stable');
if length(idx2) > 1
    MAT = zeros(length(idx2) - 1,4);
    for i = 1:length(idx2) - 1
        index_range_0 = idx2(i):idx2(i+1)-1;
        index_range_1 = sortedUniqueTable(index_range_0,:).Value;
        idx_range = indexToUniqueRows(index_range_1);
        BND = cell2mat(sortedTable(idx_range,:).Bounds);
        %MAT = [MAT;BND]
        [mostFrequentRow, ~] = Decide_BND(BND);
        MAT(i,:) = mostFrequentRow;
    end
else
    MAT = cell2mat(sortedTable(1,:).Bounds);
end
MAT
% It's time to estimate the best boundries!    
EST_BND = zeros(1,4);
k_values = 1:size(MAT,1);
for m = 1:4
    data = MAT(:,m);
    % Define a range of potential values for k
    % Initialize variables to store clustering results and quality measures
    silhouette_values = zeros(numel(k_values), length(data));

    % Perform k-means clustering for different values of k
    for i = 1:numel(k_values)
        k = k_values(i);
        [cluster_indices, ~] = kmeans(data, k, 'Distance','sqeuclidean');

        % Calculate silhouette score
        silhouette_values(i,:) = silhouette(data, cluster_indices)';
    end

    % Find the best k based on the SSE or silhouette score
    if all(all(isnan(silhouette_values)))
        best_k_silhouette = 1;
    else
        best_k_silhouette = k_values(find(silhouette_values == max(silhouette_values), 1));
    end

    %fprintf('Best k based on Silhouette Score: %d\n', best_k_silhouette);
    [cluster_indices, centroids] = kmeans(data, best_k_silhouette);
    CLL = num2cell(zeros(best_k_silhouette,4));
    for i = 1:best_k_silhouette
        index_per_cluster = find(cluster_indices == i);
        CLL(i,1) = {i};
        CLL(i,2) = {length(index_per_cluster)};
        CLL(i,3) = {data(index_per_cluster)};
        CLL(i,4) = {round(centroids(i))};
    end
    TT = cell2table(CLL,'VariableNames',{'Clust_Num' 'L_Data' 'Data' 'Centroid'});
    TT_sorted = sortrows(TT,{'L_Data','Centroid'},'descend');
%     if size(TT_sorted(TT_sorted.L_Data == TT_sorted.L_Data(1),:),1) > 1
%         display(TT_sorted)
%     end
    EST_BND(m) = TT_sorted.Centroid(1);
end
end

