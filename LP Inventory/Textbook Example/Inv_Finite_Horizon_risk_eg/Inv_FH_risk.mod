set S;
set A;
set J;
param N;
param M;
param Time;
param gamma;
set T;
param r{S,A,T};
param q{S,A};
param alpha{S};
param lambda;
param si{T,J};
param Prob{S,J,T,S,J,A};
#param C{S,A};
#param B;
var y{S,J,T,A} >=0;
var y1{S,T,A};
minimize cost: sum{s1 in S, l1 in J, a in A: s1+a<=3}
 exp(gamma*r[s1,a,Time-1])* (sum{s2 in S,l2 in J} Prob[s2,l2,Time-1,s1,l1,a]*exp(gamma*r[s2,a,Time-1]) * y[s1,l1,Time-1,a]) ;

#Constraint 1
subject to con1 {s in S,l1 in J}: sum{ a in A: s+a<=3} y[s,l1,0,a] =alpha[s];

#Constraint 2
subject to con2 {s2 in S,l2 in J, t in T: t!=0 }:
sum{a in A :s2+a<=3} y[s2,l2,t,a] - (sum{s1 in S,l1 in J, a in A:s1+a<=3} ( exp( gamma*r[s1,a,t]) * Prob[s2,l2,t-1,s1,l1,a]* y[s1,l1,t-1,a])) = 0;

#Constraint 3
subject to con3 {s in S,t in T,a in A:s+a<=3}: y1[s,t,a] = (sum{l2 in J} y[s,l2,t,a]);
