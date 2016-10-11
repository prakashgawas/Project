
set S;#set of states
set A;#set of actions
param Max_num_Actions;
param Max_num_States ;


param Time;
param gamma;#risk parameter
set T;
param Reward{S,A,T};
param Reward_1{S,A};
param Reward_T{S};

param alpha{S};
#param lambda; 

param Prob{S,S,A};
#param C{S,A};
#param B;

var y{T,S,A}>=0;
minimize cost: sum{s in S, a in A: s+a<=Max_num_States} exp(Reward[s,a,Time-1])* y[Time-1,s,a]*(sum{j in S} Prob[s,j,a] *exp(Reward_T[j]));

#Constraint 1
subject to con1 {s in S}: sum{ a in A: s+a<=Max_num_States} y[0,s,a] =alpha[s];

#Constraint 2
subject to con2 {s in S}:sum{a in A:s+a<=Max_num_States} y[1,s,a] -(sum{j in S, a in A:j+a <=Max_num_States}( exp(Reward_1[j,a]) * Prob[j,s,a]* y[0,j,a])) = 0;

#Constraint 3
subject to con3 {s in S, t in T: t<=Time-1 and t>=2}:sum{a in A:s+a<=Max_num_States} y[t,s,a] 
- (sum{j in S, a in A:j+a<=Max_num_States}( exp(Reward[j,a,t]) * Prob[j,s,a]* y[t-1,j,a])) = 0;

