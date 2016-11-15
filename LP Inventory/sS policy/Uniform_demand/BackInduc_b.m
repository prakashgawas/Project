clear all;
N = 20;% Number of items you can order
M_max = 10;% max number of states
M_min=-10;% max number of states
Time = 10;
M=M_max-M_min; %number of states-1
S = M_min:1:M_max ;% states
%S = 0:1:M ;
A= 0:1:N;%actions
T = 1:1:Time;
 
Max_demand=10;
p = 1/(Max_demand+1);

oc=0.4;%purchase cost
sc=3; %shortage cost
hc=0.2; %holding cost
foc=1; %fixed ordering cost
%%

%Expected reward
r=zeros(M+1,N+1);
for s=1:length(S)
    for a=1:length(A)
        TOC=0;
        z=0;
        THC=0;
        TSC=0;
        if(S(s)+A(a)<=M_max)
            TOC=oc*A(a)+foc*(A(a)>0);
            while(z<=Max_demand)
                if(z<=S(s)+A(a))
                    THC=THC+ hc*((S(s)+A(a)-z))*p;
                else
                    TSC=TSC+sc*((z-S(s)-A(a)))*p;
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
    while(j>1&&j>s-Max_demand)    
            prob1(s,j)=p;
            z=z-prob1(s,j);
            j=j-1;
    end
    prob1(s,j)=z;
end
            
prob=zeros(M+1,M+1,N+1);

for s=1:length(S)
    for a=1:length(A)
        if(S(s)+A(a)<=M_max)
           for j=1:length(S)
                if(S(j)<=S(s)+A(a))
                    prob(s,j,a)=prob1(s+a-1,j);
                end
           end
        end
    end
end

decision1=zeros(M+1,Time-1);
u=zeros(M+1,N+1);
u_s=zeros(M+1,1);
u_t=zeros(M+1,Time);
for t=length(T)-1:-1:1
    for s=1:length(S)
        for a=1:length(A)
            if(S(s)+A(a)<=M_max)
                u(s,a)=r(s,a)+prob(s,:,a)*u_s;
            else
                u(s,a)=1000;
            end
        end
    end
    o=u';
    [temp1,temp2]=min(o);
    u_s=temp1';
    decision1(:,t)=temp2';
    u_t(:,t)=u_s;
end
decision1=decision1-1;
decision=zeros(M+2,Time);
decision(2:M+2,1)=S';
decision(1,2:Time)=1:Time-1;
decision(2:M+2,2:Time)=decision1;
disp(decision);
