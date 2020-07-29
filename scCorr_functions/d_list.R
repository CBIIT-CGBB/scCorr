d_list <- function(coordinates,l){
  num_window <- l
  po    <- seq(1, length(coordinates), length.out = num_window+1);
  po    <- round(po);
  o.i   <- order(coordinates)
  target_indices <- vector(mode = "list", length = num_window)
  for (i in 2:length(po)){
    target_indices[i-1] <- list(which(o.i < po[i] & o.i >= po[i-1]))
  }
  return(target_indices)
}
