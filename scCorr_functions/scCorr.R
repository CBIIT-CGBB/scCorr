library(Rtsne)
library(GCluster)
source('cor_window.R')
source('cor_tj.R')
source('cor_cluster.R')
scCorr <- function(dat, method, genes, l) {
  if (method != 'window' & method != 'trajectory' & method != 'cluster'){
    return('Method must be \'window\', \'trajectory\' or \'cluster\'. ')
  }
  tsne <- Rtsne(t(dat), dims = 2, perplexity=30, verbose=TRUE, PCA = TRUE, max_iter = 400)
  dat_tsne <- tsne$Y
  rownames(dat_tsne) <- colnames(dat)
  if(method == 'window'){
    return(cor_window(dat_tsne,dat,genes,l))
  }
  else if (method == 'trajectory'){
    return(cor_tj(dat_tsne,dat,genes))
  }
  else if (method == 'cluster'){
    return(cor_cluster(dat_tsne,dat,genes,l))
  }
}




#gene1 <- 'ENSG00000035681'
#gene2 <- 'ENSG00000000419'




