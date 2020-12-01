function [Hin,Hse,p] =Balance(FC,N,Clus_size,Clus_num)  
%% This function calculates the integration and segregation component
%% input: FC-- functional matrix, N-- number of ROI
%% Clus_size-- modular size in each level, Clus_num-- modular number; 
%% Clus_size and Clus_num are calcuated from the functuon 'Functional_HP' 
%% output: Hin--integration component, Hse-- segregation component, p-- correction fator of modular size
FC=(FC+FC')/2;
FC(FC<0)=0;
[FEC FE]=eig(FC);
FE(FE<0)=0;
FE=FE^2;%% using the squared Lambda
%%======================
p=zeros(1,N);
for i=1:length(find(Clus_num<1))
      p(i)=sum(abs(Clus_size{i}-1/Clus_num(i)))/N;%% modular size correction
end
HF=fliplr(diag(FE)').*Clus_num.*(1-p);
Hin=sum(HF(1))/N; %% integration component
Hse=sum(HF(2:N))/N;%% segregation component
end

