function [Hin] = individual_correction(IN,R_IN)
%% This function calibrates the dynamic Hin and Hse of each individual to their static values that have been calibrated.
%% input: IN-- dynamic integration component (or segregation component) for a subject;
%% R_IN-- the calibrated static integration component (or segregation component) for the subject;
%% output: calibrated integration component (or segregation component) for the subject;
p=(mean(IN)-R_IN)/mean(IN);
Hin=IN*(1-p);
end

