

mgGCluster <- function(x, l, rename=TRUE){
  for (i in 1:length(l)){
    out <- l[[i]];
    for (k in 2:length(out)){
      j <- which(x==out[k])
      x[j] <- out[1];
    }
  }
  
  if (rename){
    y <- as.numeric(as.factor(x));
  } else {
    y <- NULL;
  }
  return(list(merged=x, renamed=y));
}
