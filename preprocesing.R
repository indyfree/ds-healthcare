library('dplyr') # data manipulation

#
# Data Cleaning and Feature Engineering
#

get_state_features <- function(planes, rates, benefits) {
  # 1. Get cleaned Abortion Benefits
  abortion_benefits <- get_abortion_benefits(benefits)

  # 2. Find plans that cover Abortion Benefits per State
  abortion_plans <- subset(plans, plans$PlanId %in% abortion_benefits$PlanId)
  abortion_plans <- abortion_plans[c('PlanId', 'StandardComponentId', 'StateCode')]
 
  # 3. Find Amount and Ratio of Plans that cover Abortion
  states <- find_state_coverage(plans, abortion_plans) 
  
  # 4. Compute Additional Features: Mean Rates, Extra pay
  states <- merge(states, compute_rates(rates, abortion_plans), by='State', all.x=T)
  
  # 5. Compute Mean CoPays and CoIns of abortion benefits
  states <- merge(states, compute_copays(abortion_benefits), by='State', all.x=T)
  
  # 6. Fill Missing Values with 0 (States who dont have coverage)
  states[is.na(states)] <- 0
  
  # 8. TODO: Mean MOOP for abortion plans
  #abortion_plans <- abortion_plans[,'StateCode', 'MOOP']
  
  return(states)
}

compute_copays <- function(abortion_benefits) {
  mean_copays <- aggregate(abortion_benefits, list(abortion_benefits$StateCode), FUN = mean)
  mean_copays <- mean_copays[c('Group.1', 'Coins', 'Copay')] #Eventually extend to include more features
  colnames(mean_copays) <- c('State', 'MeanCoins', 'MeanCopay')
  return(mean_copays)
}

find_state_coverage <- function(all_plans, abortion_plans) {
  covered_states <- aggregate(abortion_plans$PlanId, list(abortion_plans$StateCode), length)
  colnames(covered_states) <- c('State', 'NumAbortionPlans')
  not_covered <- unique(plans$StateCode)[!(unique(plans$StateCode) %in% covered_states$State)]
  not_covered <- data.frame(not_covered, 0)
  colnames(not_covered) <- c('State', 'NumAbortionPlans')
  states <- rbind(covered_states, not_covered)
  states <- arrange(states, State)
  
  num_total_plans <- aggregate(plans$PlanId, list(plans$StateCode), length)
  colnames(num_total_plans) <- c('State', 'NumPlans')
  num_total_plans <- subset(num_total_plans,num_total_plans$State %in% states$State)
  states$PercentageAbortionPlans <- states$NumAbortionPlans/num_total_plans$NumPlans
  return(states)
}

compute_rates <- function(rates, abortion_plans) {
  # Mean Rate for abortion plans by state
  abortion_rates <- subset(rates, rates$PlanId %in% abortion_plans$StandardComponentId)
  abortion_rates <- abortion_rates[,c('StateCode', 'IndividualRate')]
  mean_abortion_rates <- aggregate(abortion_rates, list(abortion_rates$StateCode), FUN = mean)
  
  # Mean Rate for all plans by state
  mean_rates <- rates[c('StateCode', 'IndividualRate')]
  mean_rates <- aggregate(mean_rates, list(rates$StateCode), FUN = mean)
  
  # Extra Pay for abortion plans than mean rate
  abortion_rates <- merge(mean_abortion_rates, mean_rates, by='Group.1')
  abortion_rates <- abortion_rates[c('Group.1', 'IndividualRate.x', 'IndividualRate.y')]
  abortion_rates$IndividualRate.y <- abortion_rates$IndividualRate.x - abortion_rates$IndividualRate.y
  colnames(abortion_rates) <- c('State', 'MeanRate', 'ExtraPay')
  
  return(abortion_rates)
}
  
get_abortion_benefits <- function(benefits) {
  abortion_benefits <- subset(benefits, grepl("Abortion for Which Public", benefits$BenefitName)) 
  abortion_benefits <- subset(abortion_benefits, abortion_benefits$IsCovered == 'Covered') # Only select benefits that cover Abortion
  
  # Convert to machine readible input
  abortion_benefits$CoinsAfterDeduct <- grepl("after deduct", abortion_benefits$CoinsInnTier1)
  abortion_benefits$Coins <- gsub('% Coins.*', '', abortion_benefits$CoinsInnTier1)
  abortion_benefits$Coins <- as.numeric(abortion_benefits$Coins)/100
  
  abortion_benefits$CoinsOutofNet <- gsub('% Coins.*', '', abortion_benefits$CoinsOutofNet)
  abortion_benefits$CoinsOutofNet <- as.numeric(abortion_benefits$CoinsOutofNet)/100
  
  abortion_benefits$CopayAfterDeduct <- grepl("after deduct", abortion_benefits$CopayInnTier1)
  abortion_benefits$Copay <- gsub(' Copay.*', '', abortion_benefits$CopayInnTier1)
  abortion_benefits$Copay <- gsub('\\$', '', abortion_benefits$Copay)
  abortion_benefits$Copay <- as.numeric(abortion_benefits$Copay)
  
  abortion_benefits$IsExclFromOonMOOP[which(abortion_benefits$IsExclFromOonMOOP == 'Yes')] <- TRUE
  abortion_benefits$IsExclFromOonMOOP[which(abortion_benefits$IsExclFromOonMOOP != TRUE)] <- FALSE
  abortion_benefits$IsExclFromOonMOOP <- as.logical(abortion_benefits$IsExclFromOonMOOP)
  
  abortion_benefits$QuantLimitOnSvc[which(abortion_benefits$QuantLimitOnSvc == 'Yes')] <- TRUE
  abortion_benefits$QuantLimitOnSvc[which(abortion_benefits$QuantLimitOnSvc != TRUE)] <- FALSE
  abortion_benefits$QuantLimitOnSvc <- as.logical(abortion_benefits$QuantLimitOnSvc)
  
  # Fill in Missing Values
  abortion_benefits$QuantLimitOnSvc[is.na(abortion_benefits$QuantLimitOnSvc)] <- FALSE
  abortion_benefits$Coins[is.na(abortion_benefits$Coins)] <- 0
  abortion_benefits$CoinsOutofNet[is.na(abortion_benefits$CoinsOutofNet)] <- 0
  abortion_benefits$Copay[is.na(abortion_benefits$Copay)] <- 0
  
  abortion_benefits <- abortion_benefits[c('PlanId', 'StateCode', 'Coins', 'CoinsAfterDeduct', 'CoinsOutofNet', 'Copay', 'CopayAfterDeduct', 'IsExclFromOonMOOP', 'QuantLimitOnSvc')]
  
  return(abortion_benefits)
}
