#!/usr/local/apps/R/3.5/3.5.2/bin/Rscript

options(stringsAsFactors = F);
argv    <- commandArgs(TRUE);
ct.s    <- argv[1];
library(Rtsne);

#for (i in 1:nrow(ct)){
  inff <- paste0("ct_", ct.s, ".RData");
  load(inff);
  dat.t <- t(cdat);
  tsne       <- Rtsne(dat.t, dims = 2, perplexity=30, verbose=TRUE, max_iter = 2000);
  out        <- tsne$Y;
  row.names(out) <- colnames(cdat);
  outfile        <- paste0("tsne/tsne_", ct.s, ".txt")
  write.table(out, outfile, sep="\t", quote=F);
#}
