source('~/R/scCorr.R')
library(dplyr)
library(sqldf)
library(ggplot2)
ct   <- "Bcell";
infd <- paste0("~/scCorr_data_sets/ct_", ct, ".RData")
load(infd)
gene_info <- read.table('~/scCorr_data_sets/hsa04024_f.txt')
gene_encoding <-read.table('~/scCorr_data_sets/gene4matrix.txt',header = TRUE)

df3 <- sqldf("SELECT gene2, gene as Gene1
            FROM gene_info
            Join gene_encoding
on (gene_info.gene1 = gene_encoding.sym)")

df4 <- sqldf("SELECT Gene1, gene as Gene2
            FROM df3
            Join gene_encoding
on (df3.gene2 = gene_encoding.sym)")


result1 <- scCorr(cdat = cdat,method ='window',window_method = 'd',genes = df4, num_windows = 50, perplex = 30,max_iteration = 1000)
result2 <- scCorr(cdat = cdat,method ='window',window_method = 'w',genes = df4, num_windows = 50, perplex = 30,max_iteration = 1000)
result3 <- scCorr(cdat = cdat,method ='trajectory',genes = df4, perplex = 30,max_iteration = 1000)
result4 <- scCorr(cdat = cdat,method ='cluster', num_cluster =50,genes = df4, perplex = 30,max_iteration = 1000)


