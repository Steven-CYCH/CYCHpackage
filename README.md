# CYCHpackage 說明書 #
**Package：** CYCHpackage  
**Title：** Some Statistical method for medical research  
**Version：** 0.5.0  
**Author：** Sheng-You Su Assistant Research Fellow  
**Email：** cych15334@gmail.com  
**Dependence Packages：**

## **Data Clean** ##

### **<font face="Lucida Console">s.dc.outlier_detector</font>** ###

#### Description ####
1. 針對**變數**(直欄)列出是否有離群值
2. 針對**變數**列出是否有遺漏值

#### Usage ####
<font face="Lucida Console">s.dc.outlier_detector(dataset, ID_name = 'ID', sig_num = 3, NA_obs_out = FALSE, in_list = NULL, out_list = NULL)</font>  

#### Arguments ####
|參數名稱|參數敘述|預設值|參數型態|
|:----------|:----------|:----------:|:----------:|
|<font face="Lucida Console">dataset</font>|輸入要檢查離群值或遺漏的資料集名稱||data.table|
|<font face="Lucida Console">ID_name</font>|辨識樣本的唯一鍵值|<font face="Lucida Console">"ID"</font>|character|
|<font face="Lucida Console">sig_num</font>|辨識離群值時，預期的標準差倍數，範圍[mean - sig_num * sd, mean + sig_num * sd]以外的觀察值會被列入候選離群值被印出|<font face="Lucida Console">3</font>|numeric|
|<font face="Lucida Console">NA_obs_out</font>|是否印出具有遺漏值的觀察值|<font face="Lucida Console">FALSE</font>|boolean|
|<font face="Lucida Console">in_list</font>|**要**被納入檢查離群值的變數名稱|<font face="Lucida Console">NULL</font>|vector|
|<font face="Lucida Console">out_list</font>|**不要**被納入檢查離群值的變數名稱|<font face="Lucida Console">NULL</font>|vector|

#### References ####
#### Examples ####

### <font face="Lucida Console">**s.dc.missing_detector**</font> ###
#### Description ####
1. 計算各**變數**遺漏值比例
2. 印出有**遺漏值**的樣本觀察值(包含其識別ID)

#### Usage ####
<font face="Lucida Console">s.dc.missing_detector(dataset, ID_name, listout_col = NULL, NA_obs_out = FALSE)</font> 

#### Arguments ####
|參數名稱|參數敘述|預設值|參數型態|
|:----------|:----------|:----------:|:----------:|
|<font face="Lucida Console">dataset</font>|輸入要檢查離群值或遺漏值的資料集名稱|     |data.table|
|<font face="Lucida Console">listout_col</font>|**要**被納入檢查遺漏值的變數名稱|<font face="Lucida Console">NULL</font>|vector|
|<font face="Lucida Console">NA_obs_out</font>|是否印出具有遺漏值的觀察值|<font face="Lucida Console">FALSE</font>|boolean|
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
