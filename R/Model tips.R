# library(data.table)
#
# DT <- fread('C:\\Users\\kkk\\Desktop\\logistic_regression_data.csv')
# DT[, `:=`(X8 = factor(X8), X9 = factor(X9), X10 = factor(X10))]

s.mt.reduce.lm <- function(datasets, var.y, var.x = c(), threshold = 0.1, del.var.x = c()){

  datasets <- as.data.table(datasets)

  if (is.null(var.x)){
    var.x <- colnames(datasets)[!(colnames(datasets) %in% c(var.y, del.var.x))]
  }else{
    var.x <- var.x[!(var.x %in% c(var.y, del.var.x))]
  }

  simple.p <- data.table(var = NULL, p = NULL)

  for (simplevar in var.x){
    # simplevar <- var.x[1]
    DT.simple <- as.data.table(copy(datasets[, get(var.y)]))
    colnames(DT.simple) <- var.y
    DT.simple[, eval(simplevar) := datasets[, get(simplevar)]]

    simple.lm.fr <- formula(paste0(var.y, ' ~ ', simplevar))
    simple.lm <- lm(simple.lm.fr, data = DT.simple)

    lm.summary <- as.data.frame(summary(simple.lm)$coefficients)
    var.p <- lm.summary['Pr(>|t|)'][-1, ]

    simple.p.cache <- data.table(var = simplevar, p = var.p)

    simple.p <- rbind(simple.p, simple.p.cache)
  }

  var.x.LR.R <- simple.p[p < threshold, var][!duplicated(simple.p[p < threshold, var])]

  if (length(var.x.LR.R) == 0){
    stop('There is no significance variable in Full linear regression model')
  }else{
    fr.LR.R <- paste(var.x.LR.R, collapse = ' + ')
    fr.LR.R <- formula(paste0(var.y, ' ~ ', fr.LR.R))

    LR.R <- lm(fr.LR.R, data = datasets)
    # summary(LR.R)

    return(LR.R)
  }
}


# lm <- s.mt.reduce.lm(datasets = test.data, var.y = 'var2')

s.mt.adjust.glm <- function(datasets, var.y, var.x = c(), confounder = c(), threshold = 0.1, del.var.x = c()){

  # datasets = DT
  # var.y = 'Y1'
  #
  # var.x = c()
  #
  # threshold = 0.4
  # del.var.x = c('X1', 'X2')
  # confounder = paste0('Z', 1:5)

  datasets <- as.data.table(datasets)

  if (is.null(var.x)){
    var.x <- colnames(datasets)[!(colnames(datasets) %in% c(var.y, del.var.x, confounder))]
  }else{
    var.x <- var.x[!(var.x %in% c(var.y, del.var.x, confounder))]
  }

  simple.p <- data.table(var = NULL, p = NULL)

  for (simplevar in var.x){
    # simplevar <- var.x[6]
    varlist <- c(var.y, confounder, simplevar)
    DT.simple <- datasets[, ..varlist]

    simple.glm.fr <- formula(paste0(var.y, ' ~ ', paste(c(confounder, simplevar), collapse = ' + ')))
    simple.glm <- glm(simple.glm.fr, data = DT.simple, family = 'binomial')

    glm.summary <- as.data.frame(summary(simple.glm)$coefficients)
    var.name <- rownames(glm.summary)[grepl(simplevar, rownames(glm.summary))]
    var.p <- glm.summary['Pr(>|z|)'][var.name, ]

    simple.p.cache <- data.table(var = simplevar, p = min(var.p))

    simple.p <- rbind(simple.p, simple.p.cache)

    if (min(var.p) < threshold){
      cat('The variable：', simplevar, 'were include in Adjust Model')
    }
  }

  var.x.adj.glm <- simple.p[p < threshold, var][!duplicated(simple.p[p < threshold, var])]

  if (length(var.x.adj.glm) == 0){
    stop('There is no significance variable in Crude logistic regression model')
  }else{
    fr.adj.glm <- paste(c(confounder, var.x.adj.glm), collapse = ' + ')
    fr.adj.glm <- formula(paste0(var.y, ' ~ ', fr.adj.glm))

    adj.glm <- glm(fr.adj.glm, data = datasets, family = 'binomial')
    # summary(adj.glm)

    return(adj.glm)
  }
}

# glm <- s.mt.adjust.glm(datasets = DT, var.y = 'Y1', confounder = paste0('Z', 1:5), threshold = 0.7)
