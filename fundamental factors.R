############## Initialization ##############
setwd("~/Desktop/MFE minishop")
require('data.table')
require('reshape2')
require('zoo')
require('dplyr')
require('lubridate')
# require('xlsx')

############## Read data ################
Data_Fundamentals = fread('Data/fundamental.csv')
Data_IBES = fread('Data/ibes.csv')
Data_CRSP = fread('Data/CRSP.csv')
 
############## Remove unused fields ################
Data_Fundamentals$LPERMCO = NULL 
Data_Fundamentals$indfmt = NULL
Data_Fundamentals$consol = NULL
Data_Fundamentals$popsrc = NULL
Data_Fundamentals$datafmt = NULL
Data_Fundamentals$curcdq = NULL
Data_Fundamentals$fqtr = NULL
Data_Fundamentals$fyr = NULL
Data_Fundamentals$costat = NULL

## Compustat Variables, Quarterly:                                              ##
## 1  ATQ       = Assets - Total                                                ##
## 2  ACTQ      = Current Assets - Total                                        ##
## 3  CAPXY     = Capital Expenditures                                          ##
## 4  CEQQ      = Common/Ordinary Equity - Total                                ##
## 5  CHQ       = Cash                                                          ##
## 6  COGSQ     = Cost of Goods Sold                                            ##
## 7  DPY       = Depreciation and Amortization - Total                         ##
## 8  CSHOQ     = Common Shares Outstanding                                     ##
## 9  EPSFXQ    = Earnings Per Share (Diluted) - Excluding Extraordinary items  ## 
## 10 GPQ       = Gross Profit (Loss)                                           ##
## 11 INTPNY    = Interest Paid - Net                                           ##
## 12 LTQ       = Liabilities - Total                                           ##
## 13 LCTQ      = Current Liabilities - Total                                   ##
## 14 NIQ       = Net Income (Loss)                                             ##
## 15 NIY       = Net Income (Loss)                                             ##
## 16 OANCFY    = Operating Activities - Net Cash Flow                          ##
## 17 PSTKQ     = Preferred/Preference Stock (Capital) - Total                  ##
## 18 PSTKLQ    = Preferred Stock Liquidating Value                             ##
## 19 PSTKRQ    = Preferred Stock Redemption Value                              ##
## 20 REQ       = Retained Earnings                                             ##
## 21 REVTQ     = Revenue - Total                                               ##
## 22 SALEQ     = Sales/Turnover (Net)                                          ##
## 23 SEQQ      = Stockholders' Equity - Total                                  ##
## 24 TXDITCQ   = Deferred Taxes and Investment Tax Credit                      ##

## PS           = Preferred Stock                                               ##
## SE           = Stockholders Equity                                           ##
## BookEquity   = Book value of the equity                                      ## 

#
coalesce <- function(...) {
  Reduce(function(x, y) {
    i = which(is.na(x));
    x[i] = y[i];
    x},
    list(...))
};

############## Convert Quarterly to Daily ################
Data_CRSP$date = ymd(Data_CRSP$date)
# Dates = Data_CRSP %>% select(PERMNO, date)

# test = Data_Fundamentals %>% filter(LPERMNO == 54594)
# test$next_date = lead(test$datadate,1)
# test = test %>% rename(PERMNO = LPERMNO, date = datadate)
# test$date = ymd(test$date)
# test$next_date = ymd(test$next_date)
# quarter2daily <- function(data){
#   temp = test[1,]
#   temp$dummy = 1
#   temp2 = as.data.frame(seq(as.Date(temp$date),as.Date(temp$next_date), "day"))
#   colnames(temp2) = {'date'}
#   temp2$dummy = 1
#   
#   temp$date = NULL
#   temp$next_date = NULL
#   out = full_join(temp2, temp, by = 'dummy')
#   out$dummy = NULL
#   out$date = ymd(out$date)
#   out = inner_join(out, Dates, by = c('PERMNO', 'date'))
# }


Data_Fundamentals$datadate = ymd(Data_Fundamentals$datadate)
Data_Fundamentals$next_date = lead(Data_Fundamentals$datadate,1)

Data_Fundamentals = Data_Fundamentals %>% rename(PERMNO = LPERMNO, date = datadate)
# Data_Fundamentals = full_join(Data_Fundamentals, Dates, by = c('PERMNO', 'date'));
# Data_Fundamentals = Data_Fundamentals %>% arrange(date, PERMNO)

# my_merge <- function(CRSP){
#   temp = Data_Fundamentals %>% filter(PERMNO == CRSP$PERMNO, date < CRSP$date)
#   temp = arrange(temp, desc(date))
#   temp = temp[1,]
#   temp$date = NULL
#   temp = inner_join(CRSP, temp, by = 'PERMNO')
# }

merged_data = list()
for (i in 1:ceiling(nrow(Data_CRSP)/100000) + 1)
{  
  temp = left_join(Data_CRSP[((i-1)*100000 + 1): min((i*100000),nrow(Data_CRSP)), ], Data_Fundamentals, by = c('PERMNO'))
  temp = as.data.table(temp)
  merged_data = rbind_list(merged_data, temp[,.SD[.N],by = .(PERMNO, date.x)])
}

# merged_data = list()
# system.time(for (i in 1000:2000)
# {
#   merged_data = rbind_list(merged_data, my_merge(Data_CRSP[i,]))
# }
# )
# 
# test = apply(Data_CRSP[1000:2000,], 1, my_merge)

############## Read my CCM ################
# merged_data = fread('Data/my CCM.csv')
# For each date

today = ymd('20100101')
data_start_date = ymd((year(today) - 4) * 10000 + 101)

############## BE/ME ################
Data_Fundamentals = Data_Fundamentals %>% 
  mutate(ps = coalesce(pstkrq, pstkq, 0),
         se = coalesce(seqq, sum(ceqq, pstkq), atq - ltq))
Data_Fundamentals$txditcq[is.na(Data_Fundamentals$txditcq)] <- 0
Data_Fundamentals <- Data_Fundamentals %>% mutate(BookEquity = se + txditcq - ps)
Data_Fundamentals$BookEquity[Data_Fundamentals$BookEquity < 0] <- NA


BEME_price = Data_CRSP %>% select(PERMNO, date, RET, PRC, VOL) %>%
  filter(date >= data_start_date & date < today)
BEME_fundamental = Data_Fundamentals %>% select(PERMNO, date, next_date, BookEquity) %>%
  filter(date >= data_start_date & date < today)

############## C/P ################
FCF = 

############## Sales Growth ################
SG = 

############## E/P ################

############## Recommendation change ################

############## Write ################