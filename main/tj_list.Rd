\name{tj_list}
\alias{tj_list}
\title{Merging by Trajectory Method}
\usage{
tj_list(dat, ctf)
}
\arguments{
\item{dat}{data matrix}
\item{ctf}{cutoff for the number of cells as a node}
}
\value{
A list of indices of data and a list of names of data.
}
\description{
This function uses the trajectory-based method to cluster cells. It returns 
the list of indices and name of cells after clustering. 
}

