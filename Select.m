function [ I1, I2 ] = Select( Population, Type )
%SELECT Summary of this function goes here
%   Detailed explanation goes here
individuals = size(Population,1);
switch Type
    case 'Tournament'
        subset = ceil(0.10*individuals);
        r = randperm(individuals,subset);
        for i = 1:subset
            if mod(i,2) == 0
                ia = i/2;
                A(ia,:) = Population(r(i),:); %#ok<*AGROW>
            else
                ib = ceil(i/2);
                B(ib,:) = Population(r(i),:);
            end
        end
        [~, I1] = max(A(:,6));
        [~, I2] = max(B(:,6));
    case 'Roulette'% UNDEVELOPED
        I1 = 0;
        I2 = 0;
    otherwise
        errorstring = sprintf('The Selection Technique "%s" Does Not Exist',Type);
        dlgname = sprintf('\bInvalid Selection');
        errordlg(errorstring,dlgname,'modal');
end
end

