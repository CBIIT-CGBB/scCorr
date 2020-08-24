\name{tj_list}
\alias{tj_list}
\title{trajectory_method_list}
\usage{
tj_list(dat, ctf)
}
\arguments{
\item{dat}{data matrix}
\item{ctf}{cutoff for the number of cells as a node}
}
\value{
A list of indices and name of cells.
}
\description{
This function uses the trajectory-based method cluster the cells. It returns 
the list of indices and name of cells after clustering. 
}
