function [B] = Structural_network(A,N)
A=-A;
for i=1:N
    A(i,i)=-sum(A(i,:));
end
B=A/max(eig(A));
end

