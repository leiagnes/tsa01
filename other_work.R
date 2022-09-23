library(dplyr)
library(xts)
library(vars)
library(forecast)
library(tseries)
library(ggplot2)

########### Using other altcoins at other time window ########### 

btc.minute <- read.csv2("https://www.cryptodatadownload.com/cdd/Binance_BTCUSDT_minute.csv", 
                        skip = 1, sep = ",")
eth.minute <- read.csv2("https://www.cryptodatadownload.com/cdd/Binance_ETHUSDT_minute.csv",
                        skip = 1, sep = ",")
bnb.minute <- read.csv2("https://www.cryptodatadownload.com/cdd/Binance_BNBUSDT_minute.csv",
                        skip = 1, sep = ",")
ltc.minute <- read.csv2("https://www.cryptodatadownload.com/cdd/Binance_LTCUSDT_minute.csv",
                        skip = 1, sep = ",")
dash.minute <- read.csv2("https://www.cryptodatadownload.com/cdd/Binance_DASHUSDT_minute.csv",
                        skip = 1, sep = ",")

train.start.time <- "2021-11-01 00:00:00"
train.end.time <- "2021-11-22 00:00:00"
test.end.time <- "2021-11-29 00:00:00"

btc.minute.train <- btc.minute %>% 
  filter(date >= train.start.time) %>%
  filter(date < train.end.time)
xts.btc.train <- xts(as.numeric(btc.minute.train$open), 
                     as.POSIXct(btc.minute.train$date))

eth.minute.train <- eth.minute %>% 
  filter(date >= train.start.time) %>%
  filter(date < train.end.time)
xts.eth.train <- xts(as.numeric(eth.minute.train$open), 
                     as.POSIXct(eth.minute.train$date))

bnb.minute.train <- bnb.minute %>% 
  filter(date >= train.start.time) %>%
  filter(date < train.end.time)
xts.bnb.train <- xts(as.numeric(bnb.minute.train$open), 
                     as.POSIXct(bnb.minute.train$date))

ltc.minute.train <- ltc.minute %>% 
  filter(date >= train.start.time) %>%
  filter(date < train.end.time)
xts.ltc.train <- xts(as.numeric(ltc.minute.train$open), 
                     as.POSIXct(ltc.minute.train$date))

dash.minute.train <- dash.minute %>% 
  filter(date >= train.start.time) %>%
  filter(date < train.end.time)
xts.dash.train <- xts(as.numeric(dash.minute.train$open), 
                     as.POSIXct(dash.minute.train$date))

xts.btc.train.scaled <- xts.btc.train / as.numeric(xts.btc.train[1]) * 100
xts.eth.train.scaled <- xts.eth.train / as.numeric(xts.eth.train[1]) * 100
xts.bnb.train.scaled <- xts.bnb.train / as.numeric(xts.bnb.train[1]) * 100
xts.ltc.train.scaled <- xts.ltc.train / as.numeric(xts.ltc.train[1]) * 100
xts.dash.train.scaled <- xts.dash.train / as.numeric(xts.dash.train[1]) * 100
plot(merge(xts.btc.train.scaled, xts.eth.train.scaled, xts.bnb.train.scaled, 
           xts.ltc.train.scaled, xts.dash.train.scaled), 
     main = "Development in percent", 
     lty=c(1, 1), 
     lwd=c(2, 2), 
     col=1:5)
addLegend("topleft", 
          on=1, 
          legend.names = c("BTC", "ETH", "BNB", "LTC", "DASH"), 
          lty=c(1, 1), 
          lwd=c(2, 2),
          col=1:5)

# Transforming the time series to continuous returns
xts.btc.train.returns <- na.omit(diff(log(xts.btc.train)))
xts.eth.train.returns <- na.omit(diff(log(xts.eth.train)))
xts.bnb.train.returns <- na.omit(diff(log(xts.bnb.train)))
xts.ltc.train.returns <- na.omit(diff(log(xts.ltc.train)))
xts.dash.train.returns <- na.omit(diff(log(xts.dash.train)))

# testing for stationarity for all time series
adf.test(xts.btc.train.returns)
adf.test(xts.eth.train.returns)
adf.test(xts.bnb.train.returns)
adf.test(xts.ltc.train.returns)
adf.test(xts.dash.train.returns)

