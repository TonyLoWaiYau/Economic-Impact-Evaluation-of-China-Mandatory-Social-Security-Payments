# LO Wai Yau, Tony
# Created: 2025/8/19
# Last update: 2025/8/21

#modeling
################################################################################
rm(list=ls())
set.seed(123)
library(readxl)
data <- read_excel("clean_data.xlsx")
di <- ts(data$di, start = c(1990), frequency = 1)
rs <- ts(data$rs, start = c(1990), frequency = 1)
ssf <- ts(data$ssf, start = c(1990), frequency = 1)
ip <- ts(data$ip, start = c(1990), frequency = 1)
ts_data <- ts.union(ssf, ip, di, rs)
library(BVAR)
soc <- bv_soc(mode = 1, sd = 1, min = 1e-04, max = 50)
priors <- bv_priors(hyper = "auto", mn = bv_mn(), soc = soc)
model <- bvar(ts_data, lags = 3, n_draw = 250000L, n_burn = 50000L, n_thin = 5L,priors = priors, verbose= TRUE)
sign_restriction <- matrix(c(1,-1,-1,-1,1,1,1,1,NA,NA,NA,NA,NA,NA,NA,NA), ncol = 4)
opt_signs <- bv_irf(horizon = 10, fevd = TRUE,identification = TRUE, sign_restr = sign_restriction, sign_lim = 10000)
print(opt_signs)
irf(model) <- irf(model,opt_signs, horizon = 10 , identification = TRUE)
impact_ssf <- ts(t(irf(model)[["quants"]][,1,,1]),start = c(2026), frequency = 1)
impact_ip  <- ts(t(irf(model)[["quants"]][,2,,1]),start = c(2026), frequency = 1)
impact_di  <- ts(t(irf(model)[["quants"]][,3,,1]),start = c(2026), frequency = 1)
impact_rs  <- ts(t(irf(model)[["quants"]][,4,,1]),start = c(2026), frequency = 1)
################################################################################

#analysis
################################################################################
#assumption on increase of social security fund revenue in RMB mn
assumption <- 100*12000 
m <- (100*assumption/12012300)/(irf(model)[["quants"]][2,1,1,1])
new_impact_ssf <- m*impact_ssf
new_impact_ip <- m*impact_ip
new_impact_di <- m*impact_di
new_impact_rs <- m*impact_rs
################################################################################

#charting
################################################################################
library(ggplot2)

#ssf
x <- new_impact_ssf
df <- as.data.frame(x)
names(df) <- c("q16", "q50", "q84")
df$Year <- as.numeric(time(x))
chart_ssf <- ggplot(df, aes(x = Year)) +
  geom_hline(yintercept = 0, linetype = "dashed", colour = "grey60") +
  geom_ribbon(aes(ymin = q16, ymax = q84),fill  = "#c6dbef",alpha = 0.6) +
  geom_line(aes(y = q50),colour = "#08519c",linewidth = 1.1) +
  scale_x_continuous(breaks = df$Year) +
  labs(title    = "",
       subtitle = "Impact of mandatory social security payments on the growth rate of social security fund revenue (%)",
       x        = "Year",
       y        = "",
       caption  = "") +
  theme_minimal(base_size = 12) +
  theme(
    plot.title   = element_text(hjust = 0.5,face = "bold", size = 14),
    plot.subtitle = element_text(hjust = 0.5,face  = "italic",size  = 12),
    panel.grid.minor = element_blank()
  )
chart_ssf
ggsave("impact on social security fund revenue.png",chart_ssf,width = 3840/300, height = 2160/300, dpi = 300, bg= "white")

#ip
x <- new_impact_ip
df <- as.data.frame(x)
names(df) <- c("q16", "q50", "q84")
df$Year <- as.numeric(time(x))
chart_ssf <- ggplot(df, aes(x = Year)) +
  geom_hline(yintercept = 0, linetype = "dashed", colour = "grey60") +
  geom_ribbon(aes(ymin = q16, ymax = q84),fill  = "#c6dbef",alpha = 0.6) +
  geom_line(aes(y = q50),colour = "#08519c",linewidth = 1.1) +
  scale_x_continuous(breaks = df$Year) +
  labs(title    = "",
       subtitle = "Impact of mandatory social security payments on the growth rate of industrial production (%)",
       x        = "Year",
       y        = "",
       caption  = "") +
  theme_minimal(base_size = 12) +
  theme(
    plot.title   = element_text(hjust = 0.5,face = "bold", size = 14),
    plot.subtitle = element_text(hjust = 0.5,face  = "italic",size  = 12),
    panel.grid.minor = element_blank()
  )
chart_ssf
ggsave("impact on industrial production.png",chart_ssf,width = 3840/300, height = 2160/300, dpi = 300, bg= "white")

#di
x <- new_impact_di
df <- as.data.frame(x)
names(df) <- c("q16", "q50", "q84")
df$Year <- as.numeric(time(x))
chart_ssf <- ggplot(df, aes(x = Year)) +
  geom_hline(yintercept = 0, linetype = "dashed", colour = "grey60") +
  geom_ribbon(aes(ymin = q16, ymax = q84),fill  = "#c6dbef",alpha = 0.6) +
  geom_line(aes(y = q50),colour = "#08519c",linewidth = 1.1) +
  scale_x_continuous(breaks = df$Year) +
  labs(title    = "",
       subtitle = "Impact of mandatory social security payments on the growth rate of disposable income (%)",
       x        = "Year",
       y        = "",
       caption  = "") +
  theme_minimal(base_size = 12) +
  theme(
    plot.title   = element_text(hjust = 0.5,face = "bold", size = 14),
    plot.subtitle = element_text(hjust = 0.5,face  = "italic",size  = 12),
    panel.grid.minor = element_blank()
  )
chart_ssf
ggsave("impact on disposable income.png",chart_ssf,width = 3840/300, height = 2160/300, dpi = 300, bg= "white")

#rs
x <- new_impact_rs
df <- as.data.frame(x)
names(df) <- c("q16", "q50", "q84")
df$Year <- as.numeric(time(x))
chart_ssf <- ggplot(df, aes(x = Year)) +
  geom_hline(yintercept = 0, linetype = "dashed", colour = "grey60") +
  geom_ribbon(aes(ymin = q16, ymax = q84),fill  = "#c6dbef",alpha = 0.6) +
  geom_line(aes(y = q50),colour = "#08519c",linewidth = 1.1) +
  scale_x_continuous(breaks = df$Year) +
  labs(title    = "",
       subtitle = "Impact of mandatory social security payments on the growth rate of retail sales (%)",
       x        = "Year",
       y        = "",
       caption  = "") +
  theme_minimal(base_size = 12) +
  theme(
    plot.title   = element_text(hjust = 0.5,face = "bold", size = 14),
    plot.subtitle = element_text(hjust = 0.5,face  = "italic",size  = 12),
    panel.grid.minor = element_blank()
  )
chart_ssf
ggsave("impact on retail sales.png",chart_ssf,width = 3840/300, height = 2160/300, dpi = 300, bg= "white")
#################################################################################


