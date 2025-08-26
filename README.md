# Economic Impact Evaluation of China's Mandatory Social Security Payments
Beginning September 1, 2025, mainland China will enforce mandatory social insurance regulations, invalidating any prior agreements that allowed employers and employees to opt out of contributing. This policy effectively reduces workers’ take-home pay and increases labor costs for businesses, thereby dampening both consumption and production. To better understand these macroeconomic consequences, this study introduces a model that quantifies the impact of mandatory social insurance under various assumptions.
# Data
Annual growth rates of social security fund revenue (ssf), industrial production (ip), disposable income (di), and retail sales (rs) from 1990 to 2024.

`plot(ts_data)`

<img width="512" height="416" alt="visualise clean data" src="https://github.com/user-attachments/assets/d7a619e6-7067-47ba-ae37-5171de1c3bb8" />

# Model
In this study, I use a Bayesian Vector Autoregression (BVAR) framework, which is well-suited for capturing complex dynamic relationships among macroeconomic variables while mitigating the risk of over-parameterization. To address potential small-sample bias, I include a Minnesota prior, thereby guiding the model toward more plausible parameter estimates and reducing overfitting. Because the data display signs of nonstationarity, I further incorporate a sum-of-coefficients prior to help stabilize the estimated relationships over time. Lastly, I adopt a hierarchical hyperparameter approach that allows the priors to remain data-driven, minimizing subjective judgment in the estimation process.

`summary(model)`
<pre>Bayesian VAR consisting of 32 observations, 4 variables and 3 lags.
Time spent calculating: 3.21 mins
Hyperparameters: lambda, soc 
Hyperparameter values after optimisation: 0.4407, 2.86583
Iterations (burnt / thinning): 250000 (50000 / 5)
Accepted draws (rate): 126857 (0.634)`

Numeric array (dimensions 13, 4) of coefficient values from a BVAR.
Median values:
            ssf     ip     di     rs
constant  4.845  1.344  1.851  1.391
ssf-lag1  0.127  0.000 -0.056 -0.045
ip-lag1   0.852  0.893  0.662  0.807
di-lag1   0.534 -0.083  0.868  0.234
rs-lag1  -0.596 -0.185 -0.146  0.186
ssf-lag2  0.054  0.013  0.133  0.021
ip-lag2   0.513  0.044 -0.055 -0.033
di-lag2  -0.429  0.046 -0.237 -0.069
rs-lag2   0.274  0.108  0.010  0.488
ssf-lag3  0.085  0.008 -0.067 -0.035
ip-lag3  -0.072  0.130 -0.262 -0.188
di-lag3  -0.221 -0.059  0.014 -0.234
rs-lag3   0.165 -0.064  0.011 -0.073

Numeric array (dimensions 4, 4) of variance-covariance values from a BVAR.
Median values:
       ssf    ip     di     rs
ssf 56.538 7.689 12.266 18.804
ip   7.689 3.862  3.806  4.859
di  12.266 3.806  7.448  7.060
rs  18.804 4.859  7.060 14.024

Log-Likelihood: -302.1262 </pre>

# Identification and Impulse Response Functions
To isolate the structural shocks in the BVAR, I impose sign restrictions aligned with theoretical expectations: a social security policy shock is characterized by a positive effect on social security fund revenue but a negative effect on industrial production, disposable income, and retail sales. In contrast, a labor demand shock positively affects all four variables. These partial-identification constraints help disentangle the policy-induced disturbances from broader labor market dynamics, thereby enabling a clearer view of how changes in social insurance requirements propagate through the economy.

`print(opt_signs)`
<pre>Object with settings for computing impulse responses.
Horizon: 10
Identification: Sign restrictions
Chosen restrictions:
			      Shock to
			        Var1    Var2    Var3    Var4	 
Response of	Var1	 +       +       NA      NA	

		    Var2	 -       +       NA      NA	

		    Var3	 -       +       NA      NA	

		    Var4	 -       +       NA      NA	
FEVD: TRUE</pre>

Based on the specified sign restrictions, the resulting impulse response functions (with 68% confidence bands) are shown below.

`plot(irf(model))`

<img width="711" height="527" alt="IRF" src="https://github.com/user-attachments/assets/c9628991-0f24-44ec-b3b7-e64260f501d4" />

# Assumptions
Assumption 1: After the new policy is implemented, the number of people paying social insurance will increase by around 50 million.

*Given that mainland China currently has about 700 million employed people, with around 400 million paying into social security and 200 million in flexible employment, roughly 100 million are not contributing as required.*

*Because many companies will look for ways to evade payments—such as splitting full-time jobs into several part-time positions, hiring retirees, or using other illegal methods—and because some individuals (e.g., those nearing retirement) may be unwilling to resume payments, I estimate that only about half of the previously non-compliant workers will start contributing.*

Assumption 2: Each of these people will contribute an average of 1,000 yuan per month, i.e., 12,000 yuan per person per year.

*This is based on the expectation that they will pay according to the minimum contribution standard.*

Assumption 1+2: That is, social security fund revenue will rise by `50 × 12,000 = 600,000` million yuan.

`assumption <- 50*12000`

# Results
Based on the above assumptions and impulse response functions, the following conclusions can be drawn:

<img width="3840" height="2160" alt="impact on social security fund revenue" src="https://github.com/user-attachments/assets/f1ff2130-2a69-4a5b-a2a2-6fabaeff3524" />

<img width="3840" height="2160" alt="impact on industrial production" src="https://github.com/user-attachments/assets/80aad0cd-6820-4bb7-9efa-7ff7757fb602" />

<img width="3840" height="2160" alt="impact on disposable income" src="https://github.com/user-attachments/assets/316a9940-8dba-4791-80c9-c350adf719ab" />

<img width="3840" height="2160" alt="impact on retail sales" src="https://github.com/user-attachments/assets/75d97365-d407-40b5-8cb1-5e75db5a3580" />

# Discussion
Fiscal subsidies currently account for about 20 % of the social security fund’s revenue. The additional income generated by the new measures will enable the government to free up some resources, cut the subsidy to the social security fund, and redirect the money to shore up economic activity. As a result, the new measures’ adverse impact on the overall economy is likely to be fully offset.
Two caveats deserve attention:

1.	The quantitative analysis above suggests that the new measures have a very large effect on the economy. Consequently, any missteps in the follow-up support policies could have significant repercussions, raising the level of uncertainty surrounding China’s economic outlook.

2.	When rolling out economic support, the authorities will set priorities. For instance, against a backdrop of overcapacity, they may favor boosting consumption over expanding production, or supporting large companies over SMEs. This implies that different sectors of the economy could show increasingly divergent performance.


# References
Nikolas Kuschnig and Lukas Vashold (2021). BVAR: Bayesian Vector Autoregressions with Hierarchical Prior Selection in R. Journal of Statistical Software, 14, 1-27, DOI: 10.18637/jss.v100.i14.

Domenico Giannone, Michele Lenza and Giorgio E. Primiceri (2015). Prior Selection for Vector Autoregressions. The Review of Economics and Statistics, 97:2, 436-451, DOI: 10.1162/REST_a_00483.





