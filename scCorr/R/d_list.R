d_list <- function(coordinates = coordinates,l = 30){
  cell_name <- names(coordinates)
  num_window <- l
  po    <- seq(1, length(coordinates), length.out = num_window+1);
  po    <- round(po);
  o.i   <- order(coordinates)
  target_indices <-mapply(function(x1,x2) list(which(x1 <= o.i & o.i< x2)),po[-length(po)],po[-1])
  cell <- sapply(c(1:num_window),function(x) list(cell_name[target_indices[[x]]]))
  return(list(target_indices,cell))
}
