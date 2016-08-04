
clear all;
N = 5; % Number of states
S = 0:1:N ; % states
T = 15; % time epoch
time = 0:1:T; % time epoch
k = N; % number of servers
lmd = 0:1; % actions
mu = 0; mu_f = 0.3; mu_s = 0.1; % server serving rate
p = .4; % bernoulli random variable parameter of customer arrival
global gi;
h=0.0000000  ; gamma =.002;
beta =log(exp(gamma)*p + (1-p));
%beta = 1;
precision = 0.0000000000;00000001;
P = zeros(N+1,N+1,length(lmd)); % transition probability matrix
for a = 1:length(lmd) % for each actions i
    mu = mu_f * lmd(a) + mu_s * (1-lmd(a));
    exp_mu = exp(-mu);
    for s1 = 1:length(S) % for each starting state j
        for s2 = 1:min(s1+1, k+1)%min(s1,k+1) % next state
            if S(s1)== k && S(s2)==k
                %combination3 = factorial(S(s1))/(factorial(S(s2)-1) * factorial(S(s1)-S(s2)+1));
                P(s1,s2,a) = p* k * (exp_mu ^ (k-1)) * (1-exp_mu) + (exp_mu ^ k);
            else
            if S(s2) <= S(s1)+1
                if S(s2)==0
                    P(s1,s2,a) = (1-p)*((1-exp_mu)^S(s1));
                end
                if S(s2) > 0 && S(s2) <= S(s1)
                    combination1 = factorial(S(s1))/(factorial(S(s2)-1) * factorial(S(s1)-S(s2)+1));
                    combination2 = factorial(S(s1))/(factorial(S(s2)) * factorial(S(s1)-S(s2)));
                    P(s1,s2,a) = p* combination1 * ((exp_mu)^(S(s2)-1)) * (1-(exp_mu))^(S(s1)-S(s2)+1) + (1-p)* combination2 * ((exp_mu)^(S(s2))) * ((1-(exp_mu))^(S(s1)-S(s2)));
                    %P(j+1,k+j+1,i) = combination * ((1- exp(-vpa(lmd(1,i),6)))^(k)) * (exp(-vpa(lmd(1,i),6)))^(N-j-k);
                end
                if S(s2) ==S(s1)+1
                    P(s1,s2,a) = p*((exp_mu)^S(s1));
                    
                end
            end
            end
            
            
        end
    end
end
%% reward value

reward = zeros(length(time),length(S)); % reward function matrix
for t = 1:length(time) % for each time epoch
    for s = 1:length(S) % foreach states
        if S(s) == k 
            reward(t,s) = 1*beta;
        end
    end
end


%% gi value
gi(1,1)= 1;
gi_cnt (1) = 1;
for  t = 2:1:length(time)
    gi_cnt(t) = 1;
    for i = 1:1:gi_cnt (t-1)
        for s =1:1:length(S)
            for a = 1:1:length(lmd)
                tmp = gi(t-1,i) * exp(-reward(t,s)-h*S(s)*lmd(a));
                if  gi_cnt(t) > 1 
                     if min(abs(tmp- gi(t,1:gi_cnt(t)-1) ) ) <= precision 
                         
                       continue;
                       %gi(t,gi_cnt(t)) = 0;
                       %gi_cnt(t)  = gi_cnt(t) + 1;
                     end
                end
                gi(t,gi_cnt(t)) = tmp;
                gi_state(t,gi_cnt(t)) = S(s);
                %gi(t,count) = gi(t-1,i) * exp(-v*S(s)+lmd(a)*S(s)); % we need to compute s*a elements for each gi(t,:)
                %disp('size of gi');disp(size(gi)); disp('gi');disp(gi);
                gi_cnt(t)  = gi_cnt(t) + 1;
                 
            end
        end
    end
    gi_cnt (t) = gi_cnt(t) - 1;
end
%gi_cnt = gi_cnt - 1;

disp('gi_cnt=');
disp(gi_cnt)
%% alpha value

A = rand(length(S),1);
total = sum(A);
B = A/total ;
B = ones(1,length(S))/length(S);
B = B';
  B(1:length(S)) =  1/(N+1);
%  B (1)= 1; %1/(N+1);
alpha =zeros(length(S),gi_cnt(length(time)));
for s = 1:1:length(S)
    alpha(s,1) = B(s);
end
%% new probability matrix with gi
Prob=zeros (length(S), gi_cnt(length(time)), length(time)-1, length(S),gi_cnt(length(time)), length(lmd)); 

