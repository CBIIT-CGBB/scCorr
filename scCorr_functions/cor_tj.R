cor_tj <- function(dat_tsne,dat,genes){
  out.s <- NULL
  c1.i <- which.min(dat_tsne[,1])
  c2.i <- which.max(dat_tsne[,1])
  out  <- tjGCluster2(dat_tsne, from=c1.i, to=c2.i,cutoff = 1000)
  node <- out$node
  level <- out$level
  for (i in 1:nrow(genes)){
  #  print(i)
    gene1 <- genes[i,1]
    gene2 <- genes[i,2]
    print(c(gene1,gene2))
    ov1   <- do_tj(node, level, dat, gene1);

    ov2   <- do_tj(node, level, dat, gene2);
    n1.i  <- which(ov1$n==1);
    n2.i  <- which(ov2$n==1);
    n0.i  <- unique(c(n1.i, n2.i));
    v1    <- ov1$v[-n0.i];
    v2    <- ov2$v[-n0.i];
    if(var(v1) == 0 | var(v2) == 0){
      print('not found')
      next
    }
    res <- cor.test(v1, v2, method = "pearson")
    out.s <- rbind(out.s, c(gene1, gene2,res$p.value, res$estimate))
  }
  return(out.s)
}

do_tj <- function(node, l, dat, gene){
  out.v <- NULL;
  out.n <- NULL;
  for (i in 1:length(node)){
    j <- grep(node[i], l);
    n <- NULL;
    for (jj in j){
      n <- c(n, l[[jj]])
    }
    n = as.numeric(n)
  #  print(n)
    v     <- as.numeric(dat[gene, n]);
    out.v <- c(out.v, mean(v));
    out.n <- c(out.n, length(v));
  }
  return(list(v=out.v, n=out.n));
}
