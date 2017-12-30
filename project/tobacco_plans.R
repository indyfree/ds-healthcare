library('ggplot2') # visualization

benefits <- read.csv(file = file.path("data", "benefits2016.csv"), header = T, stringsAsFactors = F)
plans <- read.csv(file = file.path("data", "PlanAttributes.csv"), header = T, stringsAsFactors = F)
rates <- read.csv(file = file.path("data", "rates2016.csv"), header = T, stringsAsFactors = F)
pol <- read.csv(file = file.path("data", "political_orientation.csv"), header = T, stringsAsFactors = F)

# 1. Find Abortion Benefits
abortion_benefits <- subset(benefits, grepl("Abortion for Which Public", benefits$BenefitName)) 

# 2. Find plans that cover these benefits
abortion_plans <- subset(plans, plans$PlanId %in% abortion_benefits$PlanId)

# 3. Count Abortion Plans per State
states <- aggregate(abortion_plans$PlanId, list(abortion_plans$StateCode), length)
colnames(states) <- c('State', 'NumAbortionPlans')

# 4. Find Ratio of Plans that cover Abortion
num_total_plans <- aggregate(plans$PlanId, list(plans$StateCode), length)
colnames(num_total_plans) <- c('State', 'NumPlans')
num_total_plans <- subset(num_total_plans,num_total_plans$State %in% states$State)
states$RelAbortionPlans <- states$NumAbortionPlans/num_total_plans$NumPlans

# 4. Merge political orientation (Label)
states <- merge(states, pol, by = 'State')
# ggplot(data=d, aes(x=State, y=Ratio, fill=factor(Color))) +
#   geom_bar(stat="identity", position=position_dodge())

# 5. Compute Mean Rates for Abortion Plans
abortion_rates <- subset(rates, rates$PlanId %in% abortion_plans$StandardComponentId)
abortion_rates <- abortion_rates[,c('StateCode', 'IndividualRate')]
mean_abortion_rates <- aggregate(abortion_rates, list(abortion_rates$StateCode), mean)
states$MeanAbortionRates <- mean_abortion_rates$IndividualRate

# 6. ExtraPay = Difference between mean rate of all planes and the ones with abortion benefits
mean_rates <- rates[,c('StateCode', 'IndividualRate')]
mean_rates <- aggregate(mean_rates, list(mean_rates$StateCode), mean)
states$ExtraPay <- (mean_abortion_rates$IndividualRate - mean_rates$IndividualRate)

ggplot(data=d, aes(x=State, y=ExtraPay, fill=factor(Color))) +
  geom_bar(stat="identity", position=position_dodge())
