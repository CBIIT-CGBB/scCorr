rm(list=ls());

library(scCorr);

## get data
## 5 clusters of CD4 T cells
ct.c   <- c(6:10); 
## tsne result/output
tsnef  <- "https://github.com/CBIIT-CGBB/scCorr/raw/master/data/01/do_tsne30_2000.txt";
tsne   <- read.table(tsnef, header=T);

## cluster matrix
cluf   <- "https://github.com/CBIIT-CGBB/scCorr/raw/master/data/01/03clust_table.txt";
clu    <- read.table(cluf, header=T, sep="\t");
## check row.names
sum(row.names(tsne)==row.names(clu))==nrow(clu);
## sample index of CD4 T cells in the cluster matrix
s.i    <- which(clu[,23] %in% ct.c);
## some single cells of CD4 T cells 
dat    <- tsne[s.i,];

out           <- c_list(dat, 40);
out.index     <- out[[1]];
out.cellname  <- out[[2]];

datf <- paste0(system.file("data",package="scCorr"), "/cd4_dat.Rdata")
load(datf)
cd4.i   <- which(colnames(cd4_dat) %in% row.names(dat));
cd4_dat <- cd4_dat[,cd4.i];
out1    <- get_value(cd4_dat, out.cellname);

g_clut  <- GCluster(dat, k = 40);
g_label <- g_clut$membership
names(g_label) <- row.names(dat);
out2    <- get_value(cd4_dat, g_label);
