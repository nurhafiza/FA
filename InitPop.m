function Chrom=InitPop(PopSize,Dimension)
%% Initial population
% Input:
% PopSize: population size
% Dimension: individual chromosome length 
% Output:
% Initial population
 
Chrom=zeros(PopSize,Dimension); % For storing population
for i=1:PopSize
    Chrom(i,:)=randperm(Dimension); % Randomly generated initial population
end