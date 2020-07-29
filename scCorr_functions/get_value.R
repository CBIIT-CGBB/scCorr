get_value <- function(dat,w_list){
  res = matrix(, nrow = dim(dat)[1], ncol = num_window)
  for(i in 1:nrow(dat)){
    values <- rep(0,num_window)
    for( j in 1:num_window){
      values[j] <- mean(as.numeric(dat[i,target_indices[[j]]]))
    }
    res[i,] <- values
    print(i)
  }
  
  return(res)
}





