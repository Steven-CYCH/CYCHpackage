# CYCHpackage 說明書 #
**Package：** CYCHpackage  
**Title：** Some Statistical method for medical research  
**Version：** 0.5.0  
**Author：** Sheng-You Su Assistant Research Fellow  
**Email：** cych15334@gmail.com  
**Dependence R Version：**>= 4.3.2  
**Dependence Packages：**
|package名稱|package版本|package名稱|package版本|
|:----------|:----------|:----------|:----------|
|data.table|>= 1.15.4|DataExplorer|>= 0.8.3|
|bazar|>= 1.0.11|fastDummies|>= 1.7.3|

## 模擬數據檔與封包匯入 ##
```R
# 封包匯入
# install.packages(c('devtools', 'data.table'))
library(devtools)
# devtools::install_github('Steven-CYCH/CYCHpackage')
library(CYCHpackage)
library(data.table)
# 模擬數據檔
dataset <- as.data.table(data.frame(
  ID = paste0('S', sprintf("%03d", 1:100)),
  conA = sample(c(round(rnorm(95, mean = 5, sd = 1)), c(1000, -100), rep(NA, 3))),
  conB = sample(c(round(rnorm(94, mean = 5, sd = 1)), c(100, -1000), rep(NA, 4))),
  conC = sample(c(round(rnorm(93, mean = 5, sd = 1)), c(1000, -1000), rep(NA, 5))),
  strD = factor(sample(c(sample(c('A', 'B', 'C'), 90, replace = TRUE), rep(NA_character_, 10)))),
  strE = sample(c(sample(c('AA', 'BB', 'CC'), 80, replace = TRUE), rep(NA_character_, 20))),
  dateF = sample(c(sample(seq.Date(as.Date("2020-01-01"), as.Date("2023-12-31"), by = "day"), 90, replace = TRUE), rep(NA, 10)))
))
```

## **Data Clean** ##

### **s.dc.outlier_detector** ###

#### Description ####
1. 針對**變數**(直欄)列出是否有離群值
2. 針對**變數**列出是否有遺漏值

#### Usage ####
s.dc.outlier_detector(dataset, ID_name = 'ID', sig_num = 3, NA_obs_out = FALSE, in_list = NULL, out_list = NULL)  

#### Arguments ####
|參數名稱|參數敘述|預設值|參數型態|
|:----------|:----------|:----------:|:----------:|
|dataset|輸入要檢查離群值或遺漏的資料集名稱||data.table|
|ID_name|辨識樣本的唯一鍵值|"ID"|character|
|sig_num|辨識離群值時，預期的標準差倍數，範圍[mean - sig_num * sd, mean + sig_num * sd]以外的觀察值會被列入候選離群值被印出|3|numeric|
|NA_obs_out|是否印出具有遺漏值的觀察值|FALSE|boolean|
|in_list|**要**被納入檢查離群值的變數名稱|NULL|vector|
|out_list|**不要**被納入檢查離群值的變數名稱|NULL|vector|

