get_value <- function(dat = dat, d_list = d_list){
  if (is.list(d_list)){
    num_c <- length(d_list)
    res   <- matrix(, nrow = dim(dat)[1], ncol = num_c)
    for(i in 1:num_c){
      res[,i] <- rowMeans(dat[,d_list[[i]],drop=FALSE])
    }
  } else {
    ## unique cluster ID
    clu.u <- sort(unique(d_list));
    num_c <- length(clu.u);
    res   <- matrix(, nrow = dim(dat)[1], ncol = num_c)
    for(i in 1:num_c){
      clu.u.i <- clu.u[i];
      c.j     <- which(d_list==clu.u.i);
      res[,i] <- rowMeans(dat[, names(d_list)[c.j], drop=FALSE])
    }
  }
  row.names(res) <- row.names(dat)
  return(res)
}
