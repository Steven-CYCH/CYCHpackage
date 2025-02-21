# ├── 是否為連續型變量？
#     ├── 是
#     │   ├── 組別數量 == 2？
#     │       ├── 是
#     │       │   ├── 所有組別樣本數 > 30？
#     │       │       ├── 是
#     │       │       │   ├── 常態性成立？
#     │       │       │       ├── 是
#     │       │       │       │   ├── 變異數同質性檢定（var.test）
#     │       │       │       │       ├── 變異數同質性成立 → t-test
#     │       │       │       │       └── 變異數同質性不成立 → Welch's t-test
#     │       │       │       └── 否 → Wilcoxon rank sum test
#     │       │       └── 否 → Wilcoxon rank sum test
#     │       └── 否
#     │           ├── 所有組別樣本數 > 30？
#     │               ├── 是
#     │               │   ├── 變異數同質性檢定（var.test）
#     │               │       ├── 變異數同質性成立 → ANOVA
#     │               │       └── 變異數同質性不成立 → Welch's ANOVA
#     │               └── 否 → Kruskal-Wallis test
#     └── 否
#         ├── 所有組別樣本數 > 40？
#             ├── 是
#             │   ├── 觀察次數 < 5 的比例 >= 0.2？
#             │       ├── 是 → Fisher's Exact Test
#             │       └── 否
#             │           ├── 自由度 == 1？
#             │               ├── 是
#             │               │   ├── 所有期望次數 >= 10？
#             │               │       ├── 是 → 卡方檢定 (不校正)
#             │               │       └── 否 → 卡方檢定 (校正)
#             │               └── 否 → 卡方檢定 (不校正)
#             └── 否 → Fisher's Exact Test


# # Simulate continuous data
# x <- list(
#   group1 = rnorm(35, mean = 50, sd = 10),  # 第一組資料（35個樣本）
#   group2 = rnorm(40, mean = 55, sd = 10),  # 第二組資料（40個樣本）
#   group3 = rnorm(50, mean = 45, sd = 15)   # 第二組資料（40個樣本）
# )
# # Simulate discrete data
# x <- list(
#   group1 = c("A", "A", "B", "B", "A", "A", "B"),  # 第一組資料（類別型）
#   group2 = c("B", "B", "A", "A", "B", "B", "A")   # 第二組資料（類別型）
# )

table1_pvalue <- function(x, ...) {
  y <- unlist(x)
  g <- factor(rep(1:length(x), times = sapply(x, length)))
  if (is.numeric(y)) {
    if (length(levels(g)) == 2){
      if (all(table(g) > 30) == TRUE){
        g1 <- y[g == '1']
        g2 <- y[g == '2']
        normal.test.g1 <- shapiro.test(g1)$p.value
        normal.test.g2 <- shapiro.test(g2)$p.value
        test1.p <- any(c(normal.test.g1, normal.test.g2) < 0.05)
        normal.test.g1 <- ad.test(g1)$p.value
        normal.test.g2 <- ad.test(g2)$p.value
        test2.p <- any(c(normal.test.g1, normal.test.g2) < 0.05)
        non.normal <- all(test1.p, test2.p)
        if (non.normal == FALSE){
          if (var.test(y ~ g)$p.value > 0.05) {
            p <- t.test(y ~ g, var.equal = TRUE)$p.value
          } else {
            p <- t.test(y ~ g, var.equal = FALSE)$p.value
          }
        }else{
          p <- wilcox.test(y ~ g)$p.value
        }
      }else{
        p <- wilcox.test(y ~ g)$p.value
      }
    }else if (length(levels(g)) > 2){
      if (all(table(g) > 30) == TRUE){
        vartest <- leveneTest(y ~ g)$`Pr(>F)`[1]
        if (!is.na(vartest) & vartest > 0.05) {
          p <- summary(aov(y ~ g))[[1]][["Pr(>F)"]][1]
        } else if (!is.na(vartest) & vartest <= 0.05){
          p <- oneway.test(y ~ g, var.equal = FALSE)$p.value
        } else {
          p <- NA
        }
      }else{
        p <- kruskal.test(y ~ g)$p.value
      }
    }
  } else {
    less5count <- sum(table(y, g) < 5)
    allCount <- sum(table(y, g) >= 0)
    ratio <- less5count / allCount
    exp.TB <- chisq.test(table(y, g))
    if(sum(table(g)) > 40){
      if(ratio >= 0.2){
        result <- try({
          set.seed(1234)
          fisher.test(table(y, g), simulate.p.value = TRUE)$p.value
          }, silent = TRUE)
        if (inherits(result, "try-error")) {
          message("過多0於觀察個數中")
          p <- '無法計算'
        } else {
          p <- result
        }
      }else{
        if(exp.TB$parameter[['df']] == 1){
          if(all(exp.TB$expected >= 10)){
            p <- chisq.test(table(y, g), correct = FALSE)$p.value
          }else{
            p <- chisq.test(table(y, g), correct = TRUE)$p.value
          }
        }else{
          p <- chisq.test(table(y, g), correct = FALSE)$p.value
        }
      }
    }else{
      result <- try({
        set.seed(1234)
        fisher.test(table(y, g), simulate.p.value = TRUE)$p.value
      }, silent = TRUE)
      if (inherits(result, "try-error")) {
        message("過多0於觀察個數中")
        p <- '無法計算'
      } else {
        p <- result
      }
    }
  }
  result <- try({
    sub("<", "&lt;", format.pval(p, digits=3, eps=0.001))
  }, silent = TRUE)
  if (inherits(result, "try-error")) {
    p <- NA
  } else {
    sub("<", "&lt;", format.pval(p, digits=3, eps=0.001))
  }
}

table1_method <- function(x, ...) {
  y <- unlist(x)
  g <- factor(rep(1:length(x), times = sapply(x, length)))
  if (is.numeric(y)) {
    if (length(levels(g)) == 2){
      if (all(table(g) > 30) == TRUE){
        g1 <- y[g == '1']
        g2 <- y[g == '2']
        normal.test.g1 <- shapiro.test(g1)$p.value
        normal.test.g2 <- shapiro.test(g2)$p.value
        test1.p <- any(c(normal.test.g1, normal.test.g2) < 0.05)
        normal.test.g1 <- ad.test(g1)$p.value
        normal.test.g2 <- ad.test(g2)$p.value
        test2.p <- any(c(normal.test.g1, normal.test.g2) < 0.05)
        non.normal <- all(test1.p, test2.p)
        if (non.normal == FALSE){
          if (var.test(y ~ g)$p.value > 0.05) {
            m <- 'Independent t-test'
          } else {
            m <- "Welch's t-test"
          }
        }else{
          m <- 'Wilcoxon Rank Sum Test'
        }
      }else{
        m <- 'Wilcoxon Rank Sum Test'
      }
    }else if (length(levels(g)) > 2){
      if (all(table(g) > 30) == TRUE){
        vartest <- leveneTest(y ~ g)$`Pr(>F)`[1]
        if (!is.na(vartest) & vartest > 0.05) {
          m <- "ANOVA"
        } else if (!is.na(vartest) & vartest <= 0.05){
          m <- "Welch's ANOVA"
        } else {
          m <- NA
        }
      }else{
        m <- 'Kruskal-Wallis test'
      }
    }
  } else {
    less5count <- sum(table(y, g) < 5)
    allCount <- sum(table(y, g) >= 0)
    ratio <- less5count / allCount
    exp.TB <- chisq.test(table(y, g))
    if(sum(table(g)) > 40){
      if(ratio >= 0.2){
        m <- "Fisher's Exact test"
      }else{
        if(exp.TB$parameter[['df']] == 1){
          if(all(exp.TB$expected >= 10)){
            m <- "Chi-square test"
          }else{
            m <- "Chi-square test with Yates' continuity correction"
          }
        }else{
          m <- "Chi-square test"
        }
      }
    }else{
      m <- "Fisher's Exact test"
    }
  }
}






