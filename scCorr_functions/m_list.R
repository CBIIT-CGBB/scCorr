m_list<- function(coordinates,l){
  num_window <- l
  v_min <- min(coordinates)
  v_max <- max(coordinates)
  v_diff <- (v_max - v_min)/(num_window-1)
  index_list <- as.integer((coordinates - v_min)/v_diff + 1)
  target_indices <- vector(mode = "list", length = num_window)
  for (i in 1:num_window){
    target_indices[i] <- list(which(index_list == i))
  }
  return(target_indices)
}
