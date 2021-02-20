rm(list=ls());
options(stringsAsFactors = F);
library(Rtsne);

## load data
load('./data/cd4_dat.Rdata')
load('./data/cd8_dat.Rdata')
load('./data/NK_dat.Rdata')
load('./data/other_dat.Rdata')
load('./data/b_dat.Rdata')

dat   <- dplyr::bind_cols(cd4_dat, cd8_dat, b_dat, NK_dat, other_dat)
dat   <- as.matrix(dat);
dat.t <- t(dat); 
tsne  <- Rtsne(dat.t, dims = 2, perplexity=30, verbose=TRUE, 
               max_iter = 2000);
out   <- tsne$Y;
row.names(out) <- colnames(dat);
outfile        <- paste0("do_tsne30_2000.txt")
write.table(out, outfile, sep="\t", quote=F);

