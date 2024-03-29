clear all;
N = 20;% Number of items you can order
M = 20;% Number of states
Time =10;
S = 0:1:M ;% states
A= 0:1:N;%actions
T = 0:1:Time;
gamma=0.001;
pr=0.3;
Max_demand=4;
for i=1:Max_demand+1
    p(i)=geopdf(i-1,pr);
end

oc=0.2;%purchase cost
sc=1; %shortage cost
foc=0.2; %fixed ordering cost
hc=0.1; %holding cost
%%


%Expected reward
TSC=zeros(M+1,N+1);
for s=1:length(S)
    for a=1:length(A)
        if(S(s)+A(a)<=M)
            THC(s,a)=hc*S(s);
            TOC(s,a)=oc*A(a)+foc*(A(a)>0);
            if(S(s)+A(a)<Max_demand)
               z=1:Max_demand-S(s)-A(a);
               TSC(s,a)=log(exp(sc*z)*p(1:max(z))');
               
            end
        end
    end
end

%TSC(1,:)= log(p(1:Max_demand)*exp(sc*S(2:Max_demand+1))');
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
                u(s,a)=(exp(gamma*r(s,a)).*prob(s,:,a))*u_s;
            else
                u(s,a)=100000000000;
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
decision(2:M+2,2:Time+1)=decision1;
disp(decision);
