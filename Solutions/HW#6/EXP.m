function [Boundry] = EXP(Lower, Higher, eta, input)
index = [];
for i = 1:length(input)
    if (Lower <= input(i)) && (input(i) <= Higher)
        index = [index, i];
    end
end

DN = diff(index);
cls = find(DN>eta);
Boundry = [];


if index(1) > eta
    Boundry = index(1);
end

for i = cls
    Boundry = [Boundry, index(i+1)];
    %sprintf('Selected values in IN are %d',IN(i+1))
    %sprintf('Selected values in DN are %d',DN(i))
end
end

