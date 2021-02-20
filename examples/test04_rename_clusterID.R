rm(list=ls());

options(stringsAsFactors = F);
dat <- read.table("02clust_table_raw.txt", header=T);

out.s <- dat[,1];
new.c <- dat[,1];
for (j in 2:ncol(dat)){
  ## previous cluster number
  clu.m <- max(new.c);
  old.c  <- NULL;
  ## order of the cluster ID by the previous cluster ID (1:clu.m)
  for (k in 1:clu.m){
    the.i <- which(new.c==k);
    n.u   <- unique(dat[the.i,j]);
    old.c <- c(old.c, n.u);
  }
  ## re-sign the cluster ID by the order 
  new.c <- rep(NA, nrow(dat));
  i <- 0;
  for (o.c in old.c){
    i <- i + 1;
    o.i <- which(dat[,j]==o.c);
    new.c[o.i] <- i;
  }
  ## merge into the table
  out.s <- cbind(out.s, new.c);
}

row.names(out.s) <- row.names(dat);
colnames(out.s)  <- colnames(dat);
write.table(out.s, "03clust_table.txt", quote=F, sep="\t");

## check the output
for (i in 1:ncol(dat)){
  c1  <- dat[,i];
  c2  <- out.s[,i];
  c.s <- paste0(c1, "_", c2);
  c.t <- table(c.s);
  n   <- gsub("clu", "", colnames(dat)[i]);
  m   <- length(unique(out.s[,i]));
  if (m==length(c.t) & n==length(c.t) & n==m){
  } else {
    print (c(colnames(dat)[i], length(c.t), length(m)))
  }
}




