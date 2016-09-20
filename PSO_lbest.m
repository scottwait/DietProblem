function [ Soln ] = PSO_lbest( G, P, N, R )
%PSO Summary of this function goes here
%   t           -- Generation number
%   G           -- Number of Genes/characteristics making up an individual
%   P           -- Population Size
%   N           -- Number of Generations
%   R           -- Range of initial population gene values
if nargin < 4
    R = 10e3;
end
%% INITIALIZE VARIABLES

waitPSO = waitbar(0,'Swarm Released...');
global  Required;
% solution = false;

cont = size(Required,2);
genes = G; clear G;

c1m = 0.5;
c2m = 0.5;
c1M = 2.5;
c2M = 2.5;
c1 = linspace(c1M,c1m,N);% c1 = linspace(0.1,0.05,N);
c2 = linspace(c2m,c2M,N);% c2 = linspace(0.1,0.05,N);

%% INITIAL POPULATION

X = R*rand(P,genes);
V = zeros(P,genes);
Fx = zeros(P,1);
Cx = zeros(P,1);
Y = zeros(P,genes);
Fy = zeros(P,1);
Cy = zeros(P,1);
NB = zeros(P,genes);    % Neghbourhood best individual
NBf = zeros(P,1);       % Neghbourhood best fitness
NBc = zeros(P,1);
B = zeros(N,genes);     % Global Best
Bf = zeros(N,1);
Bc = zeros(N,1);

for t = 1:N
    for i = 1:P
        [Fx(i),Cx(i)] = Fitness(X(i,:));
        % % % SET PERSONAL BEST POSITIONS
        if Fx(i) > Fy(i)
            Y(i,:) = X(i,:);
            Fy(i) = Fx(i);
            Cy(i) = Cx(i);
        end
        % % % SET NEIGHBOURHOOD BEST POSITION
        h = i - 1; % LEFT ADJACENT NEIGHBOUR
        j = i + 1; % RIGHT ADJACENT NEIGHBOUR
        if (i == 1)
            h = size(Fy,1);
        end
        if (i == size(Fy,1))
            j = 1;
        end
        if (Fy(i) > Fy(h))&&(Fy(i) > Fy(j))
            NBf(i) = Fy(i);
            NBc(i) = Cy(i);
            NB(i,:) = Y(i,:);
        end
        % % % SET GLOBAL BEST POSITION
        if Fy(i) > Bf(t)
            Bf(t) = Fy(i);
            Bc(t) = Cy(i);
            B(t,:) = Y(i,:);
        end
    end
        
    for i = 1:P
        r1 = rand(1,genes);
        r2 = rand(1,genes);
        for j = 1:genes
            V(i,j) = V(i,j)+c1(j)*r1(j)*(Y(i,j)-X(i,j))+...
                c2(j)*r2(j)*(NB(i,j)-X(i,j));
            X(i,j) = X(i,j)+V(i,j);
            if X(i,j) < 0
                X(i,j) = abs(rand()*X(i,j));
                V(i,j) = rand()*V(i,j);
            end
        end
    end
    % %     WAITBAR
    progress = t/N;
    waitbar(progress,waitPSO,sprintf('Generation %i of %i',t,N));
end

% % CLOSE WAITBAR
close(waitPSO);

% % PLOTTING
[~,iB] = max(Bf);
Best = B(iB,:);
Obtained = Nutrition( Best );
X = 1:cont;
Y = [Obtained;Required]';
plotRequirements(X,Y);
clear X Y;

plotHallOfFame(1:N,Bf);

plotCost(1:N,Bc);

% % CREATE OUTPUT VARIABLES
Soln = Best;

end

