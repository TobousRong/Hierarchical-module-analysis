library(lavaan)
library(psych)
library(semPlot)
library(car)
library(sirt)
library(dplyr)


# set working directory
setwd("E:/Dynamical_SI/manuscript/SEM_Presentations")

dat1<-read.table("HCPS1200_behavioral_gfactor_modeling.csv", sep = ",",header = T)
head(dat1)

#z-score normalize the data columns
dat1z <- as.data.frame(scale(dat1[ ,4:20])) 
colnames(dat1z) = c("PMAT24_A_CRz", "VSPLOT_TCz", "ListSort_Unadjz", "PicSeq_Unadjz", "IWRD_TOTz", "PicVocab_Unadjz", 
                    "ReadEng_Unadjz", "CardSort_Unadjz", "Flanker_Unadjz", "ProcSpeed_Unadjz", "Language_Task_Story_Accz", 
                    "Language_Task_Math_Accz", "WM_Task_2bk_Place_Accz", "WM_Task_2bk_Tool_Accz", "WM_Task_2bk_Body_Accz", 
                    "Relational_Task_Match_Accz", "Relational_Task_Rel_Accz")
head(dat1z)
dat1b <- cbind(dat1, dat1z)
head(dat1b)

# all.csv segregation.csv integration.csv
dat2<-read.table("all.csv", sep = ",",header = T)

dat <- merge(dat1b, dat2, by="Subject")

#####################################################################
#Modified Dubois Model
#This model tests the linear relationships between brain measures (i.e., HB, Hse and Dse) and 
#cognitive abilities (e.g., the latent variables, g, cry, mem and spd).
#This model was developed by Andrea Hildebrandt, and the test was performed by Rong Wang and Mianxin Liu.
#####################################################################

Model <- 'g =~ 
PMAT24_A_CRz + VSPLOT_TCz +
#cry
PicVocab_Unadjz  + ReadEng_Unadjz + 
#mem
PicSeq_Unadjz + IWRD_TOTz +
#speed
CardSort_Unadjz + Flanker_Unadjz + ProcSpeed_Unadjz 

cry =~ b*PicVocab_Unadjz  + b*ReadEng_Unadjz 
mem =~ c*PicSeq_Unadjz + c*IWRD_TOTz 
spd =~ CardSort_Unadjz + Flanker_Unadjz + ProcSpeed_Unadjz

g ~ HB
cry ~  HB
mem ~  HB
spd ~ HB
'
fit <- sem(model = Model, data = dat, missing='ML',orthogonal=TRUE, std.lv=TRUE)
summary(fit, fit.measures=TRUE, standardized=TRUE)

# visualize to SEM model structure with estimated parameters
semPaths(fit, intercept = FALSE, whatLabel = "est", layout='tree',
         edge.label.cex=0.8, label.cex=1.5, edge.width=1,
         sizeMan=7,residuals = FALSE)

