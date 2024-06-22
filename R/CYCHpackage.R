# Package: CYCHpackage
# Type: Package
# Title: Some Statistical method for research
# Version: 0.5.0
# Author: Sheng-You Su Assistant Research Fellow
# Maintainer: The package maintainer <cych15334@gmail.com>
# Description: 0.1.0 function addition 's.dc.outlier_detector'
#              0.1.1 function 's.dc.outlier_detector' modifty error massage
#              0.2.0 function addition 's.dc.outlier_detector'
#              0.2.1 function 's.dc.outlier_detector' rename from 's.dc.var_outlier'
#              0.3.0 function addition 's.dc.sample_missing'
#              0.3.1 function 's.dc.outlier_detector' modifty NA_omit
#              0.4.0 function 's.dc.missing_imputation' modifty donot print dataset
#              0.5.0 function addition 's.dc.missing_detector'
# License: R 4.3.2 data.table 1.15.4
# Encoding: UTF-8
# LazyData: true

library(data.table)
library(DataExplorer)
library(bazar)

# s.dc ----
# data clean ----
# 異常值偵測 ----
s.dc.outlier_detector <- function(dataset, ID_name = 'ID', sig_num = 3, NA_obs_out = FALSE, in_list = NULL, out_list = NULL) {
  # 參數名稱定義
  # dataset 要檢查離群值的dataset名稱
  # ID_name ID不被納入檢測，以'字串'型態輸入
  # sig_num sigma number，欲偵測的標準差倍數，以數值型態輸入
  # NA_omit 列出離群值的過程中是否一併列出遺漏值(missing)
  # in_list 需要被檢測的變數名稱，以c('', '')輸入
  # out_list 不被檢測的變數名稱，以c('', '')輸入

  if (ID_name %in% colnames(dataset)){
    dataset <- as.data.table(dataset)
    out_list <- append(out_list, ID_name)

    # 整理需要被檢測的變數
    if (is.null(in_list)){
      in_list <- colnames(dataset)[-which(colnames(dataset) %in% out_list)]
    }else{
      if (any(in_list %in% out_list) == TRUE){
        in_list <- in_list[-which(in_list %in% out_list)]
      }else{
        in_list <- in_list
      }
    }

    # 設定離群值的上下界
    for (variable in in_list) {
      cat('\n\n')
      cat(variable, '\n')
      dataset <- as.data.frame(dataset)
      observation <- dataset[[variable]]
      if (NA_obs_out == FALSE){
        observation.na <- observation[!is.na(observation)]
        if (length(observation.na) != length(observation)){
          cat('變數', variable, '含有NA值，但已省略輸出')
        }
      }
      options(warn = -1)
      mean_value <- mean(observation, na.rm = TRUE)
      standard_deviation <- sd(observation, na.rm = TRUE)
      options(warn = 1)
      upper_bound <- mean_value + standard_deviation * sig_num
      lower_bound <- mean_value - standard_deviation * sig_num

      if ((is.na(upper_bound) & is.na(lower_bound)) != TRUE){
        # 針對各觀察值檢測其是否超出離群值範圍
        for (i in 1:dim(dataset)[1]) {
          obs <- dataset[i, variable]
          if (is.na(obs)){
            if (NA_obs_out == FALSE){
              cat('ID是', dataset[[ID_name]][i], '的紀錄中有變數', variable, '的觀察值為 Missing Data \n')
            }
          }else{
            if (obs > upper_bound | obs < lower_bound) {
              # cat('The observed value of variable ', variable, 'in the record with ID ', i, 'is suspected to be an outlier, and the observed value is ', obs, '\n')
              cat('ID是', dataset[[ID_name]][i], '的紀錄中有變數', variable, '的觀察值疑似為離群值，觀察值為', obs, '\n')
            }
          }
        }
      }else{
        cat('該變數觀察值型態非為數值')
      }
    }
  }else{
    stop('親愛的朋友，你的ID不是這個名字喔！')
  }
}


