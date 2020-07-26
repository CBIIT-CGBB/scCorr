source('~/Desktop/P/Test/R/scCorr.R')

ct   <- "Bcell";
infd <- paste0("../scCorr_data_sets/ct_", ct, ".RData")
load(infd)

gene1 <- 'ENSG00000035681'
gene2 <- 'ENSG00000000419'

target_genes = t(as.matrix(c(gene1,gene2)))

scCorr(dat = cdat,method ='window',window_method = 'd',genes = target_genes, num_windows = 50, perplex = 30,max_iteration = 1000)
