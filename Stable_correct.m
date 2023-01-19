function [Hin,Hse] = Stable_correct(sFC,IN,IM,N)
%% input: sFC-- stable FC matrix from long-enough fMRI time; IN-- individual static integration component;
%% IM-- individual static segregation component; N-- number of ROI
%% output: Hin-- calibrated individual integration component; Hse-- calibrated individual segregation component
[Clus_num,Clus_size,FC] = Functional_HP(sFC,N);
[R_IN,R_IM] =Balance(sFC,N,Clus_size,Clus_num);%% integration component R_IN and segregation component R_IM for stable Fc matrix.  
%% Proportional calibration scheme. Since our Gaussian model has proved a theoretical functional balance,
%% the mean individual integration and segregation components were calibrated to the equal value, R_IN.
p=(mean(IM)-R_IM)/mean(IM);%%
Hse=IM*(1-p);
p=(mean(IN)-R_IN)/mean(IN);
Hin=IN*(1-p);
end


