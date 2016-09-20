function [ Soln ] = DE_rtb( G, P, N, R )
%DE_RTB Summary of this function goes here
%   t           -- Generation number
%   G           -- Number of Genes/characteristics making up an individual
%   P           -- Population Size
%   N           -- Number of Generations
%   R           -- Range of initial population gene values
%   B           -- Scaling Factor
%   HOF         -- Hall Of Fame
%   HOFf        -- Fitness values of the hall of fame chromosomes
%   HOFc        -- Cost values of the hall of fame chromosomes
if nargin < 4
    R = 10e3;
end

%% INITIALIZE VARIABLES

wait3 = waitbar(0,'Differential Evolution Algorithm Initiated...');
global  Required;
solution = false;

cont = size(Required,2);
genes = G; clear G;

y = linspace(0,1,N);
pr = linspace(1,0.7,N);% pr = linspace(0.7,0.3,N);
B = linspace(0.8,0.3,N);
X1p = zeros(1,genes);

%% INITIAL POPULATION

Population = R*rand(P,genes);%
Fit = zeros(P,1);
C = zeros(P,1);

HOF = zeros(N,genes);
HOFf = zeros(N,1);
HOFc = zeros(N,1);


%% CODE
t = 0;
while (t < N)&&(solution ~= true)
    t = t + 1;
    % % % % %   HALL OF FAME
    [fFame, iFame] = max(Fit);
    
    HOF(t,:) = Population(iFame,:);
    HOFf(t) = fFame;
    HOFc(t) = C(iFame);
    
    XBest = HOF(t,:);
    
    % % % % %     DYNAMIC PARAMETERS
    % SEE THE USE OF THE LINSPACE FUNCTION
    
    % % % % %     CREATE NEW POPULATION
    for k = 1:P
        Xi = Population(k,:);
        
        % % % % %   EVALUATE FITNESS CALCULATION
        [Fit(k),C(k)] = Fitness(Xi);
        
        % % % % %   CREATE TRIAL VECTOR
        iX1 = 0; iX2 = 0; iX3 = 0;
        while ( k ~= iX1 ) && ( k ~= iX2 ) && ( k ~= iX3 )
            iXs = randperm(P,3);
            iX1 = iXs(1);
            iX2 = iXs(2);
            iX3 = iXs(3);
        end
        X1 = Population(iX1,:);
        X2 = Population(iX2,:);
        X3 = Population(iX3,:);
        
        u = abs( y(t)*XBest + (1-y(t))*X1 + B(t)*(X2-X3) );
        
        % % % % %   CROSSOVER - BINOMIAL
        mask = rand(1,genes)<pr(t);
        for x = 1:genes
%             if ( u(x) < 0 ); u(x) = rand()*X1(x); end
            if mask(x) == 1
                X1p(x) = u(x);
            else
                X1p(x) = Xi(x);
            end
        end
        
        % % % % %   INSERT INTO NEW POPULATION
        [fX1p,cX1p] = Fitness( X1p );
        if fX1p > Fit(k)
            Population(k,:) = X1p;
            C(k) = cX1p;
            Fit(k) = fX1p;
        end
        
    end
    
    % % % % %   WAITBAR
    progress = t/N;
    waitbar(progress,wait3,sprintf('Generation %i of %i',t,N));
    
    
end
% % % % % CLOSE WAITBAR
close(wait3);

[~,iSoln] = max(HOFf);
S = HOF(iSoln,:);

%% PLOTTING
Obtained = Nutrition( S );
X = 1:cont;
Y = [Obtained;Required]';
plotRequirements(X,Y);
clear X Y;

plotHallOfFame(1:N,HOFf);

plotCost(1:N,HOFc);

%% CREATE OUTPUT VARIABLE
Soln = S;

end

