function [Clus_num,Clus_size,FC] = Functional_HP(data,N)
%%This function performs the hierarchical module partition of FC networks using the NSP method.
%%Input: data--original FC matrix; N-- number of ROI
%%Output: Clus_num---modular number in each level, normalized to [0 1]; Clus_size-- the size (e.g., ROI number) of each module in each level;
%%FC-- the optimized FC network after the hierarchical modular partition, the regions are reordered. 
data(data<0)=0; %% This method requires the complete positive connectivity in FC matrix, that generates the global integration in the first level. 
data=(data+data')/2;
[FEC FE]=eig(data);
FEC=fliplr(FEC);
H1_1=find(FEC(:,1)<0);
H1_2=find(FEC(:,1)>=0);
%%%%==============================================================
Clus_num=[1];%% The first level has one module and corresponds to the global integration.  
Clus_size=cell(N,1);
for mode=2:N
    x=find(FEC(:,mode)>=0);
    y=find(FEC(:,mode)<0);
    H={};
    for j=1:2*Clus_num(mode-1)
        H{j}=eval(['H',num2str(mode-1),'_',num2str(j)]);%% assume the number of cluster in j-1 level is 2^(mode-1)
    end
    id = cellfun('length',H);%% length of each cluster in H
    H(id==0)=[];%% delete the cluster with 0 size
    id(id==0)=[];
    Clus_size{mode-1}=id;
    Clus_num=[Clus_num,length(H)];%% number of cluster
    k=1; 
    for j=1:2:2*Clus_num(mode)%modular number
         Positive_Node=intersect(H{k},x);
         Negtive_Node=intersect(H{k},y);         
         k=k+1;
         eval(['H',num2str(mode),'_',num2str(j+1), '=', 'Positive_Node', ';'])
         eval(['H',num2str(mode),'_',num2str(j), '=', 'Negtive_Node', ';'])
    end  
    for j=1:2*Clus_num(mode-1)
         eval(['clear',' H',num2str(mode-1),'_',num2str(j),'']);
    end
     Z=[];
    if (Clus_num(end)==N || mode == N)
        for j=1:2*Clus_num(mode)
            Z=[Z;eval(['H',num2str(mode),'_',num2str(j)])];
        end
        break;
    end
end
Clus_num(1)=[];
Clus_num=[Clus_num/N,ones(1,N-length(Clus_num))];
FC=zeros(N,N);
for i=1:N
    for j=1:N
        FC(i,j)=data(Z(i),Z(j));
    end
end
end
