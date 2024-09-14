# pvalue_function
# ├── 是否為數值型變量？
# │   ├── 是
# │   │   ├── 組別數量 == 2？
# │   │   │   ├── 是
# │   │   │   │   ├── 所有組別樣本數 > 30？
# │   │   │   │   │   ├── 是
# │   │   │   │   │   │   ├── 變異數同質性檢定（var.test）
# │   │   │   │   │   │   │   ├── 變異數同質性成立 → t-test
# │   │   │   │   │   │   │   └── 變異數同質性不成立 → Welch's t-test
# │   │   │   │   │   └── 否 → Wilcoxon rank sum test
# │   │   │   └── 組別數量 > 2
# │   │   │       ├── 所有組別樣本數 > 30？
# │   │   │       │   ├── 是
# │   │   │       │   │   ├── 變異數同質性檢定（var.test）
# │   │   │       │   │   │   ├── 變異數同質性成立 → ANOVA
# │   │   │       │   │   │   └── 變異數同質性不成立 → Welch's ANOVA
# │   │   │       │   └── 否 → Kruskal-Wallis test
# │   └── 否
# │       ├── 表格中 < 5 的期望次數格子占比 >= 20%？
# │       │   ├── 是 → Fisher's Exact test
# │       │   └── 否 → Chi-square test

table1_pvalue <- function(x, ...) {
  # Construct vectors of data y, and groups (strata) g
  y <- unlist(x)
  g <- factor(rep(1:length(x), times = sapply(x, length)))
  if (is.numeric(y)) {
    # For numeric variables, perform a standard 2-sample t-test
    if (length(levels(g)) == 2){
      if (all(table(g) > 30) == TRUE){
        if (var.test(y ~ g)$p.value > 0.05) {
          p <- t.test(y ~ g, var.equal = TRUE)$p.value
        } else {
          p <- t.test(y ~ g, var.equal = FALSE)$p.value
        }
      }else{
        p <- wilcox.test(y ~ g)$p.value
      }
    }else if (length(levels(g)) > 2){
      if (all(table(g) > 30) == TRUE){
        if (var.test(y ~ g)$p.value > 0.05) {
          p <- summary(aov(y ~ g))[[1]][["Pr(>F)"]][1]
        } else {
          p <- oneway.test(y ~ g, var.equal = FALSE)$p.value
        }
      }else{
        p <- kruskal.test(y ~ g)$p.value
      }
    }
  } else {
    # For categorical variables, perform a chi-squared test of independence
    less5count <- sum(table(y, g) < 5)
    allCount <- sum(table(y, g) >= 0)
    ratio <- less5count / allCount
    if (ratio >= 0.2){
      p <- fisher.test(table(y, g))$p.value
    }else{
      p <- chisq.test(table(y, g))$p.value
    }
  }
  sub("<", "&lt;", format.pval(p, digits=3, eps=0.001))
}

table1_method <- function(x, ...) {
  # Construct vectors of data y, and groups (strata) g
  y <- unlist(x)
  g <- factor(rep(1:length(x), times = sapply(x, length)))
  if (is.numeric(y)) {
    # For numeric variables, perform a standard 2-sample t-test
    if (length(levels(g)) == 2){
      if (all(table(g) > 30) == TRUE){
        if (var.test(y ~ g)$p.value > 0.05) {
          m <- "t-test"
        } else {
          m <- "Welch's t-test"
        }
      }else{
        m <- 'Wilcoxon rank sum test'
      }
    }else if (length(levels(g)) > 2){
      if (all(table(g) > 30) == TRUE){
        if (var.test(y ~ g)$p.value > 0.05) {
          m <- "ANOVA"
        } else {
          m <- "Welch's ANOVA"
        }
      }else{
        m <- 'Kruskal-Wallis test'
      }
    }
  } else {
    # For categorical variables, perform a chi-squared test of independence
    less5count <- sum(table(y, g) < 5)
    allCount <- sum(table(y, g) >= 0)
    ratio <- less5count / allCount
    if (ratio >= 0.2){
      m <- "Fisher's Exact test"
    }else{
      m <- "Chi-square test"
    }
  }
}
