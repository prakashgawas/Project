
set S;#set of states
set A;#set of actions
param Max_num_Actions;
param Max_num_States ;
set J;

param Time;
param gamma;
set T;
param Reward{S,A,T};

param alpha{S};
param lambda; 
param si{T,J};
param Prob{S,J,T,S,J,A};
#param C{S,A};
#param B;
var y{S,J,T,A} >=0;
var y1{S,T,A};
minimize cost: sum{s1 in S, l1 in J, a in A: s1+a<=Max_num_States}
 exp(gamma*Reward[s1,a,Time-1])* (sum{s2 in S,l2 in J} Prob[s2,l2,Time-1,s1,l1,a]*exp(gamma*Reward[s2,a,Time-1]) * y[s1,l1,Time-1,a]) ;

#Constraint 1
subject to con1 {s in S,l1 in J}: sum{ a in A: s+a<=Max_num_States} y[s,l1,0,a] =alpha[s];

#Constraint 2
subject to con2 {s2 in S,l2 in J, t in T: t!=0 }:
sum{a in A :s2+a<=Max_num_States} y[s2,l2,t,a] - (sum{s1 in S,l1 in J, a in A:s1+a<=Max_num_States} ( exp( gamma*Reward[s1,a,t]) * Prob[s2,l2,t-1,s1,l1,a]* y[s1,l1,t-1,a])) = 0;

#Constraint 3
subject to con3 {s in S,t in T,a in A:s+a<=Max_num_States}: y1[s,t,a] = (sum{l2 in J} y[s,l2,t,a]);
