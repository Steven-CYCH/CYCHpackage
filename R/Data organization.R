# s.do ----
# Data organization ----
# 有序類別的Label Encoding ----
s.do.labeled <- function(DT, label_colName, before_labeled, after_labeled, rawCol_remove = FALSE){
  # DT <- DT.id
  # label_colName <- 'life'
  # before_labeled <- c('VD', 'D', 'N', 'S', 'VS')
  # after_labeled <- 1:5

  if (!('data.table' %in% class(DT))){
    DT <- as.data.table(DT)
  }

  dataset <- copy(DT)

  if (label_colName %in% colnames(dataset)){
    if (length(before_labeled) == length(after_labeled)){
      new_var <- paste0(label_colName, '_n')
      dataset[, (new_var) := 0]
      for (i in 1:length(before_labeled)){
        # i <- 1
        var <- label_colName
        dataset[get(var) == before_labeled[i], (new_var) := after_labeled[i]]
      }
    }else{
      stop('before_labeled與after_labeled必須有一一對應')
    }
  }else{
    stop('資料集中無要Encoding的變數，請先確認label_colName為dataset中的變數名稱')
  }

  if (rawCol_remove == TRUE){
    dataset[, (label_colName) := NULL]
    setnames(dataset, new_var, label_colName)
  }

  return(dataset)
}

# 無序類別的Dummy Variable ----
s.do.dummy <- function(DT, dummy_col_List, not_dummy_col_List = NULL, rawCol_remove = TRUE){
  # DT <- DT.id
  # dummy_col_List <- c('sex', 'race')
  # not_dummy_col_List = c('ID', 'birthday', 'sex')
  # rawCol_remove = TRUE

  if (!('data.table' %in% class(DT))){
    DT <- as.data.table(DT)
  }

  DT <- copy(DT)

  if (all(dummy_col_List %in% colnames(DT)) == TRUE){
    if (is.null(dummy_col_List)){
      stop('請輸入欲設定啞巴變量(dummy variable)的變數名稱')
    }else if (is.null(not_dummy_col_List)){
      DT <- dummy_cols(DT, select_columns = dummy_col_List, remove_most_frequent_dummy = TRUE, remove_selected_columns = rawCol_remove)
    }else if (is.null(not_dummy_col_List) == FALSE){
      dummy_col_List <- dummy_col_List[!(dummy_col_List %in% not_dummy_col_List)]
      DT <- dummy_cols(DT, select_columns = dummy_col_List, remove_most_frequent_dummy = TRUE, remove_selected_columns = rawCol_remove)
    }
    # reference remove 的功能現正開發中
  }else{
    stop('資料集中無要Dummy的變數，請先確認label_colName為dataset中的變數名稱')
  }

  return(DT)
}
