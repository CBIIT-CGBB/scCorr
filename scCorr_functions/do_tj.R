

do_tj <- function(node, l, dat, gene){
  out.v <- NULL;
  out.n <- NULL;
  for (i in 1:length(node)){
    j <- grep(node[i], l);
    n <- NULL;
    for (jj in i){
      n <- c(n, l[[jj]])
    }
    g.i   <- which(ann[,2]==gene)[1];
    ind.i <- which(colnames(dat) %in% n);
    v     <- as.numeric(dat[g.i, ind.i]);
    out.v <- c(out.v, mean(v));
    out.n <- c(out.n, length(v));
  }
  return(list(v=out.v, n=out.n));
}