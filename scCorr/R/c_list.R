c_list <- function(dat = dat_dr,l = 30,method = 'fast_greedy'){
  cell_name <- rownames(dat)
  out.s <- NULL
  num_clu = l
  g_clut <- GCluster(dat, k = num_clu,method =  method)
  g_label <- g_clut$membership
  target_indices <-sapply(c(1:num_clu),function(x) list(which(g_label == x)))
  cell <- sapply(c(1:num_clu),function(x) list(cell_name[target_indices[[x]]]))
  return(list(target_indices,cell))
}
