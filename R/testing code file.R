# install.packages(c('devtools', 'data.table'))
library(devtools)
# devtools::install_github('Steven-CYCH/CYCHpackage')
library(data.table)
library(CYCHpackage)
DT <- as.data.table(data.frame(IDname = paste0('ID00', 1:9),
                               conA = c(1,5,3,4,5,1223551,4,2,-123443)))
