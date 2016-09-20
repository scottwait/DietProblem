function [ Soln ] = GA( G, P, N, R )
%GA Summary of this function goes here
%   t           -- Generation number
%   G           -- Number of Genes/characteristics making up an individual
%   P           -- Population Size
%   N           -- Number of Generations
%   R           -- Range of initial population gene values
if nargin < 4
    R = 10e3;
end
%% INITIALIZE VARIABLES

wait1 = waitbar(0,'Genetic Algorithm Initiated...');
global  Required;
solution = false;

cont = size(Required,2);
genes = G; clear G;
% % % pm1 = linspace(0.95,0.90,N);
% % % pm2 = linspace(0.75,0.70,N);
% % % pm3 = linspace(0.55,0.50,N);
% % % pm4 = linspace(0.35,0.30,N);
% % % pm = [pm1' pm2' pm3' pm4'];
% % % clear pm1 pm2 pm3 pm4;
%% INITIAL POPULATION

Population = R*rand(P,genes);
% INITIAL FITNESS CALCULATION
for j = 1:P
    [FitCur(j),CostCur(j)] = Fitness(Population(j,:));
end

%% WHILE LOOP
t = 0;
while (t < N)&&(solution ~= true)
    t = t + 1;
    
    % %     % DEBUGGING ANALYSIS
    % %     if generation == 1 % To See Change in Population over time
    % %         Gen1 = Population;
    % %     end
    
    %% HALL OF FAME
    [maxCur, idx] = max(FitCur);
    bestCost = CostCur(idx);
    
    HallOfFame(t,:) = Population(idx,:); %#ok<*AGROW>
    HallOfFame_fit(t) = maxCur;
    HallOfFame_cost(t) = bestCost;
    
    NextGen = [];
    iN = 1;
    while (size(NextGen,1) ~= P) % CREATE A NEW SAME SIZE POPULATION
        %% SELECTION FOR REPRODUCTION
        
        [I1,I2] = Select(Population,'Tournament');
        Parent1 = Population(I1,:);
        Parent2 = Population(I2,:);
        FitP1 = FitCur(I1);
        FitP2 = FitCur(I2);
        %% CROSSOVER
        
        [Child1,Child2] = Crossover(Parent1,Parent2,'SBX');
        % FITNESS FOR MUTAION PURPOSES
        [FitC1,~] = Fitness(Child1);
        [FitC2,~] = Fitness(Child2);
        
        %% MUTATION & FITNESSES
        
        Family = [Parent1; Parent2; Child1; Child2];
        Family(:,end+1) = [FitP1; FitP2; FitC1; FitC2];
        Family = sortrows(Family,genes+1);
        % once sorted according to fitness for mutation purposes we can
        % remove the old fitness values and recalculate
        Family(:,end) = [];
        pm = [0.5 0.3 0.2 0.1];
        for i = 1:4
            Family(i,:) = Mutate(Family(i,:),pm(i)); % MUTATE
            [FitFam(i),CostFam(i)] = Fitness(Family(i,:)); % FITNESS
        end
        
        %% SELECTION OF NEW POPULATION
        
        % %         SELECT THE BEST TWO INDIVIDUALS FROM EACH FAMILY
        [Fit1, iB1] = max(FitFam);
        Cost1 = CostFam(iB1);
        Best1 = Family(iB1,:);
        % %         TRIM
        Family(iB1,:) = [];
        FitFam(iB1) = [];
        CostFam(iB1) = [];
        % %         END TRIM
        [Fit2, iB2] = max(FitFam);
        Cost2 = CostFam(iB2);
        Best2 = Family(iB2,:);
        clear Family;
        % %         ADD TO NEXT GENERATION
        NextGen(iN,:) = Best1;
        FitNext(iN) = Fit1;
        CostNext(iN) = Cost1;
        iN = iN + 1;
        NextGen(iN,:) = Best2;
        FitNext(iN) = Fit2;
        CostNext(iN) = Cost2;
        % %         END ADD TO NEXT GENERATION
        % Ensure that new population has same size as existing one
        if size(NextGen,1) > P
            NextGen(end,:) = [];
        end
        
    end
    Population = NextGen;
    FitCur = FitNext;
    CostCur = CostNext;
    clear NextGen FitNext CostNext;
    % %     WAITBAR
    progress = t/N;
    waitbar(progress,wait1,sprintf('Generation %i of %i',t,N));
end % LAST GENERATION

% % CLOSE WAITBAR
close(wait1);

%% SOLUTION

[~, iKing] = max(HallOfFame_fit);
King = HallOfFame(iKing,:);
% KingCost = HallOfFame_cost(iKing);

%% PLOTTING
Obtained = Nutrition( King );
X = 1:cont;
Y = [Obtained;Required]';
plotRequirements(X,Y);
clear X Y;

plotHallOfFame(1:N,HallOfFame_fit);

plotCost(1:N,HallOfFame_cost);

%% CREATE OUTPUT VARIABLE

Soln = King;
% Cost = KingCost;
end