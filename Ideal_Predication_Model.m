function [Q,C] =Ideal_Predication_Model(A,g,N)
     Q=(eye(N)+g*A)^-1;   
     Q=Q*Q';
for i=1:N
    for j=1:N
        C(i,j)=Q(i,j)/sqrt(Q(i,i)*Q(j,j));
    end
end
end

