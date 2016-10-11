clear all;
N = 3;% Number of items you can order
M = 3;% Number of states
Time =5;
S = 0:1:M ;% states
A= 0:1:N;%actions
T = 1:1:Time;
gamma=0.3;
pr=0.75;
Max_demand=3;
for i=1:Max_demand+1
    p(i)=geopdf(i-1,pr);
end

oc=0.4;%purchase cost
sc=0.8; %shortage cost
hc=0.2; %holding cost
foc=0.5;%fixed ordering cost
%%

%Expected reward
r=zeros(M+1,M+1,N+1);
for s=1:length(S)
    for a=1:length(A)
        TOC=0;

        THC=0;
        TSC=0;
        if(S(s)+A(a)<=M)
            TOC=oc*A(a)+foc*(A(a)>0);
            x=s+a-1;
            while(S(x)>0)
                r(s,x,a)=hc*(S(x))+TOC;
                x=x-1;
            end
            if(S(s)+S(a)==M)
                r(s,x,a)=TOC;
            else
                if(x==1)
                    z=2;
                    TSC=0;
                    while(z<=Max_demand-S(s)-A(a)+1)
                        TSC=TSC+p(S(z))*exp((S(z))*sc);
                        z=z+1;
                    end
                    B=log(TSC);
                    r(s,x,a)=TOC+B;
                end
            end
            
        end
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
%%

%%Program

decision1=zeros(M+1,Time-1);
u=zeros(M+1,N+1);
u_s=ones(M+1,1);
u_t=zeros(M+1,Time);
u_t(:,Time)=u_s;
for t=length(T)-1:-1:1
    for s=1:length(S)
        for a=1:length(A)
            if(S(s)+A(a)<=M)
                u(s,a)=(exp(gamma*r(s,:,a)).*prob(s,:,a))*u_s;
            else
                u(s,a)=1000000000;
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
