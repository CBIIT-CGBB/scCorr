
## clu(dat): coordinates of single cells, column 1 is x and column 2 is y
## clu.c: colum index: 1=x, 2=y
## l=length.out
## m=w: split a vector to l groups (length.out) by width
## m=d: split a vector to l groups (length.out) by density

do_region <- function(clu, clu.c, l=100, m="w"){
  if (m=="w"){
    po    <- seq(min(clu[,clu.c]), max(clu[,clu.c]), length.out = l+1);
    from  <- po[1];
    out.s <- list();
    k     <- 0;
    for (i in 2:length(po)){
      k <- k + 1;
      to <- po[i];
      if (k==1){
        j  <- which(clu[,clu.c] >= from & clu[,clu.c] <= to);
      } else {
        j  <- which(clu[,clu.c] > from & clu[,clu.c] <= to);
      }
      if (length(j) < 1){
        out.s[[k]] <- NA;
        next;
      }
      out.s[[k]] <- row.names(clu)[j];
      from <- to;
    }
  } else if (m=="d"){
    po    <- seq(1, nrow(clu), length.out = l+1);
    po    <- round(po);
    o.i   <- order(clu[,clu.c]);
    o.n   <- row.names(clu)[o.i];
    from  <- po[1];
    k     <- 0;
    out.s <- list();
    for (i in 2:length(po)){
      k <- k + 1;
      to <- po[i];
      if (k > 1){
        from <- from - 1;
      }
      out.s[[k]] <- o.n[from:to];
      from <- to;
    }
  } else {
    stop("m==\"w\" or m==\"d\"");
  }
  ## return list
  return(region=out.s)
}

region2v <- function(region, dat, ann, gene){
  out.s <- NULL;
  out.n <- NULL;
  for (i in 1:length(region)){
    n <- region[[i]];
    d.j <- which(colnames(dat) %in% n);
    if (length(d.j) < 1){
      out.s <- c(out.s, NA);
      out.n <- c(out.n, 0);
      next;
    }
    g.j   <- which(ann[,2]==gene);
    v     <- as.numeric(dat[g.j, d.j]);
    v.m   <- mean(v, na.rm = T)
    out.s <- c(out.s, v.m);
    out.n <- c(out.n, length(v));
  }
  return(list(v=out.s, n=out.n));
}