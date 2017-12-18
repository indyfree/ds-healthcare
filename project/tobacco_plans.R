benefits <- read.csv(file = file.path("data", "benefits2016.csv"), header = T, stringsAsFactors = F)
plans <- read.csv(file = file.path("data", "PlanAttributes.csv"), header = T, stringsAsFactors = F)
rates <- read.csv(file = file.path("data", "rates2016.csv"), header = T, stringsAsFactors = F)

# 1. Find benefits that are related to tobacco use
tobacco_benefits <- subset(benefits, grepl("Abortion", benefits$BenefitName))
head(tobacco_benefits)

# 2. Find plans that cover these benefits
dim(plans)
tobacco_plans <- subset(plans, plans$StandardComponentId %in% tobacco_benefits$StandardComponentId)
dim(tobacco_plans)

# 3. Compare plans payments within the states
dim(rates)
tobacco_rates <- subset(rates, rates$PlanId %in% tobacco_plans$StandardComponentId)
dim(tobacco_rates)

tobacco_rates <- tobacco_rates[,c('StateCode', 'IndividualRate')]
mean_tobacco_rates <- aggregate(tobacco_rates, list(tobacco_rates$StateCode), mean)
print(mean_tobacco_rates)

# Compare mean rates of plans including tobacco with overall mean
mean_rates <- rates[,c('StateCode', 'IndividualRate')]
mean_rates <- aggregate(mean_rates, list(mean_rates$StateCode), mean)
print(mean_rates)
print(mean_tobacco_rates$IndividualRate - mean_rates$IndividualRate)

