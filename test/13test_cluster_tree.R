rm(list=ls());

options(stringsAsFactors = F);
library(scCorr);

## get data
## 4 clusters of CD4 T cells
ct.c   <- c(6:9); 
## tsne result/output
tsnef  <- "https://github.com/CBIIT-CGBB/scCorr/raw/master/data/01/do_tsne30_2000.txt";
tsne   <- read.table(tsnef, header=T);
## geting partial data by cluster matrix
cluf   <- "https://github.com/CBIIT-CGBB/scCorr/raw/master/data/01/03clust_table.txt";
clu    <- read.table(cluf, header=T, sep="\t");
## check row.names
sum(row.names(tsne)==row.names(clu))==nrow(clu);
## sample index of CD4 T cells in the cluster matrix
s.i    <- which(clu[,23] %in% ct.c);
## some single cells of CD4 T cells 
dat    <- tsne[s.i,];

## cluster numbers
clu.n  <- seq(10, 100, length.out = 10);

################################
cat("doing cluster ....\n");
################################
out.s <- NULL;
old.name <- NULL;
for (c.n in clu.n){
  cat("cluster number: ", c.n, "\n");
  out           <- c_list(dat, c.n);
  out.cellname  <- out[[2]];
  tmp.out       <- NULL;
  n.out         <- NULL;
  for (i in 1:length(out.cellname)){
    df      <- data.frame(cell=out.cellname[[i]], clusterID=rep(i, length(out.cellname[[i]])));
    tmp.out <- rbind(tmp.out, df);
    n.out   <- c(n.out, out.cellname[[i]])
  }
  n.i     <- order(n.out);
  n.out   <- n.out[n.i];
  tmp.out <- tmp.out[n.i,];
  if (class(old.name)=="character"){
    print(sum(old.name==n.out))
  }
  old.name <- n.out;
  out.s <- cbind(out.s, tmp.out[,2]);
}

row.names(out.s) <- old.name;
colnames(out.s)  <- paste0("clu", clu.n);
write.table(out.s, "13do_clu_raw.txt", quote=F, sep="\t");

################################
cat("re-naming cluster ....\n");
################################
dat <- out.s;
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
write.table(out.s, "13do_clu.txt", quote=F, sep="\t");

################################
# summary table for the cluster results
################################
dat   <- out.s;
clu.u <- c(10, 100, length.out=10);

## 
c2n   <- list();
for (i in 1:100){
  j <- which(dat[,ncol(dat)] == i);
  c2n[[i]] <- row.names(dat)[j];
}

out.c <- NULL;
out.n <- NULL;
for (j in 1:ncol(dat)){
  out1 <- NULL;
  out2 <- NULL;
  for (i in 1:100){
    n   <- c2n[[i]];
    k   <- which(row.names(dat) %in% n);
    clu <- unique(dat[k, j]);
    out1 <- c(out1, clu);
    out2 <- c(out2, length(k));
  }
  out.c <- cbind(out.c, out1);
  out.n <- cbind(out.n, out2);
}

colnames(out.c)  <- colnames(dat);
row.names(out.c) <- paste0("c", 1:100);
colnames(out.n)  <- colnames(dat);
row.names(out.n) <- paste0("c", 1:100);

write.table(out.c, "13do_clu_cluID.txt", quote=F, sep="\t")
write.table(out.n, "13do_clu_cluNum.txt", quote=F, sep="\t")

################################
## check the output
################################
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

rm(list=ls());
################################
## tree plot
################################
funf <- "https://github.com/CBIIT-CGBB/scCorr/raw/master/examples/supp_func.R";
source(funf);
pdf("13test_cluster_tree.pdf", 8, 8);
par(mar=c(4,4,4,4));

## get angle with two points
## delta_x = touch_x - center_x
## delta_y = touch_y - center_y
## delta_x = 450 - 400
## delta_y = 450 - 400
## (theta_radians = atan2(delta_y, delta_x))
## theta_radians*180/pi

## input data
dat1 <- read.table("13do_clu_cluID.txt", header=T, row.names=1);
dat2 <- read.table("13do_clu_cluNum.txt", header=T, row.names=1);
## cluster ID
num  <- seq(10, 100, length.out=10);
## 10 radii, one radius is for one cluster
r0   <- seq(100, 400, length.out=10);
## initail colors
col0 <- rainbow(10, alpha=0.8);

plot(c(1,800), c(1,800), type="n", axes=F,xlab="", ylab="",cex.lab=1.5, cex.axis=1.5,font.main = 1);
title("Cluster Number", cex.main = 1.5, line = -0.5, font.main = 1)

## plot segments
for (i in 1:ncol(dat1)){
  n <- num[i];
  r <- r0[i];
  s.w <- 360 -   angle(400+50, 400+r, 400, 400)$degree;
  e.w <- 2*360 - angle(400-50, 400+r, 400, 400)$degree;
  
  out <- n2p(400, 400, r, n, start.w=s.w, end.w=e.w);
  
  clu.m <- max(dat1[,i]);
  if (i > 1){
    for (clu.i in 1:clu.m){
      j.i  <- which(dat1[,i]==clu.i);
      i1.i <- i - 1;
      p.c  <- dat1[j.i, i1.i];
      p.c  <- unique(p.c);
      for (p.i in p.c){
        x1 <- out$x[clu.i];
        y1 <- out$y[clu.i];
        x0 <- oldx[p.i];
        y0 <- oldy[p.i];
        segments(x0, y0, x1, y1, col=col0[7], lwd=2);
      }
    }
  }
  oldx <- out$x;
  oldy <- out$y;
}

## plot points
for (i in 1:ncol(dat1)){
  n <- num[i];
  r <- r0[i];
  s.w <- 360 -   angle(400+50, 400+r, 400, 400)$degree;
  e.w <- 2*360 - angle(400-50, 400+r, 400, 400)$degree;
  
  out <- n2p(400, 400, r, n, start.w=s.w, end.w=e.w);
  par(font = 2,family = 'sans')
  
  text(400, 400+r, paste0("", n), cex=1);
  
  clu.m <- max(dat1[,i]);
  cex <- NULL;
  for (j in 1:clu.m){
    k <- which(dat1[,i]==j);
    n <- sum(dat2[k,i]);
    n <- log2(n)/3;
    cex <- c(cex, n);
  }
  cols <- rainbow(clu.m, alpha=0.6);
  points(out$x, out$y, pch=19, col="white", cex=cex+0.5);
  points(out$x, out$y, pch=19, col= cols, cex=cex);
  oldx <- out$x;
  oldy <- out$y;
}

dev.off();