#ETH
# Determine the order of the VAR-model
lagselect <- VARselect(cbind(xts.btc.train.returns,xts.eth.train.returns), 
                       lag.max = 60, 
                       type = "const")
lagselect$selection
# --> According to the Akaike information criterion, the order 29 is suggested

# Fitting the VAR-model
var.fit.eth <- VAR(cbind(xts.btc.train.returns,xts.eth.train.returns), 
               p = 29, 
               type = "const")
summary(var.fit.eth)

# BNB
# Determine the order of the VAR-model
lagselect <- VARselect(cbind(xts.btc.train.returns,xts.bnb.train.returns), 
                       lag.max = 60, 
                       type = "const")
lagselect$selection
# --> According to the Akaike information criterion, the order 34 is suggested

# Fitting the VAR-model
var.fit.bnb <- VAR(cbind(xts.btc.train.returns,xts.bnb.train.returns), 
               p = 34, 
               type = "const")
summary(var.fit.bnb)

# LTC
# Determine the order of the VAR-model
lagselect <- VARselect(cbind(xts.btc.train.returns,xts.ltc.train.returns), 
                       lag.max = 60, 
                       type = "const")
lagselect$selection
# --> According to the Akaike information criterion, the order 24 is suggested

# Fitting the VAR-model
var.fit.ltc <- VAR(cbind(xts.btc.train.returns,xts.ltc.train.returns), 
               p = 24, 
               type = "const")
summary(var.fit.ltc)

# DASH
# Determine the order of the VAR-model
lagselect <- VARselect(cbind(xts.btc.train.returns,xts.dash.train.returns), 
                       lag.max = 60, 
                       type = "const")
lagselect$selection
# --> According to the Akaike information criterion, the order 29 is suggested

# Fitting the VAR-model
var.fit.dash <- VAR(cbind(xts.btc.train.returns,xts.ltc.train.returns), 
               p = 29, 
               type = "const")
summary(var.fit.dash)


# IRF to visualize the impact of Bitcoin on the altcoins
ltc.irf <- irf(var.fit.eth, impulse="xts.btc.train.returns", 
               response = "xts.eth.train.returns", n.ahead = 30, 
               boot=TRUE)
plot(ltc.irf, main = "Shock from Bitcoin",
     ylab = "ltc returns")
ltc.irf <- irf(var.fit.bnb, impulse="xts.btc.train.returns", 
               response = "xts.bnb.train.returns", n.ahead = 30, 
               boot=TRUE)
plot(ltc.irf, main = "Shock from Bitcoin",
     ylab = "ltc returns")
ltc.irf <- irf(var.fit.ltc, impulse="xts.btc.train.returns", 
               response = "xts.ltc.train.returns", n.ahead = 30, 
               boot=TRUE)
plot(ltc.irf, main = "Shock from Bitcoin",
     ylab = "ltc returns")
ltc.irf <- irf(var.fit.dash, impulse="xts.btc.train.returns", 
               response = "xts.dash.train.returns", n.ahead = 30, 
               boot=TRUE)
plot(ltc.irf, main = "Shock from Bitcoin",
     ylab = "ltc returns")

# Granger Causality test using robust standard errors because of heteroscedasticity
granger.eth <- causality(var.fit.eth, cause="xts.btc.train.returns", vcov.=vcovHC(var.fit.eth))
granger.eth
granger.bnb <- causality(var.fit.bnb, cause="xts.btc.train.returns", vcov.=vcovHC(var.fit.bnb))
granger.bnb
granger.ltc <- causality(var.fit.ltc, cause="xts.btc.train.returns", vcov.=vcovHC(var.fit.ltc))
granger.ltc
granger.dash <- causality(var.fit.dash, cause="xts.btc.train.returns", vcov.=vcovHC(var.fit.dash))
granger.dash


########### Doing further residual analysis ########### 

#Serial Correlation
serial.10min <- serial.test(var.fit.ltc, type= "PT.asymptotic" )
serial.10min

#Heteroscedasticity
arch.10min <- arch.test(var.fit.ltc)
arch.10min

#Normal Distribution of the Residuals
norm.10min <- normality.test(var.fit.ltc)
norm.10min

#Testing for structural Breaks in the Residuals
stability.10min <- stability(var.fit.ltc, type = "OLS-CUSUM")
plot(stability.10min)


########### Using 10-Minute timesteps ########### 

