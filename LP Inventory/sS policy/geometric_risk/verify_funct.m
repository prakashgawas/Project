function t=verify_funct(x,a) 
oc=0.2;%purchase cost
sc=1; %shortage cost
hc=1; %holding cost
foc=0.2; %fixed ordering cost
pr=0.3;
gamma=0.2;
y=exp(gamma*hc*(x+a))*(1-((1-pr)/exp(gamma*hc))^(x+a+1))/(1-(1-pr)/exp(gamma*hc));
z=exp(sc*gamma)*(1-pr)^(x+a+1)/(1-exp(gamma*sc)*(1-pr));
t=exp(gamma*(oc*a+ foc*(a>0)))*pr*(y+z);
end