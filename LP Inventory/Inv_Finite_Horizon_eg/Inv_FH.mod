set S;#set of states
set A;#set of actions
param Max_Actions;
param Max_States;
param Time=3;
set T;#set of time periods
param Prob{S,S,A};#transition probaility matrix
param Reward{S,A,T};#reward
param ind{S,A};#indicator for feasible action in a given state
param alpha{S};#initial distribution

var v{S,T};#variable for value
maximize cost: sum{s in S} alpha[s]*v[s,0];
s.t. con1{s in S,t in T, a in A:t<=Time-2 and ind[s,a]>=1}: v[s,t]- sum{j in S}Prob[s,j,a]*v[j,t+1]<=Reward[s,a,t];
s.t. con2{s in S, a in A:q[s,a]>=1}:v[s,Time-1]<= Reward[s,a,Time-1];
#Terminal reward is zero
