c_list <- function(dat_dr,l){
  out.s <- NULL
  num_clu = l
  g_clut <- GCluster::GCluster(dat_dr, k = num_clu,method =  'fast_greedy')
  g_label <- g_clut$membership
  target_indices <- vector(mode = "list", length = num_clu)
  for (i in 1:num_clu){
    target_indices[i] <- list(which(g_label == i))
  }
  return(target_indices)
}