for t = 1:1:length(time)-1
    for s1 = 1:1:length(S)
        for a = 1:1:length(lmd)
            tmpr1 = exp(-reward(t,s1)-h*S(s1)*lmd(a));
            for h1 = 1:1:gi_cnt (t)
                tmpr=gi(t,h1) * tmpr1;
                for s2 = 1:1:length(S)
                    for h2 = 1:1:gi_cnt (t+1)
                        %chi(s1,2,t,h2) = chi()
                        
                        if abs(gi(t+1,h2) - tmpr) <= precision 
                            pval =  P(s1,s2,a);
                        else
                            pval = 0; %0* P(s1,s2,a);
                        end
                        
                        Prob(s2,h2,t,s1,h1,a) = pval;%trans_prob(s2,h2,t,s1,h1,a);
                    end
                end
            end
        end
    end
end





                 %% data file for Solver %%%%%%%%%
disp('File writing');

fileID = fopen('Queueing_dual.dat','w');

% T Value
fprintf(fileID,'param T := %d;\n', T);

% N Value
fprintf(fileID,'param N := %d;\n', N);

% h value
fprintf(fileID,'param h := %d;\n', h);

% h value
fprintf(fileID,'param beta := %d;\n', beta);

% for set states
fprintf(fileID,'set states := \n');
for i1 = 0:N
    fprintf(fileID,'%d \t',i1);
end
fprintf(fileID,';\n');

% for set time_epoch
fprintf(fileID,'set time_epoch := \t');
for i2 = 0:T-1
    fprintf(fileID,'%d \t',i2);
end
fprintf(fileID,';\n');

% for set actions
fprintf(fileID,'set actions := \t');
for i3 = 0:length(lmd)-1
    fprintf(fileID,'%d \t',i3);
end
fprintf(fileID,';');
fprintf(fileID,'\n');

% for set time_epoch_1
fprintf(fileID,'set time_epoch_1 := \t');
for i4 = 0:T
    fprintf(fileID,'%d \t',i4);
end
fprintf(fileID,';\n');

% Set J0 for gi 
fprintf(fileID,'set J0 :=');
for j0 = 0:gi_cnt(1)-1
    fprintf(fileID,'%d \t',j0);
end
fprintf(fileID,';\n');

% Set J1 for gi 
fprintf(fileID,'set J1 :=');
for j1 = 0:gi_cnt(length(gi_cnt))-1
    fprintf(fileID,'%d \t',j1);
end
fprintf(fileID,';\n');

% for action param
fprintf(fileID,'param A := \n');
for i5 = 0:length(lmd)-1
    fprintf(fileID,'%d \t %f \n',i5,lmd(1,i5+1));
end
fprintf(fileID,';\n');

% gi 
fprintf(fileID,'param gi :\n');
for m = 0:gi_cnt(length(gi_cnt))-1
        fprintf(fileID,' %d \t', m);
end
fprintf(fileID,':= \n');
for t = 0:1:length(time)-2
    fprintf(fileID,' %d \t', t);
    for j2 = 1:1:gi_cnt(length(gi_cnt))
        fprintf(fileID,'%1.15f \t', gi(t+1,j2));
    end
    fprintf(fileID,' \n');
end
fprintf(fileID,';\n');

% for alpha

fprintf(fileID,'param alpha :\n');
for m = 0:1:gi_cnt(length(gi_cnt))-1 % print the column index corresponding to gi starting from 0....gi_cnt
        fprintf(fileID,' %d \t', m);
end
fprintf(fileID,':= \n');
for j1 = 1:length(S)
    fprintf(fileID,' %d \t', j1-1); % print the states (row) for alpha starting from 0...N
    for j2 = 1:1:gi_cnt(length(gi_cnt))
        fprintf(fileID,'%1.15f \t', alpha(j1,j2));
    end
    fprintf(fileID,' \n');
end
fprintf(fileID,';\n');

% for rewards

fprintf(fileID,'param reward :');
for s1 = 1:length(S)
    fprintf(fileID,' %d \t', s1-1);
end
fprintf(fileID,':= \n');
for t = 1:T
    fprintf(fileID,' %d \t', t-1);
    for s1 = 1:length(S)
        fprintf(fileID,'%1.15f \t', reward(t,s1));
    end
    fprintf(fileID,' \n');
end
fprintf(fileID,';\n');




% for probability param
fprintf(fileID,'param Prob := \n');
for t = 0:1:length(time)-2
    for s1 = 0:1:length(S)-1
        for h1 = 0:1:gi_cnt(length(gi_cnt))-1
            for a = 0:1:length(lmd)-1
                str=sprintf('[*,*,%d,%d,%d,%d]: \t',t,s1,h1,a);
