
set S;#set of states
set A;#set of actions

param Max_num_Actions;
param Max_num_States ;

param Time;
set T;#set of time periods

param Prob{S,S,A};#transition probaility matrix

param Reward{S,A,T};
param Reward_1{S,A};
param Reward_T{S};

param alpha{S};#initial distribution

var y{T,S,A} >=0; #variable- total joint probability

minimize cost: sum {s in S, a in A:s+a<=Max_num_States}Reward_1[s,a]*y[0,s,a] + sum{s in S,t in T,a in A:t<=Time-1 and s+a<=Max_num_States and t>=1} Reward[s,a,t]*y[t,s,a] + sum{a in A, s in S, j in S:s+a<=Max_num_States}Reward_T[j]*y[Time-1,s,a]*Prob[s,j,a];

s.t. con1{s in S}:sum{a in A:s+a<=Max_num_States}y[0,s,a]=alpha[s];

s.t. con2{s in S,t in T:t<=Time-1 and t>=1}:sum{a in A:s+a<=Max_num_States}y[t,s,a]=sum{j in S,a in A}Prob[j,s,a]*y[t-1,j,a];
#Terminal reward is zero
