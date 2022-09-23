library(dplyr)
library(xts)
library(vars)
library(forecast)
library(tseries)

# Download minute-by-minute data about the price of Bitcoin (btc) and of the 
# altcoin Litecoin (ltc)
btc.minute <- read.csv2("https://www.cryptodatadownload.com/cdd/Binance_BTCUSDT_minute.csv", 
                        skip = 1, sep = ",")
ltc.minute <- read.csv2("https://www.cryptodatadownload.com/cdd/Binance_LTCUSDT_minute.csv",
                        skip = 1, sep = ",")

# define a 3-week time period for training the model with, filtering the data 
# and creating time series objects
train.start.time <- "2021-10-11 00:00:00"
train.end.time <- "2021-11-01 00:00:00"

btc.minute.train <- btc.minute %>% 
  filter(date >= train.start.time) %>%
  filter(date < train.end.time)
xts.btc.train <- xts(as.numeric(btc.minute.train$open), 
                     as.POSIXct(btc.minute.train$date))

ltc.minute.train <- ltc.minute %>% 
  filter(date >= train.start.time) %>%
  filter(date < train.end.time)
xts.ltc.train <- xts(as.numeric(ltc.minute.train$open), 
                     as.POSIXct(ltc.minute.train$date))

# plot the two time series, both starting at 100 percent
xts.btc.train.scaled <- xts.btc.train / as.numeric(xts.btc.train[1]) * 100
xts.ltc.train.scaled <- xts.ltc.train / as.numeric(xts.ltc.train[1]) * 100
plot(merge(xts.btc.train.scaled, xts.ltc.train.scaled), 
     main = "Development in percent", 
     lty=c(1, 1), 
     lwd=c(2, 2), 
     col=1:2)
addLegend("topleft", 
          on=1, 
          legend.names = c("BTC", "LTC"), 
          lty=c(1, 1), 
          lwd=c(2, 2),
          col=1:2)
# --> the high correlation is clearly visible

# testing for stationarity for both time series
adf.test(xts.btc.train)
adf.test(xts.ltc.train)
# --> Both time series are not stationary

# Transforming the time series to continuous returns
xts.btc.train.returns <- na.omit(diff(log(xts.btc.train)))
xts.ltc.train.returns <- na.omit(diff(log(xts.ltc.train)))

# testing for stationarity for both time series
adf.test(xts.btc.train.returns)
adf.test(xts.ltc.train.returns)
# --> Both time series are stationary now

# Determine the order of the VAR-model
lagselect <- VARselect(cbind(xts.btc.train.returns,xts.ltc.train.returns), 
                       lag.max = 60, 
                       type = "const")
lagselect$selection
# --> According to the Akaike information criterion, the order 22 is suggested

# Fitting the VAR-model
var.fit <- VAR(cbind(xts.btc.train.returns,xts.ltc.train.returns), 
               p = 22, 
               type = "const")
summary(var.fit)

# To compare models, the RSME (root-mean-square-error) is calculated
sqrt(mean(var.fit$varresult$xts.ltc.train.returns$residuals^2))

# to get a feeling of the fit, a arbitrarily chosen time window is compared with
# the actual values. 
plot(cbind(var.fit$varresult$xts.ltc.train.returns$fitted.values[1000:1100],
           xts.ltc.train.returns[1000:1100]), 
     type = "l", 
     legend.loc = 'bottomright',
     main = "")

# IRF to visualize the impact of Bitcoin on Litecoin
ltc.irf <- irf(var.fit , impulse="xts.btc.train.returns", 
               response = "xts.ltc.train.returns", n.ahead = 30, 
               boot=TRUE)
plot(ltc.irf, main = "Shock from Bitcoin",
     ylab = "ltc returns")

#Check Autocorrelation
serial <- serial.test(var.fit, lags.pt = 25, type= "PT.asymptotic")
serial

#Heteroscedasticity
arch <- arch.test(var.fit)
arch

# Granger Causality test using robust standard errors because of heteroscedasticity
granger <- causality(var.fit , cause="xts.btc.train.returns", vcov.=vcovHC(var.fit))
granger


# In order to validate the var-model, other models are fitted and compared to 
# the var-model in terms of RMSE. 

# To test, if the inclusion of Bitcoin time series really adds value to the 
# model, an arima-model is fitted, using only the Litecoin time series itself. 
arima.fit <- auto.arima(xts.ltc.train.returns, max.order = 60)
summary(arima.fit)
# --> The RMSE is higher than from the var-model, therefore this arima-model can
#     be rejected. 

# Further, the var-model is challenged by an arimax-model, including as well the 
# time series of Bitcoin.
arimax.fit <- auto.arima(xts.ltc.train.returns, 
                         max.order = 60, 
                         xreg = xts.btc.train.returns)
summary(arimax.fit) 
# --> In regards to RMSE, this model is clearly better than the var-model. 
#     However, this model is not valid, as it is using the Bitcoin return from 
#     the same time step as it is predicting. From a predictive perspective, 
#     this is not feasible, as the future Bitcoin return is not known. 
#     Therefore this model is rejected. 

# To correct the invalidity of the last model, the time series of Bitcoin 
# returns is shifted by one timestep, and the arimax-model is applied again. 
arimax.lagged.fit <- auto.arima(xts.ltc.train.returns[-1], 
                                max.order = 60, 
                                xreg = xts.ltc.train.returns[1:(length(xts.ltc.train.returns) - 1)])
summary(arimax.lagged.fit) 
# --> Still, according to the RMSE, the var-model is more accurate. 


