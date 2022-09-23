# Synchrony between Bitcoin and other cryptocurrencies
Authors: Agnes Lei, Leo Rettich
<br><br>
<b>1. Introduction</b><br><br>
When speaking of cryptocurrencies, bitcoin is the first name coming up in most people’s head. 
The open-source software of Bitcoin, the most well-known and oldest cryptocurrency, was released in 2009. 
Since then, over 1000 cryptocurrencies and cryptoassets have been invented. 
<br>Some of the major ones include Litecoin, Ethereum, ZCash, XRT etc. (Tredinnick, 2021). 
Since bitcoin has such a dominant role in the cryptocurrency market, it is worth exploring its influence on the price movement of other cryptocurrencies, 
often called altcoins. This project aims to investigate the correlation between the time series of bitcoin and other cryptocurrencies by 
answering the following questions:<br>
- Does the movement of Bitcoin have a significant influence on other cryptocurrencies?<br>
- Is there a time lag between a spike/dip on Bitcoin and a similar response on other cryptocurrencies? 
  If yes, how big is the time lag? Could this time lag be used to derive a trading strategy?<br>
- Can we use the bitcoin price to predict prices of other cryptocurrencies?<br>

As cryptocurrencies are known to follow each other very directly, these questions are to be answered under consideration of a short time horizon.

<b>2. Existing literature</b><br><br>
In terms of existing literature, there are many papers describing the high correlation between Bitcoin and many altcoins. 
As an example, Lahajnar and Rožanec (2020) are confirming at least a moderate correlation between most of the important cryptocurrencies 
and a rather stronger correlation between Bitcoin and the others. As a further example, Kumar and Ajaz (2019) are providing evidence that 
many cryptocurrency price movements are driven by the price movement of Bitcoin. Lahajnar and Rožanec (2020) as well as Kumar and Ajaz (2019) 
are using daily returns for their correlation analysis.<br>
If the scope of research is narrowed down to a shorter time horizon shorter than a day, there is only little existing literature left. 
One of the rare articles is the one from Mensi et al. (2021), investigating and proving relationships between different cryptocurrencies 
on a basis of returns for every quarter of an hour. Regarding minute-by-minute returns, the coverage of the existing scientific research is fairly low. 
This gap is one of the inspirations for this group project, which aims to investigate the influence of Bitcoin on other 
cryptocurrencies with regards to minute-by-minute returns.

