function [ Child1, Child2 ] = Crossover( Parent1, Parent2, Type )
%CROSSOVER Summary of this function goes here
%   Detailed explanation goes here

genes = size(Parent1,2);

switch Type
    case 'SBX'
        n = 2;
        r = rand(1,genes);
        y = zeros(1,genes);
        for j = 1:genes
            if r(j)<=0.5
                y(j) = ( 2*r(j) )^( 1/(n+1) );
            else
                y(j) = ( 2*(1-r(j)) )^( 1/(n+1) );
            end
            Child1(j) = 0.5*( (1+y(j))*Parent1(j) + (1-y(j))*Parent2(j) ); %#ok<*AGROW>
            Child2(j) = 0.5*( (1-y(j))*Parent1(j) + (1+y(j))*Parent2(j) );
        end
    case 'Geometrical'
        for j = 1:genes
            Child1(j) = (Parent1(j)*Parent2(j))^0.5;
            Child2(j) = Child1(j);
        end
        while isequal(Child1,Child2)
            Child2 = Mutate(Child1);
        end
    otherwise
        errorstring = sprintf('The Crossover Technique "%s" Does Not Exist',Type);
        dlgname = sprintf('\bInvalid Crossover');
        errordlg(errorstring,dlgname,'modal');
end

end

