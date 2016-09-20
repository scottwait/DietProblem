function [ Xman ] = Mutate( individual, p )
%MUTATE Summary of this function goes here
%   Detailed explanation goes here
%
% [MUTANT] = MUTATE(INDIVIDUAL)
%   Uses the Headless Chicken method to guarantee mutation.
%   Probability = 1
%
% [MUTANT] = MUTATE(INDIVIDUAL,PROBABILITY)
%   Uses a probability of gene mutation to create a gene mask which then
%   specifies which genes mutate. 
Type = '';
if nargin == 1
    Type = 'HeadlessChicken';
else
    if nargin == 2
        Type = 'Delta';
    end
end

genes = size(individual,2);

switch Type
    case 'Delta'
        GeneMask = rand(1,genes)<p;
        Size = -1 + 2.5*rand(1,genes);
        for j = 1:genes
            max(j) = floor(individual(j));%#ok
        end
        change = GeneMask.*Size.*max;
        Xman = individual + change;
    case 'HeadlessChicken'
        thing = 100*rand(1,genes);
        [X1,X2] = Crossover(thing,individual,'SBX');
        [X1p,~] = Fitness(X1);
        [X2p,~] = Fitness(X2);
        if X1p >= X2p
            Xman = X1;
        else
            Xman = X2;
        end
    otherwise
        errorstring = sprintf('The Mutation Technique "%s" Does Not Exist',Type);
        dlgname = sprintf('\bInvalid Mutation');
        errordlg(errorstring,dlgname,'modal');
end
end

