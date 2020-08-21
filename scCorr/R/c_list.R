c_list <- function(dat_dr = dat_dr,l = 30){
  cell_name <- names(coordinates)
  out.s <- NULL
  num_clu = l
  g_clut <- GCluster::GCluster(dat_dr, k = num_clu,method =  'fast_greedy')
  target_indices <-sapply(c(1:num_clu),function(x) list(which(g_label == x)))
  cell <- sapply(c(1:num_window),function(x) list(cell_name[target_indices[[x]]]))
  return(list(target_indices,cell))
}

