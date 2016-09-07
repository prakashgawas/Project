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
var v{S,T};
maximize cost: sum{s in S} alpha[s]*v[s,0];
s.t. con1{s in S,t in T, a in A:t<=Time-2 and q[s,a]>=1}: v[s,t]- sum{j in S}P[s,j,a]*v[j,t+1]<=r[s,a,t];
s.t. con2{s in S, a in A:q[s,a]>=1}:v[s,Time-1]<= r[s,a,Time-1];
#Terminal reward is zero
