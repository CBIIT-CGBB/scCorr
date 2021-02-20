rm(list=ls());

options(stringsAsFactors = F);
## all cluster sets: from 20 to 1000
clu.n <- c(20:40, seq(10, 1000, length.out=100));
clu.n <- sort(unique(clu.n))

out.s <- NULL;
for (n in clu.n){
  inff  <- paste0("cluster/clu_", n, ".txt");
  dat   <- read.table(inff, header=T);
  out.s <- cbind(out.s, dat[,3]);
}

row.names(out.s) <- row.names(dat);
colnames(out.s)  <- paste0("clu", clu.n);
write.table(out.s, "02clust_table_raw.txt", quote=F, sep="\t");

## check the cluster consistency
for (i in 1:ncol(out.s)){
  for (j in i:ncol(out.s)){
    if (i==j){
      next;
    }
    clu.s <- paste0(out.s[,i], "_", out.s[,j]);
    c1.n  <- length(unique(out.s[,i]));
    c2.n  <- length(unique(out.s[,j]));
    c.n   <- max(c1.n, c2.n);
    tmp   <- table(clu.s);
    if (c.n == length(tmp)){
    } else {
      cat(i, " ", j, "\n");
    }
  }
}
