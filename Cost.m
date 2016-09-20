function [ C ] = Cost( individual )
%COST is calculated by dividing the weights of each item by 
% their one dollar equivalent weight.
% 
global CalData;
C = 0;
for j = 1:size(individual,2)
    C =  C + individual(j)/CalData(j,1);
end

end

