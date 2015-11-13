############## Initialization ##############
setwd("~/Desktop/MFE minishop")
require('data.table')
require('reshape2')
require('zoo')
require('dplyr')
# require('xlsx')

############## Read data ################
Data_Fundamentals = fread('Data/fundamental.csv')
Data_IBES = fread('Data/ibes.csv')
Data_constitute = fread('Data/Consititute.csv')
Data_CCM_CRSP = fread('Data/CRSP2.csv')
Data_CRSP = fread('Data/CRSP.csv')
 
############## calcualte factors ##############
Demean <- function(x){
  return(x - mean(x, na.rm = T))
}
Standardize <- function(x){
  return(x/sd(x, na.rm = T))
}
Windsorize <- function(x){
  x[x > 3] = 3
  x[x < -3] = -3
  return(x)
}
DSW <- function(x){
  # Demean + Standardize + Windsorize
  return(Windsorize(Standardize(Demean(x))))
}

# Demean + Standardize + Windsorize
# mean shinkage? 
# Technical 	factors: Momentum + BaB + CDS + Mean reversion + residual risk  
# Fundamental factors: B/M + C/P + Sales growth + E/P + recommendation

# FCF = EBIT * (1 - tax) + Depreation and Amortization - change in Net working capital - capital expenditure
# net working capital = current asset - current liability
# FCF = CFO - capital expenditure
# CFO = Net income + Depreation and Amortization + Other non-cash change(income) - change in net working capital

############## calculate covariance matrix ##############
# cov matrix shinkage 

############## transaction cost ##############
# Simple t-cost model = commission + 1 bps + median bid-ask spread / 2

############## constrians ##############
# Trade size and position
# Portfolio diversification, number of stocks
# 

############## optimize weight ##############
# Quadratic programming 

############## rebalance ##############
# Monthly rebalancing 

############## backtest ##############


############## Analysis ##############
# Factor model decomposition 

############## reporting ##############
# Inlcude today's trades and P&L
# Cumulative P&L
# Current total positions 
# output in csv or xlsx files 