<!-- #### References #### -->
#### Examples ####
```R
# 封包匯入
# 模擬數據檔

# 預設值結果
# 3倍標準差以外的觀察值為離群值(sig_num = 3)
# 遺漏值樣本ID不列出(NA_obs_out = FALSE)
s.dc.outlier_detector(DT = dataset)

# conA 
# 變數 conA 含有NA值，但已省略輸出
# ID是 S042 的紀錄中有變數 conA 的觀察值疑似為離群值，觀察值為 1000 
# conB 
# 變數 conB 含有NA值，但已省略輸出
# ID是 S098 的紀錄中有變數 conB 的觀察值疑似為離群值，觀察值為 -1000 
# conC 
# 變數 conC 含有NA值，但已省略輸出
# ID是 S049 的紀錄中有變數 conC 的觀察值疑似為離群值，觀察值為 1000 
# ID是 S081 的紀錄中有變數 conC 的觀察值疑似為離群值，觀察值為 -1000 
# strD 
# 變數 strD 含有NA值，但已省略輸出
# 該變數觀察值型態非為數值，無法檢測離群值
# strE 
# 變數 strE 含有NA值，但已省略輸出
# 該變數觀察值型態非為數值，無法檢測離群值
# dateF 
# 變數 dateF 含有NA值，但已省略輸出


# 4倍標準差以外的觀察值為離群值(sig_num = 4)
# 遺漏值樣本ID不列出(NA_obs_out = TRUE)
s.dc.outlier_detector(DT = dataset, sig_num = 4, NA_obs_out = TRUE)
# conA 
# ID是 S021 的紀錄中有變數 conA 的觀察值為 Missing Data 
# ID是 S036 的紀錄中有變數 conA 的觀察值為 Missing Data 
# ID是 S042 的紀錄中有變數 conA 的觀察值疑似為離群值，觀察值為 1000 
# ID是 S047 的紀錄中有變數 conA 的觀察值為 Missing Data 
# conB 
# ID是 S014 的紀錄中有變數 conB 的觀察值為 Missing Data 
# ID是 S070 的紀錄中有變數 conB 的觀察值為 Missing Data 
# ID是 S077 的紀錄中有變數 conB 的觀察值為 Missing Data 
# ID是 S082 的紀錄中有變數 conB 的觀察值為 Missing Data 
# ID是 S098 的紀錄中有變數 conB 的觀察值疑似為離群值，觀察值為 -1000 
# conC 
# ID是 S017 的紀錄中有變數 conC 的觀察值為 Missing Data 
# ID是 S030 的紀錄中有變數 conC 的觀察值為 Missing Data 
# ID是 S037 的紀錄中有變數 conC 的觀察值為 Missing Data 
# ID是 S049 的紀錄中有變數 conC 的觀察值疑似為離群值，觀察值為 1000 
# ID是 S055 的紀錄中有變數 conC 的觀察值為 Missing Data 
# ID是 S061 的紀錄中有變數 conC 的觀察值為 Missing Data 
# ID是 S081 的紀錄中有變數 conC 的觀察值疑似為離群值，觀察值為 -1000 
# strD 
# 該變數觀察值型態非為數值，無法檢測離群值
# ID是 S004 的紀錄中有變數 strD 的觀察值為 Missing Data 
# ID是 S013 的紀錄中有變數 strD 的觀察值為 Missing Data 
# ID是 S015 的紀錄中有變數 strD 的觀察值為 Missing Data 
# ID是 S022 的紀錄中有變數 strD 的觀察值為 Missing Data 
# ID是 S027 的紀錄中有變數 strD 的觀察值為 Missing Data 
# ID是 S029 的紀錄中有變數 strD 的觀察值為 Missing Data 
# ID是 S041 的紀錄中有變數 strD 的觀察值為 Missing Data 
# ID是 S065 的紀錄中有變數 strD 的觀察值為 Missing Data 
# ID是 S084 的紀錄中有變數 strD 的觀察值為 Missing Data 
# ID是 S088 的紀錄中有變數 strD 的觀察值為 Missing Data 
# strE 
# 該變數觀察值型態非為數值，無法檢測離群值
# ID是 S003 的紀錄中有變數 strE 的觀察值為 Missing Data 
# ID是 S011 的紀錄中有變數 strE 的觀察值為 Missing Data 
# ID是 S013 的紀錄中有變數 strE 的觀察值為 Missing Data 
# ID是 S020 的紀錄中有變數 strE 的觀察值為 Missing Data 
# ID是 S024 的紀錄中有變數 strE 的觀察值為 Missing Data 
# ID是 S026 的紀錄中有變數 strE 的觀察值為 Missing Data 
# ID是 S028 的紀錄中有變數 strE 的觀察值為 Missing Data 
# ID是 S038 的紀錄中有變數 strE 的觀察值為 Missing Data 
# ID是 S041 的紀錄中有變數 strE 的觀察值為 Missing Data 
# ID是 S051 的紀錄中有變數 strE 的觀察值為 Missing Data 
# ID是 S066 的紀錄中有變數 strE 的觀察值為 Missing Data 
# ID是 S070 的紀錄中有變數 strE 的觀察值為 Missing Data 
# ID是 S071 的紀錄中有變數 strE 的觀察值為 Missing Data 
# ID是 S072 的紀錄中有變數 strE 的觀察值為 Missing Data 
# ID是 S075 的紀錄中有變數 strE 的觀察值為 Missing Data 
# ID是 S078 的紀錄中有變數 strE 的觀察值為 Missing Data 
# ID是 S087 的紀錄中有變數 strE 的觀察值為 Missing Data 
# ID是 S089 的紀錄中有變數 strE 的觀察值為 Missing Data 
# ID是 S096 的紀錄中有變數 strE 的觀察值為 Missing Data 
# ID是 S099 的紀錄中有變數 strE 的觀察值為 Missing Data 
# dateF 
# ID是 S008 的紀錄中有變數 dateF 的觀察值為 Missing Data 
# ID是 S009 的紀錄中有變數 dateF 的觀察值為 Missing Data 
# ID是 S010 的紀錄中有變數 dateF 的觀察值為 Missing Data 
# ID是 S017 的紀錄中有變數 dateF 的觀察值為 Missing Data 
# ID是 S022 的紀錄中有變數 dateF 的觀察值為 Missing Data 
# ID是 S044 的紀錄中有變數 dateF 的觀察值為 Missing Data 
# ID是 S066 的紀錄中有變數 dateF 的觀察值為 Missing Data 
# ID是 S080 的紀錄中有變數 dateF 的觀察值為 Missing Data 
# ID是 S090 的紀錄中有變數 dateF 的觀察值為 Missing Data 
# ID是 S093 的紀錄中有變數 dateF 的觀察值為 Missing Data 
```

