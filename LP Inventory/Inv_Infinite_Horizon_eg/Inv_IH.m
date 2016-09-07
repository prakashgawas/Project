
clear all;
N = 3;
M = 3;% Number of states
S = 0:1:N ; % states
p = [ .25, 0.5, 0.25]; 
F = zeros(1,N+1);
for s=1:length(S)
    i=1;
    while (i < s)
        F(s)= F(s)+ 8*S(i)*p(i);
        i=i+1;
    end
    F(s)=F(s)+8*S(i)*sum(p(i:M));
end

%Expected reward
r=zeros(N+1,N+1);
for s=1:length(S)
    i=0;
    for a=1:length(S)
        if(S(s)+S(a)<4)
            if (S(a)==0)
                r(s,a)=F(S(s)+S(a)+1)-S(s);
      
            else
                r(s,a)= F(S(s)+S(a)+1)-4-S(s)-3*S(a);
            end
            i=i+1;
        end
    end
end
    
%transition probability
prob1=zeros(N+1,N+1);
for s=1:length(S)
    j=s;
    z=1;
    while(j>1&&j>s-4)    
            prob1(s,j)=p(S(s)-S(j)+1);
            z=z-prob1(s,j);
            j=j-1;
    end
    prob1(s,j)=z;
end
            
prob=zeros(N+1,N+1,N+1);

for s=1:length(S)
    for a=1:length(S)
        if(S(s)+S(a)<=M)
           for j=1:length(S)
                if(j<=s+a)
                    prob(s,j,a)=prob1(S(s)+S(a)+1,S(j)+1);
                end
           end
        end
    end
end

for s=1:length(S)
    a=length(S)-s+1;
    while(a>=1)
        q(s,a)=1;
        a=a-1;
    end
end
        

                 %% data file for Solver %%%%%%%%%
disp('File writing');

fileID = fopen('Inv_IH.dat','w');

% T Value
fprintf(fileID,'param M := %d;\n', M);

% N Value
fprintf(fileID,'param N := %d;\n', N);

%lambda
fprintf(fileID,'param lambda:= 0.95;\n');
% for set states
fprintf(fileID,'set S := ');
for i1 = 0:N
    fprintf(fileID,'%d \t',i1);
end
fprintf(fileID,';\n');
% for alpha
fprintf(fileID,'param alpha := ');
for i1 = 0:N
    fprintf(fileID,'%d 0.25\n',i1);
end
fprintf(fileID,';\n');

% for set time_epoch
%fprintf(fileID,'set time_epoch := \t');
%for i2 = 0:T-1
%    fprintf(fileID,'%d \t',i2);
%end
%fprintf(fileID,';\n');

% for set actions
fprintf(fileID,'set A := \t');
for i3 = 0:N
    fprintf(fileID,'%d \t',i3);
end
fprintf(fileID,';');
fprintf(fileID,'\n');
%q


fprintf(fileID,'param q :');
for s1 = 1:length(S)
    fprintf(fileID,' %d \t', s1-1);
end
fprintf(fileID,':= \n');
for s = 1:length(S) 
    fprintf(fileID,' %d \t', s-1);
    for s1 = 1:length(S)
        fprintf(fileID,'%1.15f \t', q(s,s1));
    end
    fprintf(fileID,' \n');
end
fprintf(fileID,';\n');

% for rewards

fprintf(fileID,'param r :');
for s1 = 1:length(S)
    fprintf(fileID,' %d \t', s1-1);
end
fprintf(fileID,':= \n');
for s = 1:length(S) 
    fprintf(fileID,' %d \t', s-1);
    for s1 = 1:length(S)
        fprintf(fileID,'%1.15f \t', r(s,s1));
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




