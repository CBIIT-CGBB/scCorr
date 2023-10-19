# corr2pvalue in matrix data 
# calculate corralation coefficent and p value
m2p <- function(m, alternative="two-sided") {
  cat("calculate corralation coefficent ...\n")
  corMat <- cor(m, use=if (any(is.na(m))) 
    "pairwise.complete.obs" else
      "all")
  df <- crossprod(!is.na(m)) - 2
  STATISTIC <- sqrt(df) * corMat / sqrt(1 - corMat^2)
  p <- pt(STATISTIC, df)
  if (alternative == "less") {
    p <- p
  } else if (alternative == "greater") {
    p <- 1 - p
  } else {
    p <- 2 * pmin(p, 1 - p)
  }
  list(p=p, cor=corMat) 
}

##
## get index by the cutoffs
m2i <- function(m, type="p", cutoff=0.001){
  if (type=="cor"){
    n.i <- which(abs(m) > cutoff, arr.ind=TRUE); 
  } else {
    n.i <- which(m < cutoff, arr.ind=TRUE); 
  }
  ## exclude the same gene
  ## remove the same pairwise genes
  n.j <- which(n.i[,1] >= n.i[,2]);
  n.i <- n.i[-n.j,];
  return(n.i);
}