<b>3. Methodology</b><br><br>
<b>3.1 Data Selection</b><br><br>
The data used in this analysis was downloaded from CryptoDataDownload. The goal was to include a diversity of cryptocurrencies. 
Therefore dominant altcoins such as Litecoin and Ethereum as well as descendants like Binance Coin and Dash were selected. Three weeks minute returns from 2021-10-11 00:00:00 to 2021-10-31 23:59:00 are used as training data for fitting a model.
<br><br>
<b>3.2 Model and Tests</b><br><br>
The method used to analyse the relationship between Bitcoin and other altcoins is vector autoregression (VAR). 
A VAR model determines the endogenous variables through both their own lagged values and the lagged values of other endogenous variables. 
It is a multivariate model for two or more time series which influence each other (Lütkepohl, 2007).
Granger causality test was used to check the causal relationships between Bitcoin and the selected Altcoins. 
Diagnostic tests were then performed to check the residuals of the VAR model. 
Portmanteau-test was performed to test autocorrelation and a multivariate ARCH test was performed to test heteroscedasticity.
<br><br>
<b> 4. Results</b><br><br>
<b>4.1 Visual inspection and preparation</b><br><br>
In the course of this group project, data of prices of several different altcoins where analysed, compared to the Bitcoin price and used to fit models. 
To be specific, the time series of Litecoin, Ethereum, Binance Coin and Dash were examined. The following chapter shows the analysis of the cryptocurrency Litecoin and its price prediction using Data from October 2021. However, this only serves as an example. The procedure that is demonstrated here can be repeated with many other similar cryptocurrencies or with different time ranges and it can be expected that the results will not change essentially.
The following chart shows the development of the price of Bitcoin (BTC) and the price of Litecoin (LTC), both in percent starting at 100% at the beginning of the analysed time window.
<img src="https://github.com/leiagnes/tsa01/blob/main/image/development_btc_ltc.jpg" height="300"><br>
From a visual inspection, a high correlation is very obvious and it is very likely that the price of Litecoin could be derived from the current Bitcoin price. 
However, to build a basis for worthful investments, the objective has to be to predict future prices of the altcoin. As past values of Bitcoin prices can be used to derive an impact on the price of Litecoin, one should look for a time lagged correlation. This is not directly visible in the above chart and is later examined using vector autoregression and Granger causality tests.
A prerequisite of the vector autoregression model is that the used time series can be considered as stationary. 
From the p-values of an executed augmented Dickey-Fuller test it gets clear that the
original time series are not stationary. Therefore, the price time series are transformed to continuous returns, which results in stationary time series.
<br>
A prerequisite of the vector autoregression model is that the used time series can be considered as stationary. From the p-values of an executed augmented Dickey-Fuller test it gets clear that the
original time series are not stationary. Therefore, the price time series are transformed to continuous returns, which results in stationary time series.<br><br>
<img src="https://github.com/leiagnes/tsa01/blob/main/image/augmented_dickey_fuller_test.jpg" width="350"><br><br>
<b>4.2 Vector autoregression model</b><br><br>
According to the Akaike information criterion an optimal order of 22 for a vector autoregression model could be derived. 
This means, that from both of the time series, 22 steps back are used for a vector autoregression model. 
Hence, the model is described by the following formula.<br>
<img src="https://github.com/leiagnes/tsa01/blob/main/image/vector_autoregression_model_formula.jpg" width="300"><br><br>
With the use of the ordinary least squares method, for each of the included steps an estimate and a p-value is computed and displayed in the below table.<br><br>
<img src="https://github.com/leiagnes/tsa01/blob/main/image/vector_autoregression_model_p_values.jpg" width="300"><br><br>
As visible from the table, there are several past timesteps from Bitcoin as well as from Litecoin having a significant impact on the current return of Litecoin. 
Especially the significant time lags from Bitcoin is indicating a time lagged correlation from Bitcoin on Litecoin.<br>
After fitting the model, a Granger causality test was performed to check the influence of Bitcoin on Litecoin. 
The result shows a p-value smaller than 2.2e-16 and therefore suggests that Bitcoin minute-by-minute returns Granger-cause Litecoin minute-by-minute returns.<br>
Further, an Impulse-Response-Function (IRF) was plotted as follows to visualize how a change in Bitcoin returns impacts Litecoin returns overtime. 
The impact is the strongest at lag 1 and fades out at around lag 22.<br>
<img src="https://github.com/leiagnes/tsa01/blob/main/image/shock_bitcoin.jpg" width="350"><br><br>
<b>4.3 Validation</b><br><br>
To validate the model, the autocorrelation of residuals was analysed by a Portmanteau-test. 
The result shows a p-value of 0.6383, meaning there’s no autocorrelation of residuals. 
Then a multivariate ARCH test was run to check the heteroscedasticity. 
The result showed a p-value smaller than 2.2e-16, meaning there is heteroscedasticity in the residuals. 
Therefore, Granger causality test was performed again with robust standard errors. 
This time the p-value was 2.505e-05. Although it is higher than the original p-value, it is still much lower than the significant level. 
Therefore, Bitcoin minute-by-minute returns indeed Granger-cause Litecoin minute-by-minute returns.
Other models were fitted and compared to further validate the vector autoregression model. The comparison of the different models is done using the root-mean-square-error (RMSE). 
As challenging models, an ARIMA model and an ARIMAX model were fitted. 
The comparison to the ARIMA model is of special interest, as the ARIMA model only bases on the Litecoin time series itself. 
This allows a verification, if it is worth to include Bitcoin returns for predicting Litecoin returns at all. 
The used ARIMAX model includes the Bitcoin returns, but different than the vector autoregression model, the ARIMAX model only includes one previous time step of Bitcoin.
<br><br><img src="https://github.com/leiagnes/tsa01/blob/main/image/models_rmse.jpg" width="300"><br><br>
As the initial vector autoregression model has the lowest RMSE value, the use of this method as well as the inclusion of past Bitcoin returns can be justified. 
Please note that the models are fitted on minute-by-minute returns, which are in general very small values. 
Therefore as well the resulting RMSE values are small in general, and even a small reduction in RMSE is meaningful.<br><br>
<b>5. Conclusion</b><br><br>
With the developed vector autoregression model, Granger causality tests and the display of the IRF chart, 
it was possible to find answers to the initially defined research questions:<br>
- Bitcoin has a significant influence on other cryptocurrencies, e.g. Litecoin, as derived from the result of the Granger causality test and the significant estimates for Bitcoin lags in the vector autoregression model.
- It was neither from the vector autoregression model nor from the IRF chart possible to derive a unique time lag between Bitcoin and other cryptocurrencies. In the case of Litecoin, the time lag of one minute from Bitcoin was estimated with the biggest impact on Litecoin, however lags up to 22 minutes are still showing an impact.
- From the comparison between the vector autoregression model and the ARIMA model, it can be derived that the inclusion of 
Bitcoin prices adds additional precision to the prediction of prices of other cryptocurrencies, in this case the price of Litecoin.

