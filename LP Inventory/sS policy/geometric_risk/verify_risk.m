clear all;
oc=0.2;%purchase cost
sc=0.8; %shortage cost
hc=0.1; %holding cost
foc=0.2; %fixed ordering cost
pr=0.3;
gamma=0.2;


M=5;
z=1;
for a_0=0:M
    for a_1=0:M-1
        for a_2=0:M-2
            for a_3=0:M-3
                for a_4=0:M-4
                    A(z,:)= [ a_0 a_1 a_2 a_3 a_4 0];
                    z=z+1;
                end
            end
        end
    end
end

for x=0:M
    for a=0:M-x
        for z=1:length(A)
            f=0;
            for y=0:100
                d=exp((oc*a+ foc*(a>0) + hc*(x+a-y)*(x+a>y)+sc*(y-x-a)*(x+a<=y))*gamma)*geopdf(y,pr);
                e=verify_funct(max(x+a-y,0),A(z,max(x+a-y,0)+1));
                f=f+d*e;
            end
            c(z,a+1,x+1)=f;
        end
        
    end
end

for x=0:M
    disp('x = ')
    disp(x);
    [a,b]=min(c(:,:,x+1));
    a(a==0)=Inf;
    [e,d]=min(a);
    disp(' a = ');
    disp(d-1);
    disp('all same ');
    disp(b);
    disp('A = ')
    disp(A(b(1),:));
end

%display (c);
% c(c==0)=Inf;
% [f,g]=min(c');
%d=exp(oc*a+ foc*(a>0) + hc*(x+a-y)*(x+a>y)+sc*(y-x-a)*(x+a<=y))*geopdf(y,0.3);


% y=exp(gamma*hc*(x+a))*(1-((1-pr)/exp(gamma*hc))^(x+a+1))/(1-(1-pr)/exp(gamma*hc));
% z=exp(sc*gamma)*(1-pr)^(x+a+1)/(1-exp(gamma*sc)*(1-pr));
% c(x+1,a+1)=exp(gamma*(oc*a+ foc*(a>0)))*pr*(y+z);