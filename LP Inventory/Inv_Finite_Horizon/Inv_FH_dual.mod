set S;
set A;
param N;
param M;
param Time=3;
set T;
param P{S,S,A};
param r{S,A,T};
param q{S,A};
param alpha{S};
#param lambda;
#param C{S,A};
#param B;
var y{T,S,A} >=0;
maximize cost: sum{s in S,t in T,a in A:t<=Time-1 and q[s,a]>=1} r[s,a,t]*y[t,s,a];
s.t. con1{s in S}:sum{a in A:q[s,a]>=1}y[0,s,a]=alpha[s];
s.t. con2{s in S,t in T:t<=Time-1 and t>=1}:sum{a in A:q[s,a]>=1}y[t,s,a]=sum{j in S,a in A:q[j,a]>=1}P[j,s,a]*y[t-1,j,a];
#Terminal reward is zero
