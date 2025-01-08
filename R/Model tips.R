# library(data.table)
#
# set.seed(1234)
# test.data <- data.table(var1 = sample(0:100, 50, replace = TRUE),
#                         var2 = sample(c('Yes', 'No'), 50, replace = TRUE),
#                         var3 = sample(0:100, 50, replace = TRUE))

reduce.lm <- function(datasets, var.y, var.x = c(), threshold = 0.1, del.var.x = c()){

  # datasets <- test.data
  # var.y <- 'var3'
  #
  # threshold = 0.3
  # del.var.x = c()

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
    stop('There is no significance variable in simple linear regression model')
  }else{
    fr.LR.R <- paste(var.x.LR.R, collapse = ' + ')
    fr.LR.R <- formula(paste0(var.y, ' ~ ', fr.LR.R))

    LR.R <- lm(fr.LR.R, data = datasets)
    # summary(LR.R)

    return(LR.R)
  }
}
