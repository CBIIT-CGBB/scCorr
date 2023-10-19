
merge_cluster <- function(dat, cutoff=5){
  clu.t   <- table(dat[,3]);
  clu.i   <- which(clu.t < cutoff);
  if (length(clu.i) < 1){
    stop("no cluster size < the cutoff")
  }
  small.c <- names(clu.t)[clu.i]
  clu.u   <- unique(dat[,3]);
  out.s   <- NULL;
  for (c.i in clu.u){
    i     <- which(dat[,3]==c.i);
    out.s <- rbind(out.s, c(c.i, mean(dat[i,1]), mean(dat[i,2])));
  }
  out.d   <- dist(out.s[,c(2,3)]);
  out.d   <- as.matrix(out.d)
  colnames(out.d) <- rownames(out.d) <- clu.u; 
  out.d   <- as.dist(out.d);
  out     <- dist2df(out.d);
  colnames(out) <- c("c1", "c2", "d");
  tmp     <- out[,c(2,1,3)];
  colnames(tmp) <- c("c1", "c2", "d");
  out     <- rbind(out, tmp);
  ## fist column will be small clusters
  ## second column will be big clusters
  ## keep small clusters in column 1
  out.i   <- which(out[,1] %in% small.c);
  out.f   <- out[out.i,];
  ## remove small clusters in column 2
  out.j   <- which(out.f[,2] %in% small.c);
  out.f   <- out.f[-out.j,];

  ##
  ## column 1 clusters will be merged into column 2
  m.out   <- NULL;
  for (c.i in small.c){
    j       <- which(out.f[,1]==c.i);
    out.tmp <- out.f[j,];
    s.j     <- which.min(out.tmp[,3]);
    m.out   <- rbind(m.out, c(c.i, out.tmp[s.j,2]));
  }
  big.clu    <- unique(m.out[,2]);
  merged.out <- list();
  m.i        <- 0;
  for (b.u in big.clu){
    m.i <- m.i + 1;
    m.j <- which(m.out[,2]==b.u);
    merged.out[[m.i]] <- c(b.u, m.out[m.j,1]);
  }
  return(merged.out);
}