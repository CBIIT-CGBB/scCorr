
cor_cluster <- function(dat_tsne,dat,genes,l){
  out.s <- NULL
  num_clu = l
  g_clut <- GCluster(dat = dat_tsne, k = num_clu)
  for (i in 1:nrow(genes)){
    gene1 <- genes[i,1]
    gene2 <- genes[i,2]
    v1 <- get_value_cluster(dat_tsne,g_clut,dat,gene1,l)
    v2 <- get_value_cluster(dat_tsne,g_clut,dat,gene2,l)
    out   <- summary(glm(v1~ v2))
    out.s <- rbind(out.s, c(gene1, gene2,out$coef[2,3], out$coef[2,4]))
  }
  return(out.s)
}

get_value_cluster <- function(dat_tsne,g_clut,dat,gene,l){
  num_cluster = l
  g_label <- g_clut$membership
  res <- rep(0,num_cluster)
  for(i in 1:num_cluster){
    target_indices <- which(g_label == i)
    res[i] <- mean(as.numeric(dat[gene,target_indices]))
    
  }
  
  return(res)
  
}


