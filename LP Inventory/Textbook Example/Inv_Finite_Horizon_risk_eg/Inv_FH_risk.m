
clear all;
N = 3;
M = 3;% Number of states
Time = 3;
S = 0:1:N ; % states
T = 0:1:Time;
p = [ .25, 0.5, 0.25]; 
gamma=0.5;
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

% %si value
% si(1,1)= 1;
% si_cnt (1) = 1;
% for  t = 2:1:length(T)
%     si_cnt(t) = 1;
%     for i = 1:1:si_cnt (t-1)
%         for s =1:1:length(S)
%             for a = 1:1:length(S)
%                 if(S(s)+S(a)<=M)
%                     tmp = si(t-1,i) * exp(-r(s,a));
%                     if  si_cnt(t) > 1 
%                         if min(abs(tmp- si(t,1:si_cnt(t)-1) ) ) <= precision 
%                          
%                         continue;
%                         %si(t,si_cnt(t)) = 0;
%                         %si_cnt(t)  = si_cnt(t) + 1;
%                         end
%                     end
%                     si(t,si_cnt(t)) = tmp;
%                     si_state(t,si_cnt(t)) = S(s);
%                     %si(t,count) = si(t-1,i) * exp(-v*S(s)+lmd(a)*S(s)); % we need to compute s*a elements for each si(t,:)
%                     %disp('size of si');disp(size(si)); disp('si');disp(si);
%                     si_cnt(t)  = si_cnt(t) + 1;
%                 end
%                  
%             end
%         end
%     end
%     si_cnt (t) = si_cnt(t) - 1;
% end
% 
% %% new probability matrix with si
% Prob=zeros (length(S), si_cnt(length(T)), length(T)-1, length(S),si_cnt(length(T)), length(S)); 
% 
% for t = 1:1:length(T)-1
%     for s1 = 1:1:length(S)
%         for a = 1:1:length(S)
%             if(S(s1)+S(a)<=M)   
%                 tmpr1 = exp(-r(s1,a));
%                 for h1 = 1:1:si_cnt (t)
%                     tmpr=si(t,h1) * tmpr1;
%                     for s2 = 1:1:length(S)
%                         for h2 = 1:1:si_cnt (t+1)
%                             %chi(s1,2,t,h2) = chi()
%                         
%                             if abs(si(t+1,h2) - tmpr) <= precision 
%                                 pval =  prob(s1,s2,a);
%                             else
%                                 pval = 0; %0* P(s1,s2,a);
%                             end
%                         
%                             Prob(s2,h2,t,s1,h1,a) = pval;%trans_prob(s2,h2,t,s1,h1,a);
%                         end
%                     end
%                 end
%             end
%         end
%     end
% end

        

                 %% data file for Solver %%%%%%%%%
disp('File writing');

fileID = fopen('Inv_FH_risk.dat','w');

% M Value
fprintf(fileID,'param Max_num_States := %d;\n', M);

% N Value
fprintf(fileID,'param Max_num_Actions := %d;\n', N);

% T Value
fprintf(fileID,'param Time := %d;\n', Time);
% 
% %lambda
% fprintf(fileID,'param lambda:= 0.95;\n');

%gamma
fprintf(fileID,'param gamma:= %d;\n',gamma);

% for set states
fprintf(fileID,'set S := ');
for i1 = 0:N
    fprintf(fileID,'%d \t',i1);
end
fprintf(fileID,';\n');


% for time epochs
fprintf(fileID,'set T := ');
for i1 = 0:Time
    fprintf(fileID,'%d \t',i1);
end
fprintf(fileID,';\n');

% % Set J for si 
% fprintf(fileID,'set J :=');
% for j1 = 0:si_cnt(length(si_cnt))-1
%     fprintf(fileID,'%d \t',j1);
% end
% fprintf(fileID,';\n');



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
% fprintf(fileID,'param q :');
% for s1 = 1:length(S)
%     fprintf(fileID,' %d \t', s1-1);
% end
% fprintf(fileID,':= \n');
% for s = 1:length(S) 
%     fprintf(fileID,' %d \t', s-1);
%     for s1 = 1:length(S)
%         fprintf(fileID,'%1.15f \t', q(s,s1));
%     end
%     fprintf(fileID,' \n');
% end
% fprintf(fileID,';\n');

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

% %si
% fprintf(fileID,'param si :\n');
% for m = 0:si_cnt(length(si_cnt))-1
%         fprintf(fileID,' %d \t', m);
% end
% fprintf(fileID,':= \n');
% for t = 0:1:length(T)-1
%     fprintf(fileID,' %d \t', t);
%     for j2 = 1:1:si_cnt(length(si_cnt))
%         fprintf(fileID,'%1.15f \t', si(t+1,j2));
%     end
%     fprintf(fileID,' \n');
% end
% fprintf(fileID,';\n');
% 
% % for probability param
% fprintf(fileID,'param Prob := \n');
% for t = 0:1:length(T)-2
%     for s1 = 0:1:length(S)-1
%         for h1 = 0:1:si_cnt(length(si_cnt))-1
%             for a = 0:1:length(S)-1
%                 str=sprintf('[*,*,%d,%d,%d,%d]: \t',t,s1,h1,a);
% %                 for m = 0:1:gi_cnt(length(gi_cnt))-1
% %                     str=sprintf('%s %d \t', str,m);
% %                 end
%                   str1 = sprintf('%d ', 0:1:si_cnt(length(si_cnt))-1 ); 
%                 fprintf(fileID,'%s %s  := \n', str, str1);
%                 %for k1 = 0:1:length(S)-1
%                     %fprintf(fileID,'%d \t',k1);
%                     for s2 = 0:1:length(S)-1
%                         str= sprintf('%d \t',s2);
%                         
%                         str1 = sprintf('%1.15f ', Prob(s2+1, :,t+1,s1+1,h1+1,a+1) ); 
% %                         for h2 = 0:1:gi_cnt(length(gi_cnt))-1
% %                             str=sprintf('%s%1.15f \t',str,Prob(s2+1,h2+1,t+1,s1+1,h1+1,a+1));
% %                         end
%                         fprintf(fileID,'%s %s \n', str, str1);
%                     end
%                     fprintf(fileID,' \n');
%                 %end
%             end
%         end
%     end
% end



