function dispDietProblem( Soln, Algorithm )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

%% INITIALISE VARIABLES

global CalData Contents Items Required;

cont = size(Required,2);
genes = size(Soln,2);
SolnCost = Cost(Soln);
SolnNutr = Nutrition(Soln);

sm = '---';
se = '===';
for i = 1:5
    sm = strcat(sm,sm);
    se = strcat(se,se);
end

%% DISPLAY
fprintf('\n');
disp(se);
fprintf('USING %s \n',Algorithm); 
disp(se);
disp('The Optimal Solution Found is...');
disp(sm);
% fprintf('From Generation%5i: \n',iKing);
% disp(sm);
fprintf('%20s \t%15s \t%15s \n','Food:','Weight/$:','Weight:');
for k = 1:genes
    item = char(Items(k));
    equ_w = char(CalData(k,1));
    fprintf('%20s \t%15.1f \t%15.1f \n', item, equ_w, Soln(k));
end
disp(sm);
fprintf('%20s \t%15s \t%15s \t%10s \t%20s \n','Nutrient:','Required:',+...
    'Obtained:','Met:','Excess/Deficit:');
for j = 1:cont
    excess = 100*(SolnNutr(j) - Required(j))/Required(j);
    if (excess >= 0)
        met = 'Yes';
    else met = 'No';
    end
    fprintf('%20s \t%15.1f \t%15.1f \t%10s \t%18.1f %% \n',+...
        char(Contents(j+1)),Required(j),SolnNutr(j),met,excess);
end
disp(sm);
fprintf('Groceries Cost is %6.2f $ \n',SolnCost);
disp(se);
fprintf('\n');

end