# 遺漏值偵測 ----
s.dc.missing_detector <- function(dataset, ID_name = 'ID', listout_col = NULL, NA_obs_out = FALSE){
  # 參數名稱定義
  # dataset 要檢查遺漏值的dataset名稱
  # ID_name ID不被納入檢測，以'字串'型態輸入
  # listout_col 檢測過程中需列出參考的欄位，以c('', '')輸入
  # NA_obs_out 檢測過程中是否列出NA的觀察值

  # dataset <- DT.exam
  # ID_name <- 'ID'
  # listout_col <- NULL
  # NA_obs_out <- TRUE

  if (ID_name %in% colnames(dataset)){
    if (is.null(listout_col)){
      listout_col <- colnames(dataset)
    }

    DT <- as.data.frame(dataset)
    for (colName in colnames(DT)[-which(colnames(DT) == ID_name)]){
      # colName <- 'Height'
      # colName <- 'GPT'
      # print(colName)
      obs <- DT[colName][[1]]
      typeis <- class(obs)
      if (typeis %in% c('integer', 'numeric')){
        missDT <- DT[is.na(obs) == TRUE, listout_col]
      }else{
        if (dim(DT[obs == '', ])[1] != 0){
          missDT <- DT[obs == '', listout_col]
        }else{
          missDT <- DT[is.na(obs) == TRUE, listout_col]
        }
      }


      if (dim(missDT)[1] != 0){
        missing.ratio <- (dim(missDT)[1]/dim(DT)[1]) * 100
        waring <- paste0('變數 ', colName, ' 中含有', round(missing.ratio, digits = 2), '%的遺漏值')
        if (missing.ratio > 50){
          waring <- paste0(waring, '，比例超過50%，建議刪除')
          cat(waring, '\n')
        }else{
          cat(waring, '\n')
        }
        if (NA_obs_out == TRUE){
          print(missDT)
        }
        cat('\n')
      }
    }
  }else{
    stop('親愛的朋友，你的ID不是這個名字喔！')
  }
  print('The reference doi is：10.1007/s00432-022-04063-5')
}

# 樣本遺漏刪除處理 ----
s.dc.sample_missing <- function(dataset, deleting_ratio = 0.1){
  # 參數名稱定義
  # dataset 要檢查遺漏值的dataset名稱，以data.table形式輸入
  # deleting_ratio 樣本觀察值超過該比例的遺失刪除，以小數輸入
  # The reference doi is：10.1007/s00432-022-04063-5

  dataset <- cbind(cacheID = 1:dim(dataset)[1], dataset)
  analysis_transpose <- data.table(t(dataset))
  names(analysis_transpose) <- as.character(dataset$cacheID)
  analysis_m <- profile_missing(analysis_transpose)
  analysis_m <- as.data.frame(analysis_m)
  include_pt <- as.numeric(as.vector(analysis_m[analysis_m['pct_missing'] <= deleting_ratio, colnames(analysis_m)[1]]))
  dataset <- dataset[dataset$cacheID %in% include_pt, ]
  dataset <- subset(dataset, select = -cacheID)

  return(dataset)
}


# 遺漏填補處理 ----
s.dc.missing_imputation <- function(dataset, impute_list = NULL, exclude_list = NULL, impute_method = 'mean') {
  # 參數名稱定義
  # dataset 要填補的dataset名稱
  # impute_list 需要做填補的變數名稱，不可包含ID
  # exclude_list 不需要做填補的變數名稱，若有ID需包含ID
  # impute_method 做填補的方法，可選mean(平均)、median(中位數)或mode(眾數)

  dataset <- as.data.table(dataset)

  # 整理需要被填補的變數
  if (is.null(impute_list) & is.null(exclude_list)){
    stop('請輸入要填補的變數名稱，或至少指定一個不填補的變數(若有ID需指定ID)')
  }else if(is.null(impute_list) == TRUE & is.null(exclude_list) == FALSE){
    impute_list <- colnames(dataset)[-which(colnames(dataset) %in% exclude_list)]
  }else if(is.null(exclude_list) == TRUE & is.null(impute_list) == FALSE){
    impute_list <- impute_list
  }else{
    impute_list <- impute_list[-which(impute_list %in% exclude_list)]
  }

  dataset <- as.data.frame(dataset)
  for (variable in impute_list) {
    cat('\n')
    cat(variable)
    observation <- dataset[[variable]]
    na_num <- length(observation[is.na(observation)])

    if (na_num != 0){
      if (impute_method == 'mean'){
        impute_value <- mean(observation, na.rm = TRUE)
      }else if(impute_method == 'median'){
        impute_value <- median(observation, na.rm = TRUE)
      }else if(impute_method == 'mode'){
        impute_value <- mean(as.numeric(names(table(observation)))[table(observation) == max(table(observation))])
      }
      observation[is.na(observation)] <- impute_value
      dataset[[variable]] <- observation
      cat('填補完成')
    }
  }
  return(dataset)
}
