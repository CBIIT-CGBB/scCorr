tj_list <- function(dat = dat_dr, ctf = 100){
  out.s <- NULL
  c1.i <- which.min(dat_dr[,1])
  c2.i <- which.max(dat_dr[,1])
  out  <- tjGCluster2(dat_dr,from=c1.i, to=c2.i,cutoff = ctf)
  node <- out$node
  level <- out$level1
  cell <- level[sapply(level, function(x) length(x) >= 2)]
  target_indices <- lapply(cell,function(x) sapply(x, function(y) which(row.names(dat_dr) == y),USE.NAMES = FALSE))
  return(list(target_indices,cell))                                
}