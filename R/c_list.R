c_list <- function(dat = dat,l = 30,method = 'louvain',auto_scaling = TRUE){
  cell_name <- rownames(dat)
  out.s <- NULL
  num_clu = l
  if (auto_scaling == TRUE){
  cell.number <- length(dat)
  v <- 112.65840 + 0.01799 * cell.number
  c1    <- scale.v(dat[,1], -v, v)
  c2    <- scale.v(dat[,2], -v, v)
  dat  <- data.frame(v1=c1, v2=c2)
   }
  g_clut <- GCluster(dat, k = num_clu,method =  method)
  g_label <- g_clut$membership
  target_indices <-sapply(c(1:num_clu),function(x) list(which(g_label == x)))
  cell <- sapply(c(1:num_clu),function(x) list(cell_name[target_indices[[x]]]))
  return(list(target_indices,cell))
}
