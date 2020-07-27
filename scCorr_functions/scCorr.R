library(Rtsne)
library(GCluster)
source('tjGCluster.R')
source('tjGCluster2.R')
source('cor_window.R')
source('cor_tj.R')
source('cor_cluster.R')


scCorr <- function(cdat, method, genes, num_windows = 50, window_method = 'd',num_cluster = 10, perplex = 30, max_iteration = 1000) {
  if (method != 'window' & method != 'trajectory' & method != 'cluster'){
    return('Method must be \'window\', \'trajectory\' or \'cluster\'. ')
  }
  tsne <- Rtsne(t(cdat), dims = 2, perplexity= perplex, verbose=TRUE, PCA = TRUE, max_iter = max_iteration)
  dat_tsne <- tsne$Y
  
  if(method == 'window'){
    return(cor_window(dat_tsne,cdat,genes,num_windows))
  }
  else if (method == 'trajectory'){
    return(cor_tj(dat_tsne,cdat,genes))
  }
  else if (method == 'cluster'){
    return(cor_cluster(dat_tsne,cdat,genes,num_cluster))
  }
}





