get_value <- function(dat,w_list){
  num_window <- length(w_list)
  res <- sapply(1:num_window,function(x) rowMeans(dat[,w_list[[i]],drop=FALSE]))
  return(res)
}
