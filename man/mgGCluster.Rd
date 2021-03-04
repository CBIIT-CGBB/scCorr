\name{mgGCluster}
\alias{mgGCluster}

\title{
 merge cluster
}

\description{
 merge cluster
}

\usage{
  mgGCluster(x, l, rename=TRUE);
}

\arguments{
   \item{x}{vector as cluster ID}
   \item{l}{list, each object is vector. all clusters will be renamed as the first one}
   \item{rename}{if TRUE, the ID will be renamed.}
}

\value{
A list of merged result.
}

\description{
  merge cluster into adjacent cluster if the merged cluster single 
  cell number less than the cutoff.
}

\examples{
rm(list=ls());

library(scCorr);
## cluster matrix
cluf   <- "https://github.com/CBIIT-CGBB/scCorr/raw/master/data/01/03clust_table.txt";
clu    <- read.table(cluf, header=T, sep="\t");

## get one cluster result 
out    <- mgGCluster(clu[,23], list(c(9, 10), c(19, 20)), rename=F);
table(out$merged)
table(clu[,23]);

}

