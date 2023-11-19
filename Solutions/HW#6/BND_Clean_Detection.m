function [end_indices,start_indices] = BND_Clean_Detection(unknown_signal)
start_indices = zeros(1, 4);
end_indices = zeros(1,4);

% Initialize a variable to track the current "Vi"
current_Vi = 0;
current_Vj = 0;

if unknown_signal(1) ~= 0
    start_indices(1) = 1;
    current_Vi = 1;
end
    
    
for i = 2:length(unknown_signal)
    if unknown_signal(i) ~= 0 && unknown_signal(i - 1) == 0
        current_Vi = current_Vi + 1;
        start_indices(current_Vi) = i;
    elseif unknown_signal(i) == 0 && unknown_signal(i - 1) ~= 0
        current_Vj = current_Vj + 1;
        end_indices(current_Vj) = i;
    end
end
end