%                 for m = 0:1:gi_cnt(length(gi_cnt))-1
%                     str=sprintf('%s %d \t', str,m);
%                 end
                  str1 = sprintf('%d ', 0:1:gi_cnt(length(gi_cnt))-1 ); 
                fprintf(fileID,'%s %s  := \n', str, str1);
                %for k1 = 0:1:length(S)-1
                    %fprintf(fileID,'%d \t',k1);
                    for s2 = 0:1:length(S)-1
                        str= sprintf('%d \t',s2);
                        
                        str1 = sprintf('%1.15f ', Prob(s2+1, :,t+1,s1+1,h1+1,a+1) ); 
%                         for h2 = 0:1:gi_cnt(length(gi_cnt))-1
%                             str=sprintf('%s%1.15f \t',str,Prob(s2+1,h2+1,t+1,s1+1,h1+1,a+1));
%                         end
                        fprintf(fileID,'%s %s \n', str, str1);
                    end
                    fprintf(fileID,' \n');
                %end
            end
        end
    end
end

disp('Solver time');

%% Running the AMPL Code

system ('sh atul.sh');

disp('Solved');

File = importdata('dualresultfinal.txt');


%% The average fast server ON time * 

C = 0;
PXn (1:length(time)-1)= 0;
for t = 0:1:length(time)-2
    
    count = 0;
    for s =0:1:length(S)-1
        for a = 0:1:length(lmd)-1
            for h4 = 1:1:gi_cnt(t+1)
                m = gi_cnt(length(gi_cnt))*count + h4;
                C = C + gi(t+1,h4) *File(m,t+1)*a*s ;% C is for which the fast server is on
%                 if s >= 2
%                     PXn (t+1) = PXn (t+1) + gi(t+1,h4) *File(m,t+1)  ;
%                 end
            end
            count = count + 1;
        end
    end
end
%disp(C);
%disp('PXn');
%disp(PXn);

% for t = 1:length(time)-1
%     for a = 1:length(lmd)
%         for s = 1:length(S)
%             for h4 = 1:gi_cnt(t)
%                 m = gi_cnt(length(gi_cnt))*count + h4;

%% finding the optimal policy i.e. probability of talking actions.

File1 = importdata('y12final.txt');
for t = 1:1:length(time)-1
    for i = 1:1:length(S)
        for a = 1:1:length(lmd)
            m1 = (N+1) * (a-1)+i ;
            xsum = 0;
            for a1 = 1:1:length(lmd)
                m= (N+1) * (a1-1)+i ;
                xsum = xsum + File1(m,t);
            end
            
            if (xsum < 0.000001)
               % disp('zero xsum');
               % disp(xsum);
            end
            xsum = max(xsum, 0.0000001);
            %m1 = (N+1) * (a-1)+i ;
            P12(i,t,a) = File1(m1,t) / (xsum);
            %B = B + File(m1,t) * (lmd(1,a)^b); % Used for calculating rhs for Constraint problem
        end
    end
end

%% E[Nloss]
Nloss = 0;
PXn (1:length(time)-1)= 0;
for t = 0:1:length(time)-2
    count = 0;
    for s =0:1:length(S)-1
        
            for a = 0:1:length(lmd)-1
                for h4 = 1:1:gi_cnt(t+1)
                    m = gi_cnt(length(gi_cnt))*count + h4;
                    if s==k
                    Nloss = Nloss + gi(t+1,h4) *File(m,t+1) *p ;
                    end
%                     if s >= 2
%                         PXn (t+1) = PXn (t+1) + gi(t+1,h4) *File(m,t+1)  ;
%                     end
                end
                count = count + 1;
            end
        
    end
end

str = sprintf('Hard Constraints  T = %d , N = %d, h=%1.15f , p=%f ,lam = %d , B =%f, mu_f=%f, mu_s=%f, beta=%f \n E[N_lost]=%f, gamma=%f',  T,N, h, p, lmd(2), C, mu_f, mu_s, beta, Nloss ,gamma);
disp(str);
%fprintf('C=%d \n',C);
disp('P12');
disp(P12);

% D = 0;
% for t = 1:1:length(time)-1
%     for i = 1:1:length(S)
%         for a = 1:1:length(lmd)
%             m1 = (N+1) * (a-1)+i ;
%             D = D + gi(t+1,h4) *File1(m,t+1) *S(s)*lmd(a) ;
%         end
%     end
% end



