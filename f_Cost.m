function [ F2 ] = f_Cost( Cost, a )
%F_COST calculates the fitness pertaining to the cost of the food items for
%the DietProblem assignment, using an exponential relationship.
%   NOTE that the exponential function is an element of [1,Inf) for [0,Inf)

    F2 = exp(-a*Cost);

end

