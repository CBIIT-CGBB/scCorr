\name{m_list}
\alias{m_list}
\title{Merging single cell by window sizes.}
\usage{
m_list(coordinates, l)
}
\arguments{
\item{coordinates}{An array of chosen coordinate of the data}
\item{l}{Number of windows}
}
\value{
A list of indices of data and a list of names of data after merging.
}
\description{
This function uses the window-based method to merge the cells. It returns 
the list of indices and name of cells after clustering. 
}

\examples{
rm(list=ls());

library(scCorr);

## get data
## clusters of CD4 T cells
ct.c   <- c(6:10, 12:16, 19,20, 28:33); 
## tsne result/output
tsnef  <- "https://github.com/CBIIT-CGBB/scCorr/raw/master/data/01/do_tsne30_2000.txt";
tsne   <- read.table(tsnef, header=T);

## cluster matrix
cluf   <- "https://github.com/CBIIT-CGBB/scCorr/raw/master/data/01/03clust_table.txt";
clu    <- read.table(cluf, header=T, sep="\t");

## make coordinate vector
## sample index of CD4 T cells in the cluster matrix
s.i    <- which(clu[,23] %in% ct.c);
## CD4 T cells 
tsne <- tsne[s.i,];
dat  <- tsne[,1];
names(dat) <- row.names(tsne);

out <- m_list(dat, l=30)
out.index     <- out[[1]];
out.cellname  <- out[[2]];
  
}  
