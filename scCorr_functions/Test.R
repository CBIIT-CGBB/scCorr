ct   <- "Bcell";
infd <- paste0("../scCorr_data_sets/ct_", ct, ".RData")
load(infd)

gene1 <- 'ENSG00000035681'
gene2 <- 'ENSG00000000419'

genes = t(as.matrix(c(gene1,gene2)))

scCorr(cdat,'cluster',genes, num_cluster= 30,perplex = 30)
