d_list <- function(coordinates,l){
  num_window <- l
  po    <- seq(1, length(coordinates), length.out = num_window+1);
  po    <- round(po);
  o.i   <- order(coordinates)
  target_indices <-mapply(function(x1,x2) list(which(x1 <= o.i & o.i< x2)),po[-length(po)],po[-1])
  return(target_indices)
}