table1_pvalue_simple <- function(x, ...) {
  y <- unlist(x)
  g <- factor(rep(1:length(x), times = sapply(x, length)))
  # print(g)
  if (is.numeric(y)) {
    if (length(levels(g)) == 2){
      if (var.test(y ~ g)$p.value > 0.05) {
        p <- t.test(y ~ g, var.equal = TRUE)$p.value
      } else {
        p <- t.test(y ~ g, var.equal = FALSE)$p.value
      }
    }else if (length(levels(g)) > 2){
      vartest <- leveneTest(y ~ g)$`Pr(>F)`[1]
      if (!is.na(vartest) & vartest > 0.05) {
        p <- summary(aov(y ~ g))[[1]][["Pr(>F)"]][1]
      } else if (!is.na(vartest) & vartest <= 0.05) {
        p <- oneway.test(y ~ g, var.equal = FALSE)$p.value
      }else{
        p <- NA
      }
    }
  } else {
    less5count <- sum(table(y, g) < 5)
    allCount <- sum(table(y, g) >= 0)
    ratio <- less5count / allCount
    exp.TB <- chisq.test(table(y, g))
    if(sum(table(g)) > 40){
      if(ratio >= 0.2){
        result <- try({
          set.seed(1234)
          fisher.test(table(y, g), simulate.p.value = TRUE)$p.value
        }, silent = TRUE)
        if (inherits(result, "try-error")) {
          message("過多0於觀察個數中")
          p <- '無法計算'
        } else {
          p <- result
        }
      }else{
        if(exp.TB$parameter[['df']] == 1){
          if(all(exp.TB$expected >= 10)){
            p <- chisq.test(table(y, g), correct = FALSE)$p.value
          }else{
            p <- chisq.test(table(y, g), correct = FALSE)$p.value
          }
        }else{
          p <- chisq.test(table(y, g), correct = FALSE)$p.value
        }
      }
    }else{
      result <- try({
        set.seed(1234)
        fisher.test(table(y, g), simulate.p.value = TRUE)$p.value
      }, silent = TRUE)
      if (inherits(result, "try-error")) {
        message("過多0於觀察個數中")
        p <- '無法計算'
      } else {
        p <- result
      }
    }
  }
  result <- try({
    sub("<", "&lt;", format.pval(p, digits=3, eps=0.001))
  }, silent = TRUE)
  if (inherits(result, "try-error")) {
    p <- NA
  } else {
    sub("<", "&lt;", format.pval(p, digits=3, eps=0.001))
  }
}



table1_method_simple <- function(x, ...) {
  y <- unlist(x)
  g <- factor(rep(1:length(x), times = sapply(x, length)))
  if (is.numeric(y)) {
    if (length(levels(g)) == 2){
      if (var.test(y ~ g)$p.value > 0.05) {
        m <- 'Independent t-test'
      } else {
        m <- "Welch's t-test"
      }
    }else if (length(levels(g)) > 2){
      vartest <- leveneTest(y ~ g)$`Pr(>F)`[1]
      if (!is.na(vartest) & vartest > 0.05) {
        m <- "ANOVA"
      } else if (!is.na(vartest) & vartest <= 0.05) {
        m <- "Welch's ANOVA"
      }else{
        m <- NA
      }
    }
  } else {
    less5count <- sum(table(y, g) < 5)
    allCount <- sum(table(y, g) >= 0)
    ratio <- less5count / allCount
    exp.TB <- chisq.test(table(y, g))
    if(sum(table(g)) > 40){
      if(ratio >= 0.2){
        result <- try({
          set.seed(1234)
          fisher.test(table(y, g), simulate.p.value = TRUE)$p.value
        }, silent = TRUE)
        if (inherits(result, "try-error")) {
          message("過多0於觀察個數中")
          m <- NA
        } else {
          m <- "Fisher's Exact test"
        }
      }else{
        if(exp.TB$parameter[['df']] == 1){
          if(all(exp.TB$expected >= 10)){
            m <- "Chi-square test"
          }else{
            m <- "Chi-square test"
          }
        }else{
          m <- "Chi-square test"
        }
      }
    }else{
      result <- try({
        set.seed(1234)
        fisher.test(table(y, g), simulate.p.value = TRUE)$p.value
      }, silent = TRUE)
      if (inherits(result, "try-error")) {
        message("過多0於觀察個數中")
        m <- NA
      } else {
        m <- "Fisher's Exact test"
      }
    }
  }
}

render.cont <- function(x) {
  # 計算基本統計量
  stats <- stats.default(x)

  # 提取 Mean, SD, Median, Q1, Q3
  mean_val <- as.numeric(stats$MEAN)
  sd_val <- as.numeric(stats$SD)
  median_val <- as.numeric(stats$MEDIAN)
  q1_val <- as.numeric(stats$Q1)
  q3_val <- as.numeric(stats$Q3)

  # 格式化輸出分兩行
  c(
    "",
    "Mean ± SD" = sprintf("%.2f ± %.2f", mean_val, sd_val),
    "Median [Q1, Q3]" = sprintf("%.2f [%.2f, %.2f]", median_val, q1_val, q3_val)
  )
}
render.cat <- function(x) {
  c("", sapply(stats.default(x), function(y) with(y, sprintf("%d (%6.2f %%)", FREQ, PCT))))
}
