#setwd("/Users/balachandran/RESEARCH/LANL/WEBSITE/ver_xdz/")
#cvd_double = read.csv("9Nov18_MoS2_Synthesis.csv") 
data.training = read.csv("9Nov18_MoS2_Synthesis_v3.csv", header=T)
model.training= read.csv("9Nov18_MoS2_Synthesis_v2.csv", header=T)[-29,]
mos2_full_virtual2 = read.delim("23Dec18_MoS2_Synthesis_Virtual2_RFOREST_pred.dat", header=T)
growth.data = mos2_full_virtual2
load("svc.rbf.mos2.mono.rda")

col_labels = c("Title", "Substrate", "Thickness",  "Mo_T", 
               "Raman Peaks Dist.", "S_T", "Highest Growth T", "Growth T", "Growth P", "Will Form?")

options = c("Title", "Substrate", "Thickness", "Raman Peaks Dist.", "Mo Precursor Temp.", 
            "Substrate Precursor Temp.", "Highest Growth Temp.", "Growth Time", "Growth Pressure", "Will Form?")
Method = c()
Prediction = c()