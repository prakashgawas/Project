clear all;
N = 20;% Number of items you can order
M = 20;% Number of states
Time =10;
S = 0:1:M ;% states
A= 0:1:N;%actions
T = 0:1:Time;
gamma=0.001;
pr=0.3;
Max_demand=20;%max fulfilled demand
for i=1:Max_demand+1
    p(i)=geopdf(i-1,pr);
end

oc=0.4;%purchase cost
sc=1; %shortage cost
foc=0.2; %fixed ordering cost
hc=1; %holding cost

%%

%Expected reward
TSC=zeros(M+1,N+1);
for s=1:length(S)
    for a=1:length(A)
        if(S(s)+A(a)<=M)
            THC(s,a)=gamma*hc*S(s);
            TOC(s,a)=gamma*(oc*A(a)+foc*(A(a)>0));
        end
    end
end

TSC(1,:)= log(pr/(1-exp(gamma*sc)*(1-pr)));
r_1=TOC;
r=TOC+TSC+THC;
for s=1:length(S)
    if(S(s)==0)
        r_T(s)=TSC(1,1);
    else
        r_T(s)=gamma*hc*S(s);
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

fileID = fopen('Inv_risk_exp.dat','w');

% M Value
fprintf(fileID,'param Max_num_States := %d;\n', M);

% N Value
fprintf(fileID,'param Max_num_Actions := %d;\n', N);

% Time Value
fprintf(fileID,'param Time := %d;\n', Time);

%lambda
%fprintf(fileID,'param lambda:= 0.95;\n');

%gamma
fprintf(fileID,'param gamma:= %d;\n',gamma);

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
    fprintf(fileID,'%d %d\n',i1,1/(Max_demand+1));
end
fprintf(fileID,';\n');

% for set time_epoch
%fprintf(fileID,'set time_epoch := \t');
%for i2 = 0:T-1
%    fprintf(fileID,'%d \t',i2);
%end
%fprintf(fileID,';\n');

% for rewards
%reward 
fprintf(fileID,'param Reward := ');
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

%reward other 1
fprintf(fileID,'param Reward_1 :');
str1 = sprintf('%d ', 0:1:N );
fprintf(fileID,' %s  := \n', str1);
for s = 1:length(S) 
    fprintf(fileID,' %d \t', s-1);
    str1 = sprintf('%1.15f ', r_1(s,:) ); 
    fprintf(fileID,'%s \n', str1);
end
fprintf(fileID,' \n');
fprintf(fileID,';\n');

%reward Terminal
fprintf(fileID,'param Reward_T :=');
for i1 = 0:M
    fprintf(fileID,'%d %d\n',i1,r_T(i1+1));
end
fprintf(fileID,';\n');
%% for probability param
fprintf(fileID,'param Prob:= \n');

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
fprintf(fileID,';\n');