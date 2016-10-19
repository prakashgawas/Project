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
num=12;
OS=zeros(num,Time);
Os=zeros(num,Time);
oc=0.4;%purchase cost
sc=1; %shortage cost
foc=0.2; %fixed ordering cost
%%
hc=0; %holding cost
for f=1:num
    hc=hc + 0.1;
    
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
    
    %%
    %program
    decision1=zeros(M+1,Time-1);
    u=zeros(M+1,N+1);
    u_s=zeros(M+1,1);
    u_t=zeros(M+1,Time);
    for t=length(T)-1:-1:1
        for s=1:length(S)
            for a=1:length(A)
                if(S(s)+A(a)<=M)
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
%     decision=zeros(M+2,Time+2);
%     decision(2:M+2,1)=S';
%     decision(1,2:Time+2)=0:Time;
%     decision(2:M+2,2:Time+1)=decision1;
%     disp(decision);
    OS(f,:)=max(decision1);
    w=decision1;
    w(w==0)=Inf;
    Os(f,:)=min(w);
end