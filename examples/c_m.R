## convert cluster matrix to cluster table
m2table <- function(dat){
  ## generate list, the last cluster ID and row.name
  c2n   <- list();
  ## the largest cluster number in the data set from the last columns
  clu.n <- length(unique(dat[,ncol(dat)]));
  for (i in 1:clu.n){
    j <- which(dat[,ncol(dat)] == i);
    c2n[[i]] <- row.names(dat)[j];
  }

  out.c <- NULL;
  out.n <- NULL;
  pb <- txtProgressBar(min = 0, max = length(ncol(dat)), style = 3);
  for (j in 1:ncol(dat)){
    out1 <- NULL;
    out2 <- NULL;
    for (i in 1:clu.n){
      n   <- c2n[[i]];
      k   <- which(row.names(dat) %in% n);
      clu <- unique(dat[k, j]);
      out1 <- c(out1, clu);
      out2 <- c(out2, length(k));
    }
    out.c <- cbind(out.c, out1);
    out.n <- cbind(out.n, out2);
    setTxtProgressBar(pb, j);
  }
  close(pb);
  colnames(out.c)  <- colnames(dat);
  colnames(out.n)  <- colnames(dat);
  row.names(out.c) <- paste0("clu", 1:clu.n);
  row.names(out.n) <- paste0("clu", 1:clu.n);
  return(list(cluID=out.c, cluNum=out.n));
}
