function [ F, C ] = Fitness( individual )
%Fitness Summary of this function goes here
%   NOTE: The average annual minimum nutritional intake for an adult male
%
% Item              Amount  Unit
% Calories          1095    Kilo Calories
% Protein           25550   grams
% Calcium           292     grams
% Iron              4380    mg
% Vitamin A         1825000 IU
% Thiamine VB1      657     mg
% Riboflavin VB2    985.5   mg
% Niacin            6570    mg
% Ascorbic Acid VC  27375   mg

%% INITIALISE VARIABLES

global Required;

%% CODE
Obtained = Nutrition( individual );
C = Cost( individual );

F1 = f_Nutrition( Obtained, Required );
F2 = f_Cost( C, 0.010 );

%% OUTPUT VARIABLE
F = F1*F2;
end % End Fitness