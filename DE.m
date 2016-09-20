function [ Soln ] = DE( G, P, N, R )
%DE Summary of this function goes here
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

wait2 = waitbar(0,'Differential Evolution Algorithm Initiated...');
global  Required;
solution = false;

cont = size(Required,2);
genes = G; clear G;

ps1 = 0.3;
B = linspace(0.8,0.3,N);
pr = linspace(1,0.7,N);
X1p = zeros(1,genes);
ns1 = 0; ns2 = 0;
nf1 = 0; nf2 = 0;
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
    [maxCur, idx] = max(Fit);
    bestCost = C(idx);
    
    HOF(t,:) = Population(idx,:);
    HOFf(t) = maxCur;
    HOFc(t) = bestCost;
    
    XBest = HOF(t,:);
    
    % % % % %     SELF ADAPTIVE PARAMETERS
       
    if (t > 1)
        % % P(RAND/1/BIN) RATHER THAN P(CUR-TO-BEST/2/BIN)
        num = ns1*(ns2+nf2);
        den = ns2*(ns1+nf1)+ns1*(ns2+nf2);
        ps1 = num/den;
        clear num den;
    end
    
    % % % % %     CREATE NEW POPULATION
    for k = 1:P
        Xi = Population(k,:);
        
        % % % % %   EVALUATE FITNESS CALCULATION
        [Fit(k),C(k)] = Fitness(Xi);
        
        % % % % %   CREATE TRIAL VECTOR
        method = rand() < ps1;
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
        
        if method == 1
            % do DE/rand/1/bin
            u = abs( X1 + B(t)*(X2-X3) );
            mut = 'rand/1/bin';
        else
            % do DE/cur-to-best/2/bin
            u = abs( Xi + B(t)*(XBest-Xi) + B(t)*(X1-X2) );
            mut = 'cur-to-best/2/bin';
        end
        
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
            switch mut
                case 'rand/1/bin'
                    ns1 = ns1 + 1;
                case 'cur-to-best/2/bin'
                    ns2 = ns2 + 1;
                otherwise
                    errorstring = 'HOW DID THIS EVEN HAPPEN?';
                    dlgname = sprintf('\bANDIASE (^.^")');
                    errordlg(errorstring,dlgname,'modal');
            end
        else
            switch mut
                case 'rand/1/bin'
                    nf1 = nf1 + 1;
                case 'cur-to-best/2/bin'
                    nf2 = nf2 + 1;
                otherwise
                    errorstring = 'HOW DID THIS EVEN HAPPEN AGAIN...?';
                    dlgname = sprintf('\bANDIASE (^.^")');
                    errordlg(errorstring,dlgname,'modal');
            end
        end
        
    end
    
    % % % % %   WAITBAR
    progress = t/N;
    waitbar(progress,wait2,sprintf('Generation %i of %i',t,N));
    
    
end
% % % % % CLOSE WAITBAR
close(wait2);

[~,iSoln] = max(HOFf);
S = HOF(iSoln,:);

%% PLOTTING
Obtained = Nutrition( S );
Xi = 1:cont;
Y = [Obtained;Required]';
plotRequirements(Xi,Y);
clear X Y;

plotHallOfFame(1:N,HOFf);

plotCost(1:N,HOFc);

%% CREATE OUTPUT VARIABLE
Soln = S;

end

