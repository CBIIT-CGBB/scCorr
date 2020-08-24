\name{c_list}
\alias{c_list}
\title{Cluster Method To List}
\usage{
c_list(dat, l, method)
}
\arguments{
\item{dat}{Data file for Clustering}
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
