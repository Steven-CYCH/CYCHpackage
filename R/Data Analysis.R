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
#   group2 = rnorm(40, mean = 55, sd = 10)   # 第二組資料（40個樣本）
# )
# # Simulate discrete data
x <- list(
  group1 = c("A", "A", "B", "B", "A", "A", "B"),  # 第一組資料（類別型）
  group2 = c("B", "B", "A", "A", "B", "B", "A")   # 第二組資料（類別型）
)

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
    less5count <- sum(table(y, g) < 5)
    allCount <- sum(table(y, g) >= 0)
    ratio <- less5count / allCount
    exp.TB <- chisq.test(table(y, g))
    if(sum(table(g)) > 40){
      if(ratio >= 0.2){
        p <- fisher.test(table(y, g))$p.value
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
      p <- fisher.test(table(y, g))$p.value
    }
  }
  sub("<", "&lt;", format.pval(p, digits=3, eps=0.001))
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
