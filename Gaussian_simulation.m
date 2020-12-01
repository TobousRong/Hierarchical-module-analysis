clc;clear;close all
%% This function generates the simulated FC matrix from Gaussian model with different couplings g.
%% The segregation and integration components of simulated FC matrices can be obtained with the functions 'Functional_HP' and 'Balance'.
Subj =textread('E:\Data\HCP\Subj_list.txt','%s');
N_sub=length(Subj);N=360;
for g=[10:5:150]%% couplings g
    for sub=1:N_sub
           Sc_data=strcat('E:\Data\HCP\DTI\', Subj(sub),'SC_360.txt');
           SC=load(char(Sc_data));
           SC=(SC+SC')/2;%% brain structural connectivity matrix
           H= Structural_network(SC,N);%% Laplace matrix
           [Q,FC] =Ideal_Predication_Model(H,g,N);%%
           FC=(FC+FC')/2;%% FC matrix
           filename =strcat('G',num2str(g),'_',Subj(sub),'_FC.mat');
           save(char(filename),'FC')
    end
end