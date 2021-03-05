\name{tjGCluster}
\alias{tjGCluster}

\title{
 trajectory analysis
}

\description{
 trajectory analysis
}

\usage{
tjGCluster(m, from=NULL, to=NULL);
}

\arguments{
   \item{m}{data.frame or matrix or igraph object}
   \item{from}{start vetex}
   \item{to}{end vetex}
}

\value{
A list of trajectory analysis results.
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
clu    <- read.table(cluf, header=T);

## make coordinate vector
## sample index of CD4 T cells in the cluster matrix
s.i    <- which(clu[,23] %in% ct.c);
## CD4 T cells 
tsne <- tsne[s.i,];
## do trajectory
out  <- tj_list(tsne, ctf = 100);
out.index     <- out[[1]];
out.cellname  <- out[[2]];


}

