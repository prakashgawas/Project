
clear all;
N = 20;% Number of items you can order
M = 20;% Number of states
Time = 10;
S = 0:1:M ;% states
A= 0:1:N;%actions
T = 0:1:Time;
 
Max_demand=20;
pr=0.3;
for i=1:Max_demand+1
    p(i)=geopdf(i-1,pr);
end

oc=0.4;%purchase cost
sc=1; %shortage cost
hc=0.1; %holding cost
foc=0.2; %fixed ordering cost
%%

%Expected reward
r=zeros(M+1,N+1);
for s=1:length(S)
    for a=1:length(A)
        TOC=0;
        z=0;
        THC=0;
        TSC=0;
        if(S(s)+A(a)<=M)
            TOC=oc*A(a)+foc*(A(a)>0);
            while(z<=100)
                if(z<S(s)+A(a))
                    THC=THC+ hc*(S(s)+A(a)-z)*geopdf(z,pr);
                else
                    TSC=TSC+sc*(z-S(s)-A(a))*geopdf(z,pr);
                end
            
                z=z+1;
        
            end
        end
        
        r(s,a)=TOC +THC+TSC;
    end
end
    
%transition probability
prob1=zeros(M+1,N+1);

for s=1:M+1
    j=s;
    z=1;
    i=1;
    while(j>1&&j>s-Max_demand)    
            prob1(s,j)=p(i);
            z=z-prob1(s,j);
            j=j-1;
            i=i+1;
    end
    prob1(s,j)=z;
end
            
prob=zeros(M+1,M+1,N+1);

for s=1:length(S)
    for a=1:length(A)
        if(S(s)+A(a)<=M)
           for j=1:length(S)
                if(S(j)<=S(s)+A(a))
                    prob(s,j,a)=prob1(S(s)+A(a)+1,S(j)+1);
                end
           end
        end
    end
end


                 %% data file for Solver %%%%%%%%%
disp('File writing');

fileID = fopen('Inv_sS20_2.dat','w');

% M Value
fprintf(fileID,'param Max_num_States := %d;\n', M);

% N Value
fprintf(fileID,'param Max_num_Actions := %d;\n', N);

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
for i1 = 0:M
    fprintf(fileID,'%d %d\n',i1,1/(M+1));
end
fprintf(fileID,';\n');

% for set time_epoch
%fprintf(fileID,'set time_epoch := \t');
%for i2 = 0:T-1
%    fprintf(fileID,'%d \t',i2);
%end
%fprintf(fileID,';\n');

% for rewards

fprintf(fileID,'param Reward :=');
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
fprintf(fileID,'param Prob:= \n');

for a = 1:length(A)
    str=sprintf('[*,*,%d]: \t',a-1);
    str1 = sprintf('%d ', 0:1:M ); 
    fprintf(fileID,'%s %s  := \n', str, str1);
    for s2 = 1:length(S)
        str= sprintf('%d \t',s2-1);
        str1 = sprintf('%1.15f ', prob(s2,:,a) ); 
        fprintf(fileID,'%s %s \n', str, str1);
    end
    fprintf(fileID,' \n');
end