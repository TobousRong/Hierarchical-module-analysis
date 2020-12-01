clc;clear;close all
%% Static analysis: This function calculates the calibrated Hin, Hse and HB from fMRI time series 
Subj =textread('E:\Data\HCP\Subj_list.txt','%s');
N_sub=length(Subj);N=360;
Long_fmri=[];IN=[];IM=[];
%mypool=parpool('local',24,'IdleTimeout',240);
parfor sub=1:N_sub
    path=strcat('E:\Data\HCP\fMRI\',Subj(sub),'_ROI_ts.mat');
    MRI=load(char(path));
    fmri=[];
    for i=1:4
        fmri=[fmri;MRI.ROI_ts{1,i}']; 
    end
    Long_fmri=[Long_fmri;fmri];
    %% individual static FC matrix and its hierarchical module partition
    FC=corr(fmri);
    [Clus_num,Clus_size,mFC] = Functional_HP(FC,N);
    parsave(Subj(sub),Clus_size,Clus_num,'_Clus.mat')
    parsave(Subj(sub),FC,mFC,'_FC.mat')
    %% individual static integration component Hin and segragtion component Hse
    [Hin,Hse] =Balance(FC,N,Clus_size,Clus_num);
    IN=[IN;Hin];IM=[IM;Hse];
end
%% stable FC matrix for long-enough fMRI length
sFC=corr(Long_fmri);
parsave('origin',IN,IM,'_HB.mat')
%% Calibrating the individual static segregation and integration component
[Hin,Hse] = Stable_correct(sFC,IN,IM,N);
parsave('corrected',Hin,Hse,'_HB.mat')


