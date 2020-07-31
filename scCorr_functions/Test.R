source('../R/scCorr.R')
source('../R/m_list.R')
source('../R/get_value.R')
source('../R/d_list.R')
source('../R/c_list.R')
ct   <- "Bcell";
infd <- paste0("~/Desktop/P/scCorr/scCorr_data_sets/ct_", ct, ".RData")
load(infd)


# Dimension Reduction Fisrt: T-sne or Umap

library(Rtsne)
dat <- Rtsne(t(cdat), dims = 2, perplexity= 30, verbose=TRUE, PCA = TRUE, max_iter = 1000)
dat_dr <- dat$Y
# Umap
#library(umap)
#dat.umap <- umap(t(cdat))
#dat_dr <- dat.umap$layout

row.names(dat_dr) <- colnames(cdat)




# Get the sliced window index list, 
# Input: one dimensional vector and required number of windows.



m.list <- m_list(dat_dr[,1],100)
merged.list <- merge_list(m.list)

# Compute the corresponding vector

v <- get_value(cdat,merged.list)

# Test Correlation
v1 = v[2,]
v2 = v[14272,]
test = cor.test(v1, v2, method=c("pearson", "kendall", "spearman"))
test

