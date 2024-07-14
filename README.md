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

#### References ####
#### Examples ####
```R
library(CYCHpackage)
library(data.table)
DT <- as.data.table(data.frame(
  ID = paste0('S', sprintf("%03d", 1:100)),
  conA = sample(c(round(rnorm(95, mean = 5, sd = 1)), c(100, -100), rep(NA, 3))),
  factorB = factor(sample(c(sample(c('A', 'B', 'C'), 90, replace = TRUE), rep('', 10))))
))
s.dc.outlier_detector(DT)
```

### **s.dc.missing_detector** ###
#### Description ####
1. 計算各**變數**遺漏值比例
2. 印出有**遺漏值**的樣本觀察值(包含其識別ID)

#### Usage ####
s.dc.missing_detector(dataset, ID_name, listout_col = NULL, NA_obs_out = FALSE) 

#### Arguments ####
|參數名稱|參數敘述|預設值|參數型態|
|:----------|:----------|:----------:|:----------:|
|dataset|輸入要檢查離群值或遺漏值的資料集名稱|     |data.table|
|listout_col|**要**被納入檢查遺漏值的變數名稱|NULL|vector|
|NA_obs_out|是否印出具有遺漏值的觀察值|FALSE|boolean|
#### References ####
reference doi is 10.1007/s00432-022-04063-5
#### Examples ####

### **s.dc.sample_missing** ###
#### Description ####
#### Usage ####
#### Arguments ####
#### References ####
#### Examples ####

### **s.dc.missing_imputation** ###
#### Description ####
#### Usage ####
#### Arguments ####
#### References ####
#### Examples ####
