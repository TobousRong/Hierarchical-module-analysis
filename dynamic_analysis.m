clc;clear;close all
%% This function generates the temporally dynamic Hin and Hse, and then calibrates them within individuals. 
Subj =textread('E:\Data\HCP\Subj_list.txt','%s');
N_sub=length(Subj);N=360;Total=1200;width=83;
%%%===============================================
% mypool=parpool('local',24,'IdleTimeout',240);
S=load('corrected_HB.mat');
Z=[];
for sub=1:N_sub;
    path=strcat('E:\Data\HCP\fMRI\',Subj(sub),'_ROI_ts.mat');
    MRI=load(char(path));
    BOLD=[];
    for s=1:4
        BOLD=[BOLD,MRI.ROI_ts{1,s}];
    end   
    IN=[];IM=[];
    parfor t=1:Total*4-width
        subdata=BOLD(:,t:t+width);
        FC=corr(subdata');
        [Clus_num,Clus_size] = Functional_HP(FC,N);
        [Hin,Hse] =Balance(FC,N,Clus_size,Clus_num);
        IN=[IN;Hin];IM=[IM;Hse];
    end
    [Hin] = individual_correction(IN,S.x(sub));
    [Hse] = individual_correction(IM,S.y(sub));
    [Fre,DIn,DSe,In_time,Se_time] = Flexible(Hin-Hse,0.72)%% calculating dynamic measures
    Z=[Z;Fre,DIn,DSe,In_time,Se_time];
end
