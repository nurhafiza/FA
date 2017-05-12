function Score=CalculateScore(ScoringMatrix,Chrom)
%% Calculate a scoring value for the chromosome 
% Input: scoring matrix of each fragment involved
% Chrom individual tracks
[row,col]=size(ScoringMatrix); 
PopSize=size(Chrom,1);
Score=zeros(PopSize,1);
for i=1:PopSize
    chromosome=Chrom(i,:); 
    i1=chromosome(1:end-1);
    i2=chromosome(2:end);
    %show=i1-1;
    %tunjuk=col+i2;
    %see=(D((i1-1)*col+i2));
    Score(i,1)=sum(ScoringMatrix((i1-1)*col+i2));  
end