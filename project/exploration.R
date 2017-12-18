# Data exploration Scripts and first Visualisations

# Set working directory to current file location (requires Rstudio as an IDE)
rates <- read.csv(file = file.path("data", "rates2016.csv"), header = T, stringsAsFactors = F)
benefits <- read.csv(file = file.path("data", "benefits2016.csv"), header = T, stringsAsFactors = F)
networks <- read.csv(file = file.path("data", "networks2016.csv"), header = T, stringsAsFactors = F)
plans <- read.csv(file = file.path("data", "PlanAttributes.csv"), header = T, stringsAsFactors = F)
plans <- plans[plans$BusinessYear == "2016", ]


summary(rates)
head(rates, 20)
head(rates$PlanId)
head(rates$IssuerId)
paste("Rates:", length(unique(rates$IssuerId)), "different issuers (ids)")
paste("Rates:", length(unique(rates$PlanId)), "different plans (ids)")
summary(rates$IndividualRate) # Strange value for some rates >9000 --> exclude from analysis

summary(benefits)
head(benefits$BenefitName, 50)
head(benefits$PlanId)
head(benefits$IssuerId)
paste("Benefits:", length(unique(benefits$IssuerId)), "different issuers (ids)")
paste("Benefits:", length(unique(benefits$PlanId)), "different plans (ids)")

networks <- networks[, c('NetworkId', 'StateCode', 'NetworkName', 'IssuerId')]
summary(networks)
head(networks,20)
paste("Networks:", length(unique(networks$NetworkId)), "different network (ids)")
paste("Networks:", length(unique(networks$IssuerId)), "different issuers (ids)")
paste("Networks:", length(networks$NetworkId), "number of networks in dataset (why doubles)")

# Why double entries with same id and same name? ('Ameritas PPO Dental Network') --> IssuerId different
# Why does IssuerId matters within NetWorks?
aln001 <- networks[networks$NetworkId == 'ALN001',]
head(aln001, 50)

summary(plans)
head(plans$PlanId, 50)
head(plans$NetworkId, 50)
head(plans$IssuerId, 50)
head(plans$BenefitPackageId, 50)
head(plans$StandardComponentId, 50)
paste("Plans:", length(unique(plans$PlanId)), "different plans")
paste("Plans:", length(unique(plans$StandardComponentId)), "different (standard component) plans")
paste("Plans:", length(unique(plans$NetworkId)), "number of networks associated")
paste("Plans:", length(unique(plans$IssuerId)), "different issuers (ids)")
