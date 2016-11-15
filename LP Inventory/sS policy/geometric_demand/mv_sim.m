N = 20;% Number of items you can order
M = 20;% Number of states
Time = 10;
%S = 0:1:M ;% states
%A= 0:1:N;%actions
T = 0:1:Time;
 
Max_demand=20;
pr=0.3;
for i=1:Max_demand+1
    p(i)=geopdf(i-1,pr);
end

oc=0.2;%purchase cost
sc=1; %shortage cost
foc=0.2; %fixed ordering cost
hc=0.1; %holding cost

SIM=200000;
%%
S=max(decision1);
k=decision1;
k(k==0)=Inf;
[temp3,s]=min(k);
s=s-1;
r_sim=zeros(1,SIM);
var=zeros(1,M+1);

%r_sim=0;
for init=0:20
    r_sim=zeros(1,SIM);
    for i=1:SIM
        d=geornd(pr,1,Time);
        x=init;
        for j=1:Time
            if(x<s(j))
                r_sim(i)=r_sim(i)+ foc + oc*(S(j)-x);
                x=S(j);
            end
            if (x<d(j))
                r_sim(i)=r_sim(i)+ sc*(d(j)-x);
                x=0;
                %d(j)-x
            else
                x=x-d(j);
                r_sim(i)=r_sim(i)+ hc*x;
                %x
            end
            
        end
    end
    value(init+1)=mean(r_sim);
    var(init+1)=std(r_sim)^2;
end
%disp (value);

%%
% S=max(decision1);
% k=decision1;
% k(k==0)=Inf;
% [temp3,s]=min(k);
% s=s-1;
% r_sim=zeros(1,SIM);
% %r_sim=0;
% init=2;
% 
% for i=1:SIM
%     d=geornd(pr,1,Time);
%     x=init;
%     for j=1:Time
%         if(x<s(j))
%             r_sim(i)=r_sim(i)+ foc + oc*(S(j)-x);
%             x=S(j);
%         end
%         if (x<d(j))
%             r_sim(i)=r_sim(i)+ sc*(d(j)-x);
%             x=0;
%             %d(j)-x
%         else
%             x=x-d(j);
%             r_sim(i)=r_sim(i)+ hc*x;
%             %x
%         end
%         
%     end
% end
% disp(mean(r_sim));
% 
