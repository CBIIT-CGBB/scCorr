merge_list <- function(l, cutoff=25){
  ## the list length
  l_len <- length(l);
  ## element length of the list
  e_len <- lengths(l);
  ## check if the list needs to be merged
  e_len.i <- which(e_len < cutoff);
  if (length(e_len.i)<1){
    stop("There is not any element in the list < the cutoff.")
  }
  l.out <- list();
  k     <- 0; ## the output list index
  ## tmp_v: a vactor will be used to merge short elements
  tmp_v <- NULL;
  for (i in 1:l_len){
    if (length(l[[i]]) >= cutoff){
      k <- k + 1;
      ## check if there is merged vector
      if (length(tmp_v) > 0){
        ## check if the merged vector >= cutoff
        if (length(tmp_v)>=cutoff){
          l.out[[k]] <- tmp_v;
          k <- k + 1;
          l.out[[k]] <- l[[i]];
        } else {
          l.out[[k]] <- c(l[[i]], tmp_v);
        }
      } else {
        l.out[[k]] <- l[[i]];
      }
      tmp_v <- NULL;
    } else {
      tmp_v <- c(tmp_v, l[[i]]);
    }
  }
  ## check last tmp_v
  if (length(tmp_v)>0){
    if (length(tmp_v)>=cutoff){
      k <- k + 1;
      l.out[k] <- tmp_v
    } else {
      l.out[[length(l.out)]] <- c(l.out[[length(l.out)]], tmp_v);
    }
  }
  return(l.out);
}