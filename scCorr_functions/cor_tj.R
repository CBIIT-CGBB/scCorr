cor_tj <- function(dat_tsne,dat,genes){
  out.s <- NULL
  c1.i <- which.min(dat_tsne[,1])
  c2.i <- which.max(dat_tsne[,1])
  out  <- tjGCluster2(dat_tsne, from=c1.i, to=c2.i, cutoff=10000);
  for (i in 1:nrow(genes)){
    gene1 <- genes[i,1]
    gene2 <- genes[i,2]
    ov1   <- do_tj(out$node, out$level1, dat, gene1);
    ov2   <- do_tj(out$node, out$level1, dat, gene2);
    n1.i  <- which(ov1$n==1);
    n2.i  <- which(ov2$n==1);
    n0.i  <- unique(c(n1.i, n2.i));
    v1    <- ov1$v[-n0.i];
    v2    <- ov2$v[-n0.i];
    out   <- summary(glm(v1~ v2))
    out.s <- rbind(out.s, c(gene1, gene2,out$coef[2,3], out$coef[2,4]))
  }
  return(out.s)
}





do_tj <- function(node, l, dat, gene){
  out.v <- NULL;
  out.n <- NULL;
  for (i in 1:length(node)){
    j <- grep(node[i], l);
    n <- NULL;
    for (jj in i){
      n <- c(n, l[[jj]])
    }
    ind.i <- which(colnames(dat) %in% n);
    v     <- as.numeric(dat[gene, ind.i]);
    out.v <- c(out.v, mean(v));
    out.n <- c(out.n, length(v));
  }
  return(list(v=out.v, n=out.n));
}