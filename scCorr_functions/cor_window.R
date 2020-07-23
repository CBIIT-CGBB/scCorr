
cor_window <- function(dat_tsne,dat,genes,l){
  out.s <- NULL
  for (i in 1:nrow(genes)){
    gene1 <- genes[i,1]
    gene2 <- genes[i,2]
    v1 <- get_value(dat_tsne,dat,gene1,l)
    v2 <- get_value(dat_tsne,dat,gene2,l)
    out   <- summary(glm(v1~ v2))
    out.s <- rbind(out.s, c(gene1, gene2,out$coef[2,3], out$coef[2,4]))
  }
  return(out.s)
}

get_value <- function(dat_tsne,dat,gene,l){
  num_window = l
  
  x_min <- min(dat_tsne[,1])
  x_max <- max(dat_tsne[,1])
  x_diff <- (x_max - x_min)/(num_window-1)
  index_list <- as.integer((dat_tsne[,1] - x_min)/x_diff + 1)
  res <- rep(0,num_window)
  for(i in 1:num_window){
    target_indices <- which(index_list == i)
    res[i] <- mean(as.numeric(dat[gene,target_indices]))
    
  }
  
  return(res)
  
}