<br>In regards to the prediction of Litecoin returns using the vector autoregression model, 
in spite of having many significant estimates, it must be stated that the power of these estimates are very small. 
Only one estimate is slightly above 0.1 whereas all the others are below, some of them even far below. 
Hence, the model describes in fact only very little of the variation of Litecoin's minute-by-minute returns, 
which is as well indicated by the model's small R-Squared value of only 0.0145. 
Even though the gained knowledge might be of value, it could be difficult for a normal investor to make profit from the prediction made by the model, 
due to the high uncertainty of the predictions.<br><br>
However, as the model does explain some of the variation in the returns of Litecoin, it could be a possible starting point for a high-frequency-trading strategy. With the law of large number by doing very many trades according to the model, it is conceivable that the model could help to realize profit. In a first explorative experiment, a simulation was done, where Litecoin would have been bought at moments where the model predicted an extraordinary high return for the next minute, and then sold again the minute after. In the simulated time of one week, this method would have executed 38 buy and sell pairs, and would have generated a profit of 6.6%, even though the price of Litecoin was going down by 9.8% in the same period. Of course, due to transaction fees this might not yet be profitable. However, there is a clear indication of a possible profitability, considering that the model can be further improved in many points, such as a more explicit training to recognize high returns, the use of more precise price data in timesteps shorter than a minute or the consideration of other factors.
<br><br>
<b>References</b><br><br>
Kumar, A. S. & Ajaz, T. (2019) Co-movement in crypto-currency markets: evidences from wavelet analysis. Financial Innovation, 33(5). https://doi.org/10.1186/s40854-019-0143-3<br>
Lahajnar, S. & Rožanec, A. (2020). The correlation strength of the most important cryptocurrencies in the bull and bear market. Investment Management and Financial Innovations, 17(3), 67-81. http://dx.doi.org/10.21511/imfi.17(3).2020.06<br>
Luetkepohl, H. (2007). Econometric Analysis with Vector Autoregressive Models. European University Institute.<br>
Mensi, W., Rehman, M. U., Shafiullah, M., Al-Yahyaee, K. H. & Sensoy, A. (2021) High frequency multiscale relationships among major cryptocurrencies: portfolio management implications. Financial Innovation, 75(7). https://doi.org/10.1186/s40854-021-00290-w<br>
Tredinnick, L. (2019). Cryptocurrencies and the blockchain. Business Information Review, 36(1), 39-44. https://doi.org/10.1177/0266382119836314<br>
