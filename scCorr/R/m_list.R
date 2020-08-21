m_list<- function(coordinates = coordinates,l = 30){
  cell_name <- names(coordinates)
  num_window <- l
  v_min <- min(coordinates)
  v_max <- max(coordinates)
  v_diff <- (v_max - v_min)/(num_window-1)
  index_list <- as.integer((coordinates - v_min)/v_diff + 1)
  target_indices <- sapply(c(1:num_window),function(x) list(which(index_list == x)))
  cell <- sapply(c(1:num_window),function(x) list(cell_name[target_indices[[x]]]))
  return(list(target_indices,cell))
}
