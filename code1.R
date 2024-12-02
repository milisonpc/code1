##How to determine the relative importance  of correlated traits on the chance to win a contest? A stochastic model of agonistic interactions

#packs 
library(faux)
library(dplyr)
library(tidyverse)
library(boot)
library(sciplot)
library(ggplot2)
library(ggthemes)
library(devtools)

#######################################################################

  ##Create function to simulate with our parameters

simulation = function (cor.weapon.body, weapon.imp){
  
  ##calculate remaining parameter
  body.imp = 1 - weapon.imp
  
  ##create empty vectors for loop
  mean.body.win = c()
  mean.body.los = c()
  mean.weap.win = c()
  mean.weap.los = c()
  body.diff = c()
  weap.diff = c()
  
  for(m in 1:1000){
    
    ##set groups with parameter correlation
    group.1 = rnorm_multi(n = 100, vars = 2, mu =c(0,0), sd = c(1,1), r = cor.weapon.body, varnames = c ("body.1", "weap.1"))
    group.2 = rnorm_multi(n = 100, vars = 2, mu = c(0,0), sd =c(1,1), r = cor.weapon.body, varnames = c ("body.2", "weap.2"))
    
    
    ##organize the two groups in a data frame
     data.1 = data.frame(list(group.1, group.2))
     colnames(data.1)=c("body.1", "weap.1","body.2", "weap.2")
    
    
    ##calculate fighting capacity (FC) according to the formula: relative importance of trait one times trait one plus relative importance of trait two times trait two. 
    data.1$FC.1 = weapon.imp * data.1$weap.1 + body.imp * data.1$body.1
    data.1$FC.2 = weapon.imp * data.1$weap.2 + body.imp * data.1$body.2
    
    ##calculate the difference in fighting capacity 
    data.1$FCdiff = data.1$FC.1 - data.1$FC.2
    ##generate a chance of winning. count stands for continuous
    data.1$prob.win.cont = inv.logit(data.1$FCdiff * 0.1)
    ##determine winners and losers (1 or 0). here we turn the continuous value into a binary one
    data.1$prob.win = rbinom (nrow(data.1),1,data.1$prob.win.cont)
    
    ##Register winner and loser traits
    ##BODY
    #winner body
    data.1$win.body = ifelse (data.1$prob.win == 1 , data.1$body.1, data.1$body.2)
    #loser body
    data.1$los.body = ifelse (data.1$win.body == data.1$body.1, data.1$body.2, data.1$body.1)
    ##WEAPON
    #winner weapon
    data.1$win.weap = ifelse (data.1$prob.win == 1 , data.1$weap.1, data.1$weap.2)
    #loser weapon
    data.1$los.weap = ifelse (data.1$win.weap == data.1$weap.1 , data.1$weap.2, data.1$weap.1)
    
    ##calculate the difference between winners and losers for body size
    data.1$diff.body = data.1$win.body - data.1$los.body
    ##calculate the difference between winners and losers for weapon size
    data.1$diff.weap = data.1$win.weap - data.1$los.weap
    
    
    ##register means
    mean.body.win[m] = mean(data.1$win.body)
    mean.body.los[m] = mean(data.1$los.body)
    mean.weap.win[m] =  mean(data.1$win.weap)
    mean.weap.los[m] =  mean(data.1$los.weap)
    body.diff[m] = mean(data.1$diff.body)
    weap.diff[m] = mean(data.1$diff.weap)
  }
  
 
  ##calculate mean of means
  mean.mean.body = mean(body.diff)
  mean.mean.weap = mean(weap.diff)
  ##calculate confidence interval
  body.mean.CI = 1.96*sd(body.diff)/sqrt(999)
  weap.mean.CI = 1.96*sd(weap.diff)/sqrt(999)
  
  
  ##organize the return of function
  data.2 = c(mean.mean.body, mean.mean.weap,
          body.mean.CI,  weap.mean.CI)
  return(data.2)
}

##Applying function

##create empty vector for loop
func.values = c()

##Set correlation interval to be applyed as parameter
for(i in 80:99){
  
  ##input final parameter, weapon importance. Perform function
  func.values = append(func.values, simulation(i/100, 0.5))
  
}

##Organize data for figure. 

#Number 20 is for correlation interval 80-99. Repeat for data frame
treatments = rep(c('mean.mean.body', 'mean.mean.weap', 
                  'body.mean.CI',  'weap.mean.CI'), 20)

##sort the correlation values four times for data frame
correlations = sort(rep(c(80:99),4))

##crate dafa frame
data.mix = as.data.frame(list(func.values, treatments, correlations))
colnames(data.mix) = c('func.values', 'treatments', 'correlations')
data.fig = data.mix[data.mix$treatments == c('mean.mean.body','mean.mean.weap'),]
CIs = data.mix[data.mix$treatments == c('body.mean.CI','weap.mean.CI'),]
data.fig$CIs = CIs$func.values
colnames(data.fig) = c('means','treatments','correlations','CIs')


##Generate figure. #Line calculated as linear model

#tiff('Fig.E50.tif',w = 1200,h = 1200, compression = 'lzw',res = 300)

par(mar = c(4,4,4,4))
ggplot(data.fig, aes(x = correlations, y = means, col = treatments)) +
  geom_point(size = 2)+
  ylim (0.075,0.135)+
  geom_errorbar(aes(ymin = means - CIs, ymax = means + CIs), width = 2, position = position_dodge(width = 0.02))+
  labs(x = "Correlation", y = "MMD", color = "Treatments")+
  theme_classic()+
  geom_smooth(aes(group = treatments),method = "lm", se = FALSE)+
  scale_colour_manual(values = c("#FFB000", "#4B038E"))+
  theme(legend.position = "none",axis.title = element_text(face = "bold", size = 10),axis.text = element_text(size = 10, face = "bold", color = "black")) +
  scale_x_continuous(breaks = c(80, 85, 90, 95, 100), 
                     labels = c("0.80", "0.85", "0.90", "0.79", "1.0")
  )

#dev.off ()



