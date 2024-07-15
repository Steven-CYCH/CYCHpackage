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
#
# conA
# 變數 conA 含有NA值，但已省略輸出
# ID是 S047 的紀錄中有變數 conA 的觀察值疑似為離群值，觀察值為 100
# ID是 S053 的紀錄中有變數 conA 的觀察值疑似為離群值，觀察值為 -100
#
# factorB
# 變數 factorB 含有NA值，但已省略輸出
# 該變數觀察值型態非為數值，無法檢測離群值

# 4倍標準差以外的觀察值為離群值(sig_num = 4)
# 遺漏值樣本ID不列出(NA_obs_out = TRUE)
s.dc.outlier_detector(DT = dataset, sig_num = 4, NA_obs_out = TRUE)
#
# conA
# ID是 S014 的紀錄中有變數 conA 的觀察值為 Missing Data
# ID是 S042 的紀錄中有變數 conA 的觀察值為 Missing Data
# ID是 S047 的紀錄中有變數 conA 的觀察值疑似為離群值，觀察值為 100
# ID是 S053 的紀錄中有變數 conA 的觀察值疑似為離群值，觀察值為 -100
# ID是 S098 的紀錄中有變數 conA 的觀察值為 Missing Data
#
# factorB
# 該變數觀察值型態非為數值，無法檢測離群值
# ID是 S019 的紀錄中有變數 factorB 的觀察值為 Missing Data
# ID是 S023 的紀錄中有變數 factorB 的觀察值為 Missing Data
# ID是 S042 的紀錄中有變數 factorB 的觀察值為 Missing Data
# ID是 S046 的紀錄中有變數 factorB 的觀察值為 Missing Data
# ID是 S048 的紀錄中有變數 factorB 的觀察值為 Missing Data
# ID是 S052 的紀錄中有變數 factorB 的觀察值為 Missing Data
# ID是 S056 的紀錄中有變數 factorB 的觀察值為 Missing Data
# ID是 S077 的紀錄中有變數 factorB 的觀察值為 Missing Data
# ID是 S082 的紀錄中有變數 factorB 的觀察值為 Missing Data
# ID是 S092 的紀錄中有變數 factorB 的觀察值為 Missing Data


s.dc.missing_detector(DT = dataset)
# 變數 conA 中含有3%的遺漏值
#
# 變數 factorB 中含有10%的遺漏值
s.dc.missing_detector(DT = dataset, NA_obs_out = TRUE)
# 變數 conA 中含有3%的遺漏值
# ID conA factorB
# 32 S032   NA
# 45 S045   NA       A
# 86 S086   NA       C
#
# 變數 factorB 中含有10%的遺漏值
# ID conA factorB
# 4  S004    5
# 19 S019    5
# 22 S022    3
# 24 S024    5
# 32 S032   NA
# 36 S036    5
# 37 S037    7
# 77 S077    6
# 87 S087    7
# 90 S090    4


