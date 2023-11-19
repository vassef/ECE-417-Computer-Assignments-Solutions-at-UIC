function [INFO] = EXP_INFO(Input, std)
NUM_EXP = size(Input,1);
INFO = zeros(NUM_EXP * 1000,6);
%Columns= {'EXP NUM' 'Lower-band','Upper-band','Threshold', 'Num Boundries', 'Bounds'};
INFO(:,1) = transpose(repelem(linspace(1,NUM_EXP,NUM_EXP),1000));
INFO(:,2) = transpose(repmat(repelem(linspace(0, 1e-5, 10), 100),1,NUM_EXP));
INFO(:,3) = transpose(repmat(repelem(linspace(std * 2.5 * 1e-3 + 1.5 * 1e-5, std * 2.5 * 1e-2 + 1.5 * 1e-4, 10), 10),1,NUM_EXP * 10));
INFO(:,4) = transpose(repmat(linspace(64,100,10),1,NUM_EXP * 100));

INFO = num2cell(INFO);
for i = 1:NUM_EXP * 1000
    O = EXP(cell2mat(INFO(i,2)),cell2mat(INFO(i,3)),cell2mat(INFO(i,4)), Input(cell2mat(INFO(i,1)),:));
    INFO(i,6) = {O};
    INFO(i,5) = {length(O)};
end
end

