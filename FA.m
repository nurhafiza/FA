Gamma=50; %%light absorption (0-100)
MaxGen=10; 
PopSize=10; 
CompRun=10;

fileID=fopen('DataAnalysis.txt','w');
fileID1=fopen('DataAnalysis01.txt','w');
IDfile=fopen('Results.txt','w');
TimeFile=fopen('ElapsedTime.txt','w');

ScoringMatrix=csvread('f25_305.csv');
Dimension=size(ScoringMatrix,1);  


for i=1:CompRun
IniTime=tic;
fprintf('\nNo of Run %d\n',i);
fprintf(fileID,'\n====================');
fprintf(fileID,'\nNo of Run %d\n',i);
fprintf(fileID,'====================\n');
fprintf(fileID1,'\n====================');
fprintf(fileID1,'\nNo of Run %d\n',i);
fprintf(fileID1,'====================\n');
%% Initial population
Chrom=InitPop(PopSize,Dimension); 
ChromList=Chrom;

%% Initial solution with scoring value
%disp('An initial population of random solution: ');
InitialSolution=OutputSolution(Chrom(1,:));
InitialScoringValue=CalculateScore(ScoringMatrix,Chrom(1,:));

%% Optimization
ObjV=CalculateScore(ScoringMatrix,Chrom);
preObjV=max(ObjV);
for Gen=1:MaxGen
%    fprintf('\nIteration %d\n',Gen);
    fprintf(fileID,'---------------------------------------------------');
    fprintf(fileID,'\nIteration %d\n',Gen);
    fprintf(fileID,'---------------------------------------------------\n');
  
    %% Calculate fitness
    ObjV=CalculateScore(ScoringMatrix,Chrom); 
    [preObjV,ObjVNo]=max(ObjV);
    CurrBestSol=Chrom(ObjVNo,:);
%    fprintf(fileID,'---------------------');
%    fprintf(fileID,'\nIteration %d\n',Gen);
%    fprintf(fileID,'---------------------\n');
    for i=1:PopSize
        K=0;
        solution=zeros(PopSize,Dimension); 
        
        for j=1:i-1
            Dij=Distance(Chrom(i,:),Chrom(j,:)); 
            if Dij<=Gamma
                K=K+1; 
                solution(K,:)=Chrom(j,:); 
            end
        end
        
        for j=i+1:PopSize
            Dij=Distance(Chrom(i,:),Chrom(j,:)); 
             if Dij<=Gamma
                K=K+1;
                solution(K,:)=Chrom(j,:);
             end
        end
        
        if K==0
            solution1=zeros(1,Dimension);
        else
            solution1=ones(K,Dimension); 
        end
        
        for v=1:K
            solution1(v,:)=solution(v,:);
        end
        
        if K~=0
            ObjV1=CalculateScore(ScoringMatrix,solution1);
            [maxObjV1,ObjV1No]=max(ObjV1); 
             maxChrom=solution1(ObjV1No,:);
%             fprintf('\nPopulation %d\n',i);
            ObjValue=CalculateScore(ScoringMatrix,Chrom(i,:));
            if ObjValue<maxObjV1
                [Chrom(i,:),maxChrom]=ChangePlace(Chrom(i,:),maxChrom);
                    NewObjValue=maxObjV1;
            else
                    NewObjValue=ObjValue;
            end
            
            ShowNewObjValue(1,i)=NewObjValue;
            MaxNewObjValue=max(ShowNewObjValue(1,i));
            fprintf(fileID,'%5d   ---> %5d   ---> %5d   ---> %5d\n',i,maxObjV1,ObjValue,NewObjValue); 
        end
    end
            globalmax(Gen)= NewObjValue;           % save globalminimum value in each iteration
            iteration(Gen)= Gen; 
            fprintf(fileID1,'Iteration %5d   ---> %5d\n',Gen,NewObjValue); 
end
%subplot(1,1,1);
plot(iteration,globalmax)
xlabel('Iteration');
ylabel('Best Score');
hold on;
grid on;
%subplot(2,1,1);
%plot(iteration,globalmax)
%hold on;
%% Output optimal solution and the total scoring value
%disp('/////////////////////////////////////////');
MaxObjVal=MaxNewObjValue;
%fprintf(fileID,'\n********************************************************\n');
fprintf(fileID,'\nOverallMaxObjValue = %5d\n',MaxObjVal);
fprintf(fileID1,'\nOverallMaxObjValue = %5d\n',MaxObjVal);
fprintf(IDfile,'%5d\n',MaxObjVal);
FinTime=toc(IniTime);
fprintf(TimeFile,'%5d\n',FinTime);
%[MaxObjVal,ObjV1No]=max(ShowNewObjValue(1,i));
%fprintf('\nOverallMaxObjValue %5d',MaxObjVal);
%CurrBestSolution=OutputSolution(maxChrom(ObjV1No,:))
end
fclose(fileID);
fclose(fileID1);
fclose(IDfile);
fclose(TimeFile);
IDfile=fopen('Results.txt','r');
data=cell2mat(textscan(IDfile,'%5d'));
data=dlmread('results.txt')
TimeFile=fopen('ElapsedTime.txt','r');
ElapsedTime=cell2mat(textscan(TimeFile,'%5d'));
ElapsedTime=dlmread('elapsedtime.txt')
highestScore=max(data);
lowestScore=min(data);
avg=mean(data);
stdDev=std(data);
totalTime=sum(ElapsedTime);
avgElapsedTime=mean(ElapsedTime);
disp(['Best Scoring Value = ' num2str(highestScore)]);
disp(['Worst Scoring Value = ' num2str(lowestScore)]);
disp(['Average = ' num2str(avg)]);
disp(['Standard Deviation = ' num2str(stdDev)]);
disp(['Average Elapsed Time = ' num2str(avgElapsedTime)]);
fclose(IDfile);
fclose(TimeFile);
disp('-------------------------------------------------------------------');
