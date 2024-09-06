# setwd("C:/RRUN/TechEval/Technical evaluation")

library(gsheet) 
library(dplyr)
library(ggplot2)

data <- gsheet2tbl('https://drive.google.com/open?id=1jKe6kIGEuqyF8KANVzRhDCAGa7v8uM1m')

data$sex=as.factor(data$sex)
data <- data %>% filter(!is.na(sex))
XX <- colnames(data)
plots =list()
for (i in 4:25){
  pp <- ggplot(data, aes_string(x="Time_point", y=XX[[i]], group = "Sample_ID", color = "sex")) + 
    stat_summary(aes(group = sex), geom = "point", fun.y = mean,  shape = 17, size = 3, position = position_dodge(width = 0.2)) + 
    stat_summary(aes(group = sex), geom = "line", fun.y = mean, position = position_dodge(width = 0.2)) +
    stat_summary(aes(group = sex), geom = "errorbar", fun.data = mean_se,position = position_dodge(width = 0.2), width=.2)
  plots[[i]]=pp
}

for (i in 4:25) {
  files = paste("plot_", XX[[i]], ".tiff", sep="")
  tiff(files, width=1800, height=1200,res=300)
  print(plots[[i]])
  dev.off()
}

