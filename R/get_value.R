get_value <- function(dat = dat,d_list = d_list){
  num_c <- length(d_list)
  res <- matrix(, nrow = dim(dat)[1], ncol = num_c)
  if (is.list(d_list)){
  for(i in 1:num_window){
      res[,i] <- rowMeans(dat[,d_list[[i]],drop=FALSE])
  }
  row.names(res) <- row.names(dat)
  }
  else {
    for(i in 1:num_c){
      clu.u.i = d_list[i]
      c.j <- which(clu.f==clu.u.i);
      res[,i] <- rowMeans(dat[,c.j,drop=FALSE])
      }
  }
  return(res)
}
