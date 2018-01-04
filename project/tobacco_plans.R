library('ggplot2') # visualization
library('dplyr') # data manipulation

benefits <- read.csv(file = file.path("data", "benefits2016.csv"), header = T, na.strings = c("", " ", NA), stringsAsFactors = F)
plans <- read.csv(file = file.path("data", "PlanAttributes.csv"), header = T, na.strings = c("", " ", NA), stringsAsFactors = F)
rates <- read.csv(file = file.path("data", "rates2016.csv"), header = T, na.strings = c("", " ", NA), stringsAsFactors = F)
pol <- read.csv(file = file.path("data", "political_orientation.csv"), header = T, na.strings = c("", " ", NA), stringsAsFactors = F)

#
# 1. Find Abortion Benefits and prepare data
#
abortion_benefits <- subset(benefits, grepl("Abortion for Which Public", benefits$BenefitName)) 
abortion_benefits <- subset(abortion_benefits, abortion_benefits$IsCovered == 'Covered') # Only select benefits that cover Abortion

# Select Interesting Features to look at
features <- c("PlanId", "CoinsInnTier1", "CoinsOutofNet", "CopayInnTier1", "IsExclFromOonMOOP", "QuantLimitOnSvc")
abortion_benefits <- abortion_benefits[,features]
# Factorize categorical columns
categorical_cols <- sapply(abortion_benefits, is.character)
abortion_benefits[,categorical_cols] <- lapply(abortion_benefits[categorical_cols], factor)

# Convert to machine readible numbers
abortion_benefits$CoinsAfterDeduct <- grepl("after deduct", abortion_benefits$CoinsInnTier1)
abortion_benefits$Coins <- gsub('% Coins.*', '', abortion_benefits$CoinsInnTier1)
abortion_benefits$Coins <- as.numeric(abortion_benefits$Coins)/100

abortion_benefits$CoinsOutofNet <- gsub('% Coins.*', '', abortion_benefits$CoinsOutofNet)
abortion_benefits$CoinsOutofNet <- as.numeric(abortion_benefits$CoinsOutofNet)/100

abortion_benefits$CopayAfterDeduct <- grepl("after deduct", abortion_benefits$CopayInnTier1)
abortion_benefits$Copay <- gsub(' Copay.*', '', abortion_benefits$CopayInnTier1)
abortion_benefits$Copay <- gsub('\\$', '', abortion_benefits$Copay)
abortion_benefits$Copay <- as.numeric(abortion_benefits$Copay)

# Fill in Missing Values
abortion_benefits$QuantLimitOnSvc[is.na(abortion_benefits$QuantLimitOnSvc)] <- 'No'
abortion_benefits$Coins[is.na(abortion_benefits$Coins)] <- 0
abortion_benefits$CoinsOutofNet[is.na(abortion_benefits$CoinsOutofNet)] <- 0
abortion_benefits$Copay[is.na(abortion_benefits$Copay)] <- 0

# 2. Find plans that cover these Abortion Benefits per State
abortion_plans <- subset(plans, plans$PlanId %in% abortion_benefits$PlanId)

covered_states <- aggregate(abortion_plans$PlanId, list(abortion_plans$StateCode), length)
colnames(covered_states) <- c('State', 'NumAbortionPlans')
not_covered <- unique(plans$StateCode)[!(unique(plans$StateCode) %in% covered_states$State)]
not_covered <- data.frame(not_covered, 0)
colnames(not_covered) <- c('State', 'NumAbortionPlans')
states <- rbind(covered_states, not_covered)
states <- arrange(states, State)

# 4. Find Ratio of Plans that cover Abortion
num_total_plans <- aggregate(plans$PlanId, list(plans$StateCode), length)
colnames(num_total_plans) <- c('State', 'NumPlans')
num_total_plans <- subset(num_total_plans,num_total_plans$State %in% states$State)
states$PercentageAbortionPlans <- states$NumAbortionPlans/num_total_plans$NumPlans

# 4. Merge political orientation (Label)
states <- merge(states, pol, by = 'State')
states$Color <- as.factor(states$Color)
ggplot(data=states, aes(x=State, y=NumAbortionPlans, fill=factor(Color))) +
  geom_bar(stat="identity", position=position_dodge())

# 5. Compute Mean Rates for Abortion Plans
abortion_rates <- subset(rates, rates$PlanId %in% abortion_plans$StandardComponentId)
abortion_rates <- abortion_rates[,c('StateCode', 'IndividualRate')]
mean_abortion_rates <- aggregate(abortion_rates, list(abortion_rates$StateCode), mean)
states$MeanAbortionPlanRates <- mean_abortion_rates$IndividualRate

# 6. ExtraPay = Difference between mean rate of all planes and the ones with abortion benefits
mean_rates <- rates[,c('StateCode', 'IndividualRate')]
mean_rates <- aggregate(mean_rates, list(mean_rates$StateCode), mean)
states$ExtraPay <- (mean_abortion_rates$IndividualRate - mean_rates$IndividualRate)

# 7. TODO: Compute Mean Copay for benefits

# 8. Mean MOOP for abortion plans
abortion_plans <- abortion_plans[,'StateCode', 'MOOP']

ggplot(abortion_plans, aes(x = abortion_plans$moop)) + geom_histogram()



ggplot(data=d, aes(x=State, y=ExtraPay, fill=factor(Color))) +
  geom_bar(stat="identity", position=position_dodge())
