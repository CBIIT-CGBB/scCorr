\name{c_list}
\alias{c_list}
\title{A graph-based k-partitioning Method with scaling}
\usage{
c_list(dat, l, method,auto_scaling)
}
\arguments{
\item{dat}{matrix or data frame}
\item{l}{Number of clusters}
\item{method}{Cluster method. Default: fast_greedy}
}
\value{
A list of indices of data and a list of names of data.
}
\description{
This function uses the Network Modularity Optimazation Cluster Method to cluster the cells. It returns 
the list of indices and name of cells after clustering. 
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

out           <- c_list(dat, 40);
out.index     <- out[[1]];
out.cellname  <- out[[2]];

}
