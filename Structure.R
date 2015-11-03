############## Initialization ##############
setwd("~/Desktop/MFE minishop")
require('data.table')
require('reshape2')
require('zoo')
# require('xlsx')

############## Read data ################


############## calcualte factors ##############
# Demean + Standardize + Windsorize
# mean shinkage? 
# Technical 	factors: Momentum + BaB + CDS + Mean reversion + residual risk  
# Fundamental 	factors: B/M + C/P + Sales growth + E/P + recommendation

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


