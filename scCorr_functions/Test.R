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
dat <- tsne$Y
row.names(dat) <- colnames(cdat)

# Get the sliced window index list, 
# Input: one dimensional vector and required number of windows.



m.list <- c_list(dat,30)


# Compute the corresponding vector

v <- get_value(cdat,m.list)
