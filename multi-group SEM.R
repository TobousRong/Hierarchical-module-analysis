library(lavaan)
library(psych)
library(semPlot)
library(car)
library(sirt)
library(dplyr)
library(ggplot2)


# set working directory
setwd("E:/Dynamical_SI/manuscript/SEM_Presentations")
dat1<-read.table("HCPS1200_behavioral_gfactor_modeling.csv", sep = ",",header = T)
head(dat1)

#z-score normalize the data columns
dat1z <- as.data.frame(scale(dat1[ ,4:21])) 
colnames(dat1z) = c("PMAT24_A_CRz", "VSPLOT_TCz", "ListSort_Unadjz", "PicSeq_Unadjz", "IWRD_TOTz", "PicVocab_Unadjz", 
                    "ReadEng_Unadjz", "CardSort_Unadjz", "Flanker_Unadjz", "ProcSpeed_Unadjz", "Language_Task_Story_Accz", 
                    "Language_Task_Math_Accz", "WM_Task_2bk_Place_Accz", "WM_Task_2bk_Tool_Accz", "WM_Task_2bk_Body_Accz", 
                    "Relational_Task_Match_Accz", "Relational_Task_Rel_Accz", "Loneliness_Unadjz")
head(dat1z)
dat1b <- cbind(dat1, dat1z)
head(dat1b)

# all.csv segregation.csv integration.csv
dat2<-read.table("all.csv", sep = ",",header = T)
head(dat2)
dat <- merge(dat1b, dat2, by="Subject")
head(dat)
##==================================
## different ranges for HB=0
##==============================
dat$Group <-numeric(991)
dat$Group <- dat$group3
table(dat$Group)

#####################################################################
# Multigroup modeling HB
#brain measures are HB, Hse and dse
#####################################################################

ModelMG <- 'g =~ 
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

PMAT24_A_CRz~0*1
PicVocab_Unadjz~0*1
PicSeq_Unadjz~0*1
CardSort_Unadjz~0*1

g~1
cry~1
mem~1
spd~1

g~~g
cry~~cry
mem~~mem
spd~~spd
'

fitMG <- sem(model = ModelMG, data = dat, missing='ML',orthogonal=TRUE, std.lv=F, group = "Group")
summary(fitMG, fit.measures=TRUE, standardized=TRUE)

# null model with constrain of equal group means
fitMGeM <- sem(model = ModelMG, data = dat, missing='ML',orthogonal=TRUE, std.lv=F, group = "Group",group.equal = c("means"))
summary(fitMGeM, fit.measures=TRUE, standardized=TRUE)

# test difference with null model
anova(fitMG, fitMGeM)

# visualize to SEM model structure with estimated parameters
semPaths(fitMG, intercept = FALSE, whatLabel = "est", layout='tree',
         edge.label.cex=0.8, label.cex=1.5, edge.width=1,
         sizeMan=7,residuals = FALSE)


