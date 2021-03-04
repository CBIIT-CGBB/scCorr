\name{GCluster}
\alias{GCluster}

\title{
 graphical based cluster
}

\description{
 graphical based cluster
}

\usage{
  GCluster(dat=dat, wt=4, k=NULL, method="louvain");
}

\arguments{
   \item{dat}{data.frame or matrix}
   \item{wt}{weight}
   \item{k}{cluster number}
   \item{method}{The method should be one of louvain, spinglass, 
   fast_greedy, infomap or label_prop.}
}

\value{
A object of communities of igraph
}

\description{
This function uses the Network Modularity Optimazation Cluster Method to cluster the cells. It returns 
a object of communities of igraph. 
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

## scale
cell.number <- nrow(dat);
v <- 112.65840 + 0.01799 * cell.number
c1    <- scale.v(dat[,1], -v, v)
c2    <- scale.v(dat[,2], -v, v)
dat  <- data.frame(v1=c1, v2=c2, row.names=row.names(dat))

g_clut  <- GCluster(dat, k = 40)
g_label <- g_clut$membership
out     <- data.frame(dat, cluster=g_label)
head(out)


}

