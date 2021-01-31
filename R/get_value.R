get_value <- function(dat = dat,d_list = d_list){
  num_window <- length(d_list)
  res = matrix(, nrow = dim(dat)[1], ncol = num_window)
  for(i in 1:num_window){
      res[,i] <- rowMeans(dat[,d_list[[i]],drop=FALSE])
  }
  row.names(res) <- row.names(dat)
  return(res)
}

