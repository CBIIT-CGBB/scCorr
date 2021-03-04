\name{merge_list}
\alias{merge_list}
\title{Merging list}
\usage{
merge_list(list,cutoff = 25)
}
\arguments{
\item{l}{ an list of cell numbers by clusters}
\item{ctf}{cutoff for the cell number}
}
\value{
A list of indices of data and a list of names of data.
}
\description{
  merge cluster into adjacent cluster if the merged cluster single 
  cell number less than the cutoff.
}

\examples{
rm(list=ls());

library(scCorr);

## simulate data
set.seed(1234);
## length of list
list.l <- 50;
out.s  <- NULL;
for (i in 1:list.l){
  n          <- sample(1:50, 1);
  out.s[[i]] <- sample(1:100, n);
}
## check length
lengths(out.s);
out <- merge_list(out.s, cutoff=10)
## check output list lengths
lengths(out)
  
}  
