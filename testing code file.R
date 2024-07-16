# install.packages(c('devtools', 'data.table'))
library(devtools)
# devtools::install_github('Steven-CYCH/CYCHpackage')
library(CYCHpackage)
library(data.table)
# 建立模擬資料集
dataset <- as.data.table(data.frame(
  ID = paste0('S', sprintf("%03d", 1:100)),
  conA = sample(c(round(rnorm(95, mean = 5, sd = 1)), c(1000, -100), rep(NA, 3))),
  conB = sample(c(round(rnorm(94, mean = 5, sd = 1)), c(100, -1000), rep(NA, 4))),
  conC = sample(c(round(rnorm(93, mean = 5, sd = 1)), c(1000, -1000), rep(NA, 5))),
  strD = factor(sample(c(sample(c('A', 'B', 'C'), 90, replace = TRUE), rep(NA_character_, 10)))),
  strE = sample(c(sample(c('AA', 'BB', 'CC'), 80, replace = TRUE), rep(NA_character_, 20))),
  dateF = sample(c(sample(seq.Date(as.Date("2020-01-01"), as.Date("2023-12-31"), by = "day"), 30, replace = TRUE), rep(NA, 70)))
))

# s.dc.outlier_detector ----
# 預設值結果
# 3倍標準差以外的觀察值為離群值(sig_num = 3)
# 遺漏值樣本ID不列出(NA_obs_out = FALSE)
s.dc.outlier_detector(DT = dataset)


# 4倍標準差以外的觀察值為離群值(sig_num = 4)
# 遺漏值樣本ID不列出(NA_obs_out = TRUE)
s.dc.outlier_detector(DT = dataset, sig_num = 4, NA_obs_out = TRUE)


# s.dc.missing_detector ----
# 預設值結果，僅列出變數的遺漏值比例
s.dc.missing_detector(DT = dataset)

# 列出變數的遺漏值比例，並列出包含NA值樣本的其他觀察值
s.dc.missing_detector(DT = dataset, NA_obs_out = TRUE)


nrow(dataset)
newDT01 <- s.dc.sample_missing(DT = dataset)
nrow(newDT01)
