# install.packages(c('devtools', 'data.table'))
library(devtools)
# devtools::install_github('Steven-CYCH/CYCHpackage')
library(CYCHpackage)
library(data.table)
# 建立模擬資料集
dataset <- as.data.table(data.frame(
  ID = paste0('S', sprintf("%03d", 1:100)),
  conA = sample(c(round(rnorm(95, mean = 5, sd = 1)), c(100, -100), rep(NA, 3))),
  factorB = factor(sample(c(sample(c('A', 'B', 'C'), 90, replace = TRUE), rep('', 10))))
))

# 預設值結果
# 3倍標準差以外的觀察值為離群值(sig_num = 3)
# 遺漏值樣本ID不列出(NA_obs_out = FALSE)
s.dc.outlier_detector(DT = dataset)

# 4倍標準差以外的觀察值為離群值(sig_num = 4)
# 遺漏值樣本ID不列出(NA_obs_out = TRUE)
s.dc.outlier_detector(DT = dataset, sig_num = 4, NA_obs_out = TRUE)
