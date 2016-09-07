
clear all;
N = 10;% Number of items you can order
M = 10;% Number of states
Time = 10;
S = 0:1:M ;% states
A= 0:1:N;%actions
T = 0:1:Time;
p = 1/11; 

oc=2;%purchase cost
sc=0.4; %shortage cost
hc=0.2; %holding cost
%%

%Expected reward
r=zeros(M+1,N+1);
for s=1:length(S)
    for a=1:length(A)
        TOC=oc*A(a);
        z=0;
        THC=0;
        TSC=0;
        while(z<=10)
            if(z<=S(s)+A(a))
                THC=THC+ hc*(S(s)+A(a)-z)*p;
            else
                TSC=TSC+sc*(z-S(s)-A(a))*p;
                
            end
            
            z=z+1;
        end
        r(s,a)=TOC +THC+TSC;
    end
end
    
%transition probability
prob1=zeros(M+1,N+1);

for s=1:M+N+1
    j=s;
    z=1;
    while(j>1&&j>s-10)    
            prob1(s,j)=p;
            z=z-prob1(s,j);
            j=j-1;
    end
    prob1(s,j)=z;
end
            
prob=zeros(M+1,M+1,N+1);

for s=1:length(S)
    for a=1:length(S)
        if(S(s)+A(a)<=M)
           for j=1:length(S)
                if(j<=s+a)
                    prob(s,j,a)=prob1(S(s)+A(a)+1,S(j)+1);
                end
           end
        end
    end
end


                 %% data file for Solver %%%%%%%%%
disp('File writing');

fileID = fopen('Inv_sS.dat','w');

% M Value
fprintf(fileID,'param M := %d;\n', M);

% N Value
fprintf(fileID,'param N := %d;\n', N);

% Time Value
fprintf(fileID,'param Time := %d;\n', Time);

%lambda
%fprintf(fileID,'param lambda:= 0.95;\n');


% for set states
fprintf(fileID,'set S := \t');
for i1 = 0:M
    fprintf(fileID,'%d \t',i1);
end
fprintf(fileID,';\n');

% for set actions
fprintf(fileID,'set A := \t');
for i3 = 0:N
    fprintf(fileID,'%d \t',i3);
end
fprintf(fileID,';');
fprintf(fileID,'\n');

% for time epochs
fprintf(fileID,'set T := \t');
for i1 = 0:Time
    fprintf(fileID,'%d \t',i1);
end
fprintf(fileID,';\n');


% for alpha
fprintf(fileID,'param alpha := ');
for i1 = 0:N
    fprintf(fileID,'%d 0.0909090\n',i1);
end
fprintf(fileID,';\n');

% for set time_epoch
%fprintf(fileID,'set time_epoch := \t');
%for i2 = 0:T-1
%    fprintf(fileID,'%d \t',i2);
%end
%fprintf(fileID,';\n');

% for rewards

fprintf(fileID,'param r :=');
for t = 1:length(T)
    str=sprintf('[*,*,%d]: \t',t-1);
    str1 = sprintf('%d ', 0:1:N );
    fprintf(fileID,'%s %s  := \n', str, str1);
    for s = 1:length(S) 
        fprintf(fileID,' %d \t', s-1);
        str1 = sprintf('%1.15f ', r(s,:) ); 
        fprintf(fileID,'%s \n', str1);
    end
    fprintf(fileID,' \n');
end
fprintf(fileID,';\n');


% for probability param
fprintf(fileID,'param P:= \n');

for a = 1:length(S)
    str=sprintf('[*,*,%d]: \t',a-1);
    str1 = sprintf('%d ', 0:1:N ); 
    fprintf(fileID,'%s %s  := \n', str, str1);
    for s2 = 1:length(S)
        str= sprintf('%d \t',s2-1);
        str1 = sprintf('%1.15f ', prob(s2,:,a) ); 
        fprintf(fileID,'%s %s \n', str, str1);
    end
    fprintf(fileID,' \n');
end
        

 