#Take only the data every 10 mins
start.time <- "2021-09-05 00:00:00"
end.time <- "2021-12-11 00:00:00"

bnb.minute <- bnb.minute %>% 
  filter(date >= start.time) %>%
  filter(date <= end.time)

btc.minute <- btc.minute %>% 
  filter(date >= start.time) %>%
  filter(date <= end.time)

btc.10min <- btc.minute %>% slice(which(row_number() %% 10 == 1))
bnb.10min <- bnb.minute %>% slice(which(row_number() %% 10 == 1))

xts.btc.10min <- xts(as.numeric(btc.10min$open), as.POSIXct(btc.10min$date))
xts.bnb.10min <- xts(as.numeric(bnb.10min$open), as.POSIXct(bnb.10min$date))

# Testing for stationarity for both time series
adf.test(xts.btc.10min)
adf.test(xts.bnb.10min)

xts.btc.10minute <- na.omit(diff(log(xts.btc.10min)))
xts.bnb.10minute <- na.omit(diff(log(xts.bnb.10min)))

adf.test(xts.btc.10minute)
adf.test(xts.bnb.10minute)

# Finding the optimal lag
lagselect1 <- VARselect(cbind(xts.btc.10minute,xts.bnb.10minute), lag.max = 6, type = "const")
lagselect1$selection

# Apply VAR model to 10 mins data 
VAR.bnb.10min <- VAR(cbind(xts.btc.10minute,xts.bnb.10minute), p = 5, type = "const")
summary(VAR.bnb.10min)

# Granger Causality 
Granger.bitcoin.10min <- causality(VAR.bnb.10min , cause="xts.btc.10minute")
Granger.bitcoin.10min

Granger.bnb.10min <- causality(VAR.bnb.10min , cause="xts.bnb.10minute")
Granger.bnb.10min


########### Trading-Simulation ########### 

lagselect1 <- VARselect(cbind(xts.btc.train.returns,xts.ltc.train.returns), lag.max = 60, type = "const")
lagselect1$selection

var.fit <- VAR(cbind(xts.btc.train.returns,xts.ltc.train.returns), p = 24, type = "const")
summary(var.fit)

buy.limit <- quantile(var.fit$varresult$xts.ltc.train.returns$fitted.values, 0.995)

ltc.minute.test <- ltc.minute %>% 
  filter(date > train.start.time) %>%
  filter(date < test.end.time)
xts.ltc.test <- xts(as.numeric(ltc.minute.test$open), as.POSIXct(ltc.minute.test$date))

btc.minute.test <- btc.minute %>% 
  filter(date > train.start.time) %>%
  filter(date < test.end.time)
xts.btc.test <- xts(as.numeric(btc.minute.test$open), as.POSIXct(btc.minute.test$date))

xts.btc.test.returns <- na.omit(diff(log(xts.btc.test)))
xts.ltc.test.returns <- na.omit(diff(log(xts.ltc.test)))

profit <- 0.0
full.invest.profit <- 0.0
no.of.trades <- 0
invested = FALSE

# trading simulator
for(t in 1:(length(xts.ltc.test.returns) - length(xts.ltc.train.returns))){
  print(index(xts.ltc.test.returns[t + length(xts.ltc.train.returns)]))
  var.fit.loop <- VAR(cbind(xts.btc.test.returns[1:(t + length(xts.ltc.train.returns) -1)],xts.ltc.test.returns[1:(t + length(xts.ltc.train.returns) -1)]), p = 24, type = "const")
  pred.loop <- predict(var.fit.loop, n.ahead = 1)$fcst$xts.ltc.test.returns[1]
  eff.loop <- as.numeric(xts.ltc.test.returns[(t + length(xts.ltc.train.returns))])
  full.invest.profit <-  full.invest.profit + eff.loop
  if (pred.loop > buy.limit){
    if (!invested){
      print("Buy!")
      no.of.trades <- no.of.trades + 1
    }
    invested = TRUE
  } else {
    if (invested){
      print("Sell!")
      no.of.trades <- no.of.trades + 1
    }
    invested = FALSE
  } 
  if (invested){
    profit <- profit + eff.loop
  }
  print(paste0("total profit: ", profit))
  print(paste0("full-invest profit: ", full.invest.profit))
  print(paste0("number of trades: ", no.of.trades))
}