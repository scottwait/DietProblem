function [ Obtained ] = Nutrition( individual )
%NUTRITION Calculates the nutritional information of the combination of
%food items purchased in the DietProblem
%   ratio   - purchased weight / the 1$ equivalent weight of each food item
%   cont    - number of nutritional contents to be assessed
%   Obtained- Units of each nutrient actually obtained

%% INITIALISE VARIABLES

global CalData Required;
cont = size(Required,2);
genes = size(individual,2);

%% CODE

Obtained = zeros(1,cont);
ratio = zeros(1,cont);
for i = 1:genes
    ratio(i) = individual(i)/CalData(i,1);
    for k = 1:cont
        Obtained(k) = Obtained(k) + ratio(i)*CalData(i,k+1);
    end
end

end

