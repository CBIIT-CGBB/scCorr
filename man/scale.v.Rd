\name{scale.v}
\alias{scale.v}

\title{
 scale function
}

\description{
 scale function
}

\usage{
scale.v(x, start.v, end.v)
}

\arguments{
   \item{x}{numerical vector}
   \item{start.v}{minimum of scale}
   \item{end.v}{maximum of scale}
}

\examples{
rm(list=ls());

library(scCorr);

## get data
## 5 clusters of CD4 T cells
ct.c   <- c(6:10); 
## tsne result/output
tsnef  <- "https://github.com/CBIIT-CGBB/scCorr/raw/master/data/01/do_tsne30_2000.txt";
tsne   <- read.table(tsnef, header=T);

## cluster matrix
cluf   <- "https://github.com/CBIIT-CGBB/scCorr/raw/master/data/01/03clust_table.txt";
clu    <- read.table(cluf, header=T, sep="\t");
## check row.names
sum(row.names(tsne)==row.names(clu))==nrow(clu);
## sample index of CD4 T cells in the cluster matrix
s.i    <- which(clu[,23] %in% ct.c);
## some single cells of CD4 T cells

dat    <- tsne[s.i,];
dat.n  <- row.names(dat);
summary(dat);

## scale
cell.number <- nrow(dat);
v <- 112.65840 + 0.01799 * cell.number
c1    <- scale.v(dat[,1], -v, v)
c2    <- scale.v(dat[,2], -v, v)
dat  <- data.frame(v1=c1, v2=c2, row.names=row.names(dat))

v
summary(dat);


}

