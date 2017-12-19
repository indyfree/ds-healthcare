library('ggplot2') # visualization

benefits <- read.csv(file = file.path("data", "benefits2016.csv"), header = T, stringsAsFactors = F)
plans <- read.csv(file = file.path("data", "PlanAttributes.csv"), header = T, stringsAsFactors = F)
rates <- read.csv(file = file.path("data", "rates2016.csv"), header = T, stringsAsFactors = F)
pol <- read.csv(file = file.path("data", "political_orientation.csv"), header = T, stringsAsFactors = F)

# 1. Find Abortion Benefits
print(length(unique(benefits$StateCode)))
abortion_benefits <- subset(benefits, grepl("Abortion for Which Public", benefits$BenefitName)) 
a <- aggregate(abortion_benefits$BenefitName, list(abortion_benefits$StateCode), length)

# 2. Find plans that cover these benefits
abortion_plans <- subset(plans, plans$PlanId %in% abortion_benefits$PlanId)
b <- aggregate(abortion_plans$PlanId, list(abortion_plans$StateCode), length)

# 3. Find Ration of Plans that cover Abortion
c <- aggregate(plans$PlanId, list(plans$StateCode), length)
d <- merge(b,c,by="Group.1")
colnames(d) <- c('State', 'AbortionPlans', 'TotalPlans')
d$Ratio <- d$AbortionPlans/d$TotalPlans

# 4. Merge political orientation
d <- merge(d, pol, by = 'State')
ggplot(data=d, aes(x=State, y=Ratio, fill=factor(Color))) +
  geom_bar(stat="identity", position=position_dodge())


# 5. Compare plans payments within the states, mean vs. abortion
abortion_rates <- subset(rates, rates$PlanId %in% abortion_plans$StandardComponentId)

abortion_rates <- abortion_rates[,c('StateCode', 'IndividualRate')]
mean_abortion_rates <- aggregate(abortion_rates, list(abortion_rates$StateCode), mean)

mean_rates <- rates[,c('StateCode', 'IndividualRate')]
mean_rates <- aggregate(mean_rates, list(mean_rates$StateCode), mean)
d$ExtraPay <- (mean_abortion_rates$IndividualRate - mean_rates$IndividualRate)

ggplot(data=d, aes(x=State, y=ExtraPay, fill=factor(Color))) +
  geom_bar(stat="identity", position=position_dodge())