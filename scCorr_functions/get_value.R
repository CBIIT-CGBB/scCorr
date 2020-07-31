get_value <- function(dat,w_list){
  num_window <- length(w_list)
  res = matrix(, nrow = dim(dat)[1], ncol = num_window)
  for(i in 1:num_window){
      res[,i] <-rowMeans(dat[,w_list[[i]],drop=FALSE])
  }
  row.names(res) <- row.names(dat)
  return(res)
}
