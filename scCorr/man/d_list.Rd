\name{d_list}
\alias{d_list}
\title{Merging by Density Method }
\usage{
c_list(coordinates, l)
}
\arguments{
\item{coordinates}{An array of chosen coordinate of the data}
\item{l}{Number of windows}
}
\value{
A list of indices of data and a list of names of data after merging.
}
\description{
This function uses the density-based method to merge the cells. It returns 
the list of indices and name of cells after clustering. 
}
