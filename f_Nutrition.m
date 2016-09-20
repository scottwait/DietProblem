function [ F1 ] = f_Nutrition( Obtained, Required )
%F_NUTRITION Calculates the equivalent fitness of a particular individual on
% a scale of [0,1] based off of the individuals meeting of each nutritional
% requirement in the DietProblem. 
%   Detailed explanation goes here

%% INITIALISE VARIABLES
F1 = 1;
% % sum = 0;
requirements = size(Required,2);
%% CODE

for ii = 1:requirements
    x1 = Required(ii);
    x2 = 2*x1;
    x = Obtained(ii);
    if x < x1
        f1(ii) = (0.1/x1)*x; %#ok<*AGROW>
    else
        if ( x >= x1 ) && ( x <= x2 )
            y1 = 1.00; y2 = 1.0;
            dy = (y2 - y1);
            dx = (x2 - x1);
            c = y1 - (dy/dx)*x1;
            f1(ii) = (dy/dx)*x + c;
        else
            f1(ii) = 1.0;
        end
    end
%     sum = sum + f1(ii);
F1 = F1*f1(ii);
end
% F1 = sum/requirements;
end

