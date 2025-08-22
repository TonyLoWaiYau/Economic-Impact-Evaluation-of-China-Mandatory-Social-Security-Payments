# Economic Impact Evaluation of China's Mandatory Social Security Payments
Beginning September 1, 2025, mainland China will enforce mandatory social insurance regulations, invalidating any prior agreements that allowed employers and employees to opt out of contributing. This policy effectively reduces workers’ take-home pay and increases labor costs for businesses, thereby dampening both consumption and production. To better understand these macroeconomic consequences, this study introduces a model that quantifies the impact of mandatory social insurance under various assumptions.
# Data
Annual growth rates of social security fund revenue (ssf), industrial production (ip), disposable income (di), and retail sales (rs) from 1990 to 2024.

`plot(ts_data)`

<img width="512" height="416" alt="visualise clean data" src="https://github.com/user-attachments/assets/d7a619e6-7067-47ba-ae37-5171de1c3bb8" />

# Model
In this study, I use a Bayesian Vector Autoregression (BVAR) framework, which is well-suited for capturing complex dynamic relationships among macroeconomic variables while mitigating the risk of over-parameterization. To address potential small-sample bias, I include a Minnesota prior, thereby guiding the model toward more plausible parameter estimates and reducing overfitting. Because the data display signs of nonstationarity, I further incorporate a sum-of-coefficients prior to help stabilize the estimated relationships over time. Lastly, I adopt a hierarchical hyperparameter approach that allows the priors to remain data-driven, minimizing subjective judgment in the estimation process.

`> summary(model)`
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