### **s.dc.missing_detector** ###
#### Description ####
1. 計算各**變數**遺漏值比例
2. 印出有**遺漏值**的樣本觀察值(包含其識別ID)

#### Usage ####
s.dc.missing_detector(DT, listout_col = NULL, NA_obs_out = FALSE) 

#### Arguments ####
|參數名稱|參數敘述|預設值|參數型態|
|:----------|:----------|:----------:|:----------:|
|DT|輸入要檢查遺漏值的資料集名稱||data.table|
|listout_col|**要**被納入檢查遺漏值的變數名稱，若無輸入表示全部列出|NULL|vector|
|NA_obs_out|是否印出具有遺漏值的觀察值|FALSE|boolean|
#### References ####
Jung JO, Crnovrsanin N, Wirsik NM, Nienhüser H, Peters L, Popp F, Schulze A, Wagner M, Müller-Stich BP, Büchler MW, Schmidt T. Machine learning for optimized individual survival prediction in resectable upper gastrointestinal cancer. J Cancer Res Clin Oncol. 2023 May;149(5):1691-1702. doi: 10.1007/s00432-022-04063-5. Epub 2022 May 26. PMID: 35616729; PMCID: PMC10097798.
#### Examples ####
```R
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

# 計算各個變數中的遺漏值比率，但不印出遺漏的部分
s.dc.missing_detector(DT = dataset)
# 變數 conA 中含有3%的遺漏值 
# 
# 變數 factorB 中含有10%的遺漏值 

# 計算各個變數中的遺漏值比率，並印出遺漏的部分
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
```

### **s.dc.sample_missing** ###
#### Description ####
遺漏值的刪除處理，若該樣本的遺漏值比例(deleting_ratio_over)超過設定的數字，即將該樣本刪除，並需重新assign物件名稱
#### Usage ####
newDT <- s.dc.sample_missing(DT, deleting_ratio_over = 0.1)
#### Arguments ####
|參數名稱|參數敘述|預設值|參數型態|
|:----------|:----------|:----------:|:----------:|
|DT|輸入要檢查遺漏值的資料集名稱||data.table|
|deleting_ratio_over|當樣本的遺漏值比例超過(大於不包含)設定的值時，將該樣本(row)刪除|0.1|float|
#### Value ####
輸出的newDT為**data.table**的格式。
#### References ####
Jung JO, Crnovrsanin N, Wirsik NM, Nienhüser H, Peters L, Popp F, Schulze A, Wagner M, Müller-Stich BP, Büchler MW, Schmidt T. Machine learning for optimized individual survival prediction in resectable upper gastrointestinal cancer. J Cancer Res Clin Oncol. 2023 May;149(5):1691-1702. doi: 10.1007/s00432-022-04063-5. Epub 2022 May 26. PMID: 35616729; PMCID: PMC10097798.
#### Examples ####


### **s.dc.missing_imputation** ###
#### Description ####
#### Usage ####
#### Arguments ####
#### References ####
#### Examples ####
