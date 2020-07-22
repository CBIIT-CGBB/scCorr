library(Rtsne)
library(GCluster)
scCorr <- function(dat, method,gene1,gene2,l) {
  tsne <- Rtsne(t(dat), dims = 2, perplexity=30, verbose=TRUE, max_iter = 500,pca = TRUE,check_duplicates=FALSE)
  dat_tsne <- tsne$Y
  rownames(dat_tsne) <- colnames(dat)
  if(method == 'window'){
    return(cor_vector(dat_tsne,dat,gene1,gene2,l))
  }
  else if (method == 'trajectory'){
    return(cor_trajectory(dat_tsne,dat,gene1,gene2))
  }
  else if (method == 'cluster'){
    return(cor_cluster(dat_tsne,dat,gene1,gene2,l))
  }
}
# Window Method
cor_window <- function(dat_tsne,dat,gene1,gene2,l){
  num_window = l
  
  x_min <- min(dat_tsne[,1])
  x_max <- max(dat_tsne[,1])
  x_diff <- (x_max - x_min)/(num_window-1)
  gene1_vect <- rep(list(c(0,0)),num_window)
  gene2_vect <- rep(list(c(0,0)),num_window)
  
  for (i in c(1:dim(dat_tsne)[1])) {
    index = as.integer((dat_tsne[i,1] - x_min)/x_diff + 1) 
    gene1_vect[[index]][1] <- gene1_vect[[index]][1] + dat[gene1,rownames(dat_tsne)[i]]
    gene1_vect[[index]][2] <- gene1_vect[[index]][2] + 1
    gene2_vect[[index]][1] <- gene2_vect[[index]][1] + dat[gene2,rownames(dat_tsne)[i]]
    gene2_vect[[index]][2] <- gene2_vect[[index]][2] + 1
  }
  gene1_vect <- sapply(gene1_vect,function(entry) ifelse(entry[2] == 0,0,entry[1]/entry[2]))
  gene2_vect <- sapply(gene2_vect,function(entry) ifelse(entry[2] == 0,0,entry[1]/entry[2]))
  return(list(gene1_vect,gene2_vect))
}

# Trajectory Method
cor_trajectory<- function(dat_tsne,dat,gene1,gene2){
  mstGCluster(dat_tsne)
}





# Cluster Method
cor_cluster <- function(dat_tsne,dat,gene1,gen2,l){
  num_clu = l
  g_clut <- GCluster(dat = dat_tsne, k = num_clu)
  g_label <- g_clut$membership
  
  gene1_vect <- rep(list(c(0,0)),l)
  gene2_vect <- rep(list(c(0,0)),l)
  for (i in c(1:dim(dat_tsne)[1])) {
    index <- g_label[i]
    gene1_vect[[index]][1] <- gene1_vect[[index]][1] + dat[gene1,rownames(dat_tsne)[i]]
    gene1_vect[[index]][2] <- gene1_vect[[index]][2] + 1
    gene2_vect[[index]][1] <- gene2_vect[[index]][1] + dat[gene2,rownames(dat_tsne)[i]]
    gene2_vect[[index]][2] <- gene2_vect[[index]][2] + 1
  }
  gene1_vect <- sapply(gene1_vect,function(entry) ifelse(entry[2] == 0,0,entry[1]/entry[2]))
  gene2_vect <- sapply(gene2_vect,function(entry) ifelse(entry[2] == 0,0,entry[1]/entry[2]))
  return(list(gene1_vect,gene2_vect))
  
}

#gene1 <- 'ENSG00000035681'
#gene2 <- 'ENSG00000000419'



