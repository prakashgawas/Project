oc=0.2;%purchase cost
sc=1; %shortage cost
hc=1; %holding cost
foc=0.2; %fixed ordering cost
pr=0.3;
gamma=0.2;


c=zeros(6,6);
for x=0:5
    for a=0:5
        if(x+a<=5)
            y=exp(gamma*hc*(x+a))*(1-((1-pr)/exp(gamma*hc))^(x+a+1))/(1-(1-pr)/exp(gamma*hc));
            z=exp(sc*gamma)*(1-pr)^(x+a+1)/(1-exp(gamma*sc)*(1-pr));
            c(x+1,a+1)=exp(gamma*(oc*a+ foc*(a>0)))*pr*(y+z);
        end
    end
end
%display (c);
c(c==0)=Inf;
[f,g]=min(c');
g=g-1;



% y=exp(gamma*hc*(x+a))*(1-((1-pr)/exp(gamma*hc))^(x+a+1))/(1-(1-pr)/exp(gamma*hc));
% z=exp(sc*gamma)*(1-pr)^(x+a+1)/(1-exp(gamma*sc)*(1-pr));
% c(x+1,a+1)=exp(gamma*(oc*a+ foc*(a>0)))*pr*(y+z);