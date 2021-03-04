\name{tjGCluster2}
\alias{tjGCluster2}

\title{
 trajectory analysis
}

\description{
 trajectory analysis
}

\usage{
  tjGCluster2(m, from=NULL, to=NULL, cutoff=25);
}

\arguments{
   \item{m}{data.frame or matrix or igraph object}
   \item{from}{start vetex}
   \item{to}{end vetex}
   \item{cutoff}{it will be a branch if vertex number > cutoff}
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
## select nodes of start and end 
c1.i  <- which.min(tsne[,2]);
c2.i  <- which.max(tsne[,2]);
## do trajectory
out1  <- tjGCluster(tsne, from=c1.i, to=c2.i);
out2  <- tjGCluster2(tsne, from=c1.i, to=c2.i, cutoff=100);
out   <- list(out1=out1, out2=out2);

}

