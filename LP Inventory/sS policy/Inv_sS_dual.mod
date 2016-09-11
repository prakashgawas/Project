
set S;#set of states
set A;#set of actions
param Max_num_Actions;
param Max_num_States ;
param Time;
set T;#set of time periods
param Prob{S,S,A};#transition probaility matrix
param Reward{S,A,T};#reward
param ind{S,A};#indicator for feasible action in a given state
param alpha{S};#initial distribution

var y{T,S,A} >=0; #variable- total joint probability

minimize cost: sum{s in S,t in T,a in A:t<=Time-1 and s+a<=20} Reward[s,a,t]*y[t,s,a];
s.t. con1{s in S}:sum{a in A:s+a<=20}y[0,s,a]=alpha[s];
s.t. con2{s in S,t in T:t<=Time-1 and t>=1}:sum{a in A:s+a<=20}y[t,s,a]=sum{j in S,a in A}Prob[j,s,a]*y[t-1,j,a];
#Terminal reward is zero
