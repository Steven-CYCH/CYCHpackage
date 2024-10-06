# CYCHpackage 說明書 #
**Package：** CYCHpackage  
**Title：** Some Statistical method for medical research  
**Version：** 2.1.1  
**Author：** Sheng-You Su Assistant Research Fellow  
**Email：** cych15334@gmail.com  
**Dependence R Version：**>= 4.3.2  
**Dependence Packages：**
|package名稱|package版本|package名稱|package版本|
|:----------|:----------|:----------|:----------|
|data.table|>= 1.15.4|DataExplorer|>= 0.8.3|
|bazar|>= 1.0.11|fastDummies|>= 1.7.3|
|nortest|>=1.0-4|||

1. [模擬數據檔與封包匯入](#模擬數據檔與封包匯入)  
2. [Data Clean](#dataclean)  
  2.1 [s.dc.outlier_detector](#sdcoutlierdetector)  
  2.2 [s.dc.missing_detector](#sdcmissingdetector)  
  2.3 [s.dc.sample_missing](#sdcsamplemissing)  
  2.4 [s.dc.missing_imputation](#sdcmissingimputation)
4. [Data Analysis](#dataanalysis)  
  4.1 [table1_pvalue](#table1pvalue)  
  4.2 [table1_method](#table1method)

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
  dateF = sample(c(sample(seq.Date(as.Date("2020-01-01"), as.Date("2023-12-31"), by = "day"), 30, replace = TRUE), rep(NA, 70)))
))
```

<a id = 'dataclean'> </a>

## **Data Clean** ##

<a id = 'sdcoutlierdetector'> </a>

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
|ID_name|辨識樣本的唯一鍵值|'ID'|character|
|sig_num|辨識離群值時，預期的標準差倍數，範圍[mean - sig_num * sd, mean + sig_num * sd]以外的觀察值會被列入候選離群值被印出|3|numeric|
|NA_obs_out|是否印出具有遺漏值的觀察值|FALSE|logical|
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
# ID是 S084 的紀錄中有變數 conA 的觀察值疑似為離群值，觀察值為 1000 

# conB 
# 變數 conB 含有NA值，但已省略輸出
# ID是 S001 的紀錄中有變數 conB 的觀察值疑似為離群值，觀察值為 -1000 

# conC 
# 變數 conC 含有NA值，但已省略輸出
# ID是 S007 的紀錄中有變數 conC 的觀察值疑似為離群值，觀察值為 1000 
# ID是 S023 的紀錄中有變數 conC 的觀察值疑似為離群值，觀察值為 -1000 

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
# ID是 S047 的紀錄中有變數 conA 的觀察值為 Missing Data 
# ID是 S062 的紀錄中有變數 conA 的觀察值為 Missing Data 
# ID是 S079 的紀錄中有變數 conA 的觀察值為 Missing Data 
# ID是 S084 的紀錄中有變數 conA 的觀察值疑似為離群值，觀察值為 1000 

# conB 
# ID是 S001 的紀錄中有變數 conB 的觀察值疑似為離群值，觀察值為 -1000 
# ID是 S050 的紀錄中有變數 conB 的觀察值為 Missing Data 
# ID是 S077 的紀錄中有變數 conB 的觀察值為 Missing Data 
# ID是 S091 的紀錄中有變數 conB 的觀察值為 Missing Data 
# ID是 S094 的紀錄中有變數 conB 的觀察值為 Missing Data 

# conC 
# ID是 S002 的紀錄中有變數 conC 的觀察值為 Missing Data 
# ID是 S007 的紀錄中有變數 conC 的觀察值疑似為離群值，觀察值為 1000 
# ID是 S023 的紀錄中有變數 conC 的觀察值疑似為離群值，觀察值為 -1000 
# ID是 S038 的紀錄中有變數 conC 的觀察值為 Missing Data 
# ID是 S042 的紀錄中有變數 conC 的觀察值為 Missing Data 
# ID是 S067 的紀錄中有變數 conC 的觀察值為 Missing Data 
# ID是 S089 的紀錄中有變數 conC 的觀察值為 Missing Data 

# strD 
# 該變數觀察值型態非為數值，無法檢測離群值
# ID是 S008 的紀錄中有變數 strD 的觀察值為 Missing Data 
# ID是 S014 的紀錄中有變數 strD 的觀察值為 Missing Data 
# ID是 S037 的紀錄中有變數 strD 的觀察值為 Missing Data 
# ID是 S040 的紀錄中有變數 strD 的觀察值為 Missing Data 
# ID是 S048 的紀錄中有變數 strD 的觀察值為 Missing Data 
# ID是 S054 的紀錄中有變數 strD 的觀察值為 Missing Data 
# ID是 S055 的紀錄中有變數 strD 的觀察值為 Missing Data 
# ID是 S063 的紀錄中有變數 strD 的觀察值為 Missing Data 
# ID是 S080 的紀錄中有變數 strD 的觀察值為 Missing Data 
# ID是 S087 的紀錄中有變數 strD 的觀察值為 Missing Data 

# strE 
# 該變數觀察值型態非為數值，無法檢測離群值
# ID是 S003 的紀錄中有變數 strE 的觀察值為 Missing Data 
# ID是 S005 的紀錄中有變數 strE 的觀察值為 Missing Data 
# ID是 S006 的紀錄中有變數 strE 的觀察值為 Missing Data 
# ID是 S017 的紀錄中有變數 strE 的觀察值為 Missing Data 
# ID是 S022 的紀錄中有變數 strE 的觀察值為 Missing Data 
#                        中間省略
# ID是 S077 的紀錄中有變數 strE 的觀察值為 Missing Data 
# ID是 S088 的紀錄中有變數 strE 的觀察值為 Missing Data 
# ID是 S089 的紀錄中有變數 strE 的觀察值為 Missing Data 
# ID是 S096 的紀錄中有變數 strE 的觀察值為 Missing Data 
# ID是 S100 的紀錄中有變數 strE 的觀察值為 Missing Data 

# dateF 
# ID是 S001 的紀錄中有變數 dateF 的觀察值為 Missing Data 
# ID是 S003 的紀錄中有變數 dateF 的觀察值為 Missing Data 
# ID是 S007 的紀錄中有變數 dateF 的觀察值為 Missing Data 
# ID是 S008 的紀錄中有變數 dateF 的觀察值為 Missing Data 
# ID是 S009 的紀錄中有變數 dateF 的觀察值為 Missing Data 
#                        中間省略
# ID是 S092 的紀錄中有變數 dateF 的觀察值為 Missing Data 
# ID是 S093 的紀錄中有變數 dateF 的觀察值為 Missing Data 
# ID是 S097 的紀錄中有變數 dateF 的觀察值為 Missing Data 
# ID是 S099 的紀錄中有變數 dateF 的觀察值為 Missing Data 
# ID是 S100 的紀錄中有變數 dateF 的觀察值為 Missing Data 
```

<a id = 'sdcmissingdetector'> </a>

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
|NA_obs_out|是否印出具有遺漏值的觀察值|FALSE|logical|
#### References ####
Jung JO, Crnovrsanin N, Wirsik NM, Nienhüser H, Peters L, Popp F, Schulze A, Wagner M, Müller-Stich BP, Büchler MW, Schmidt T. Machine learning for optimized individual survival prediction in resectable upper gastrointestinal cancer. J Cancer Res Clin Oncol. 2023 May;149(5):1691-1702. doi: 10.1007/s00432-022-04063-5. Epub 2022 May 26. PMID: 35616729; PMCID: PMC10097798.
#### Examples ####
```R
# 封包匯入
# 模擬數據檔

# 預設值結果，僅列出變數的遺漏值比例
s.dc.missing_detector(DT = dataset)
# 變數 conA 中含有3%的遺漏值 
# 變數 conB 中含有4%的遺漏值 
# 變數 conC 中含有5%的遺漏值 
# 變數 strD 中含有10%的遺漏值 
# 變數 strE 中含有20%的遺漏值 
# 變數 dateF 中含有70%的遺漏值，比例超過50%，建議刪除 

# 列出變數的遺漏值比例，並列出包含NA值樣本的其他觀察值
s.dc.missing_detector(DT = dataset, NA_obs_out = TRUE)
# 變數 conA 中含有3%的遺漏值 
#      ID conA conB conC strD strE      dateF
# 47 S047 <NA>    6    5    A <NA>       <NA>
# 62 S062 <NA>    6    6    A   AA 2023-02-28
# 79 S079 <NA>    7    5    A   AA       <NA>

# 變數 conB 中含有4%的遺漏值 
#      ID conA conB conC strD strE      dateF
# 50 S050    7 <NA>    5    B   AA       <NA>
# 77 S077    5 <NA>    5    B <NA> 2023-05-22
# 91 S091    7 <NA>    4    C   AA       <NA>
# 94 S094    5 <NA>    5    C   BB 2021-12-26

# 變數 conC 中含有5%的遺漏值 
#      ID conA conB conC strD strE      dateF
# 2  S002    6    4 <NA>    C   BB 2021-11-11
# 38 S038    4    5 <NA>    C <NA>       <NA>
# 42 S042    6    4 <NA>    B <NA>       <NA>
# 67 S067    4    5 <NA>    C <NA> 2023-03-15
# 89 S089    4    5 <NA>    C <NA>       <NA>

# 變數 strD 中含有10%的遺漏值 
#      ID conA conB conC strD strE      dateF
# 8  S008    4    7    4 <NA>   AA       <NA>
# 14 S014    5    5    6 <NA>   BB       <NA>
# 37 S037    6    5    3 <NA>   AA       <NA>
# 40 S040    5    4    6 <NA>   BB 2023-10-12
# 48 S048    4    4    5 <NA>   CC 2022-04-07
# 54 S054    3    2    4 <NA>   CC       <NA>
# 55 S055    5    4    5 <NA>   BB 2023-10-08
# 63 S063    4    6    4 <NA>   AA       <NA>
# 80 S080    7    5    5 <NA>   BB       <NA>
# 87 S087    6    5    4 <NA>   AA       <NA>

# 變數 strE 中含有20%的遺漏值 
#       ID conA conB conC strD strE      dateF
# 3   S003    6    6    5    B <NA>       <NA>
# 5   S005    3    6    4    C <NA> 2021-08-24
# 6   S006    3    4    6    C <NA> 2023-06-01
# 17  S017    4    5    3    C <NA>       <NA>
# 22  S022    2    4    5    A <NA>       <NA>
#                   中間省略                  
# 77  S077    5 <NA>    5    B <NA> 2023-05-22
# 88  S088 -100    5    5    C <NA> 2023-10-03
# 89  S089    4    5 <NA>    C <NA>       <NA>
# 96  S096    4    4    5    C <NA> 2020-03-02
# 100 S100    5    4    5    C <NA>       <NA>

# 變數 dateF 中含有70%的遺漏值，比例超過50%，建議刪除 
#       ID conA  conB  conC strD strE dateF
# 1   S001    5 -1000     6    B   AA  <NA>
# 3   S003    6     6     5    B <NA>  <NA>
# 7   S007    5     6  1000    C   CC  <NA>
# 8   S008    4     7     4 <NA>   AA  <NA>
# 9   S009    6     5     5    C   AA  <NA>
#                  中間省略                 
# 92  S092    3     5     5    B   CC  <NA>
# 93  S093    5     4     4    C   AA  <NA>
# 97  S097    6     7     4    C   CC  <NA>
# 99  S099    5     6     5    B   BB  <NA>
# 100 S100    5     4     5    C <NA>  <NA>
```
<a id = 'sdcsamplemissing'> </a>

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
```R
# 封包匯入

# 模擬數據檔
set.seed(1234)
dataset2 <- as.data.table(data.frame(
  ID = paste0('S', sprintf("%03d", 1:30)),
  conA = sample(rnorm(30, mean = 5, sd = 1)),
  conB = sample(rnorm(30, mean = 5, sd = 1)),
  conC = sample(rnorm(30, mean = 5, sd = 1)),
  conD = sample(rnorm(30, mean = 5, sd = 1)),
  conE = sample(rnorm(30, mean = 5, sd = 1)),
  conF = sample(rnorm(30, mean = 5, sd = 1)),
  conG = sample(rnorm(30, mean = 5, sd = 1)),
  conH = sample(rnorm(30, mean = 5, sd = 1)),
  conI = sample(rnorm(30, mean = 5, sd = 1)),
  conK = sample(rnorm(30, mean = 5, sd = 1)),
  conL = sample(rnorm(30, mean = 5, sd = 1)),
  conM = sample(rnorm(30, mean = 5, sd = 1)),
  catN = sample(sample(c(1:5), 30, replace = TRUE)),
  catO = sample(sample(c(1:4), 30, replace = TRUE)),
  catP = sample(sample(c(1:3), 30, replace = TRUE))
))
NA_dataset <- copy(dataset2)
for (i in 1:(dim(dataset2)[2]-1)){
  NA_sample <- sample(1:3, 1)
  id_count <- sample(dataset2[['ID']], NA_sample)
  for (id in id_count){
    NA_var <- sample(colnames(dataset2)[-1], i)
    NA_dataset[ID == id, (NA_var) := NA]
  }
}

# 原始資料的樣本數
nrow(NA_dataset)
# 只要有遺漏值即刪除(遺漏值比例 > 0)
newDT00 <- s.dc.sample_missing(DT = NA_dataset, deleting_ratio = 0)
# 查看刪除後的樣本數
nrow(newDT00)
# 刪除遺漏值比例 > 0.1的所有樣本
newDT01 <- s.dc.sample_missing(DT = NA_dataset)
nrow(newDT01)
# 刪除遺漏值比例 > 0.5的所有樣本
newDT05 <- s.dc.sample_missing(DT = NA_dataset, deleting_ratio = 0.5)
nrow(newDT05)
# 刪除遺漏值比例 > 0.7的所有樣本
newDT07 <- s.dc.sample_missing(DT = NA_dataset, deleting_ratio = 0.7)
nrow(newDT07)
```
<a id = 'sdcmissingimputation'> </a>

### **s.dc.missing_imputation** ###
#### Description ####
針對選擇的欄位，有missing(NA)的觀察值做填補
#### Usage ####
newDT <- s.dc.missing_imputation <- function(DT, impute_list = NULL, exclude_list = NULL, impute_method = 'mean', decimal = 2)
#### Arguments ####
|參數名稱|參數敘述|預設值|參數型態|
|:----------|:----------|:----------:|:----------:|
|DT|要做填補的資料集||data.table|
|impute_list|**需要**做填補的欄位，若為NULL，表示所有欄位皆做填補|NULL|str vector|
|exclude_list|**不需要**做填補的欄位，將exclude_list內的欄位移出需填補的欄位後，針對需填補的欄位做填補|NULL|str vector|
|impute_method|選擇要做填補的方法，'mean'、'medium'、'mode'可供選擇|'mean'|str|
|decimal|填補方法選擇**mean**時，平均後的數值小數位數|2|number|
#### Examples ####
```R
# 封包匯入

# 模擬數據檔
# 封包匯入

# 模擬數據檔
set.seed(1234)
dataset3 <- as.data.table(data.frame(
  ID = paste0('S', sprintf("%03d", 1:30)),
  conA = sample(rnorm(30, mean = 5, sd = 1)),
  conB = sample(rnorm(30, mean = 5, sd = 1)),
  conC = sample(rnorm(30, mean = 5, sd = 1)),
  conD = sample(rnorm(30, mean = 5, sd = 1)),
  catN = sample(sample(c(1:5), 30, replace = TRUE)),
  catO = sample(sample(c(1:4), 30, replace = TRUE)),
  catP = sample(sample(c(1:3), 30, replace = TRUE))
))
NA_dataset <- copy(dataset3)
for (i in 1:(dim(dataset3)[2]-1)){
  NA_sample <- sample(1:3, 1)
  id_count <- sample(dataset2[['ID']], NA_sample)
  for (id in id_count){
    NA_var <- sample(colnames(dataset2)[-1], i)
    NA_dataset[ID == id, (NA_var) := NA]
  }
}
```

<a id = 'dataanalysis'> </a>
## **Data Analysis** ##
![假設檢定流程](https://github.com/Steven-CYCH/CYCHpackage/blob/50c7f560df810a3eec66db658d82316de0695b0f/Table1.png)  

<a id = 'table1pvalue'> </a>
### **table1_pvalue** ###
<a id = 'table1method'> </a>
### **table1_method** ###