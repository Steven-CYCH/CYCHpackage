# CYCHpackage 說明書 #
**Package：** CYCHpackage  
**Title：** Some Statistical method for research  
**Version：** 0.5.0  
**Author：** Sheng-You Su Assistant Research Fellow  
**Email：** cych15334@gmail.com  

## **Data Clean** ##

### **s.dc.outlier_detector** ###

#### Description ####
1. 針對變數列出是否有離群值
2. 針對變數列出是否有遺漏值

#### Usage ####
<font face="Lucida Console">s.dc.outlier_detector(dataset, ID_name = 'ID', sig_num = 3, NA_obs_out = FALSE, in_list = NULL, out_list = NULL)</font>  

#### Arguments ####
$
\begin{array}{ll}
\tt{dataset} & 輸入要檢查離群值或遺漏的資料集名稱 \\
\tt{ID\_name} & 辨識樣本的唯一鍵值，以\tt{character}的格式輸入，預設為\tt{"ID"} \\
\tt{sig\_num} & 辨識離群值時，預期的標準差倍數，範圍\tt{[mean - sig\_num \times sd, mean + sig\_num \times sd]}以外的觀察值會被列入候選離群值被印出
\end{array}
$
\tt{dataset}\\ 輸入要檢查離群值或遺漏的資料集名稱  
<font face="Lucida Console">ID_name</font> 辨識樣本的唯一鍵值，以character的格式輸入，預設為<font face="Lucida Console">"ID"</font>  
<font face="Lucida Console">sig_num</font> 辨識離群值時，預期的標準差倍數，範圍$[mean - sig\_num \times sd, mean + sig\_num \times sd]$以外的觀察值會被列入候選離群值被印出

#### References ####
#### Examples ####

### **s.dc.missing_detector** ###
#### Description ####
1. 計算各變數遺漏值比例
2. 印出遺漏值的資料部分
#### Usage ####
#### Arguments ####
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
