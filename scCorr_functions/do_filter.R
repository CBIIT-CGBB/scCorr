
## d is the distance matrix
## cutoff: cutoff percentage, cutoff.v: cutoff value
do_filter <- function(dat, cutoff=0.95, cutoff.v=NULL){
  ## distance
  if (class(dat)=="matrix" | class(dat)=="data.frame"){
    dat.d <- dist(dat[,1:2]);
  } else {
    dat.d <- dat;
  }
  ## convert distance matrix to matrix
  dat.d <- as.matrix(dat.d);
  ## replace diagonal with max distance;
  diag(dat.d) <- max(as.vector(dat.d));
  ## distance between clusters
  clu.u <- unique(dat[,3]);
  out.s <- NULL;
  pb <- txtProgressBar(min = 0, max = length(clu.u), style = 3);
  i  <- 0;
  for (c1 in 1:length(clu.u)){
    i    <- i + 1;
    d1.i <- which(dat[,3]==c1);
    for (c2 in c1:length(clu.u)){
      if (c1 == c2){
        next;
      }
      d2.i <- which(dat[,3]==c2);
      d.s  <- dat.d[d1.i, d2.i];
      out  <- min(as.vector(d.s));
      out.s <- rbind(out.s, c(c1, c2, out));
    }
  }
  out.s <- rbind(out.s, out.s[,c(2,1,3)]);
  setTxtProgressBar(pb, i);
  close(pb);
  colnames(out.s) <- c("cluster1", "cluster2", "distance");
  ## convert three columns to matrix
  clu.d <- xtabs(distance~cluster1+cluster2, data=out.s);
  diag(clu.d) <- max(as.vector(clu.d));
  ## 
  c.min <- apply(clu.d, 2, min);
  ## minimum distance between clusters
  if (is.null(cutoff.v)){
    remain.n    <- round(length(c.min) * cutoff);
    c.r         <- rank(c.min);
    c.i         <- which(c.r > remain.n);
  } else {
    c.i         <- which(c.min > cutoff.v)
  }
  rm.names    <- colnames(clu.d)[c.i];
  return(rm.names);
}