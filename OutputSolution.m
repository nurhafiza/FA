function  chromosome=OutputSolution(fragment)
%% Output chromosome
% Input: fragment
fragment=[fragment];
N=length(fragment);
chromosome=num2str(fragment(1));
for i=2:N
    chromosome=[chromosome,'->',num2str(fragment(i))];
end
