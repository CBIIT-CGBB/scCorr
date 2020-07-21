rm(list=ls());

options(stringsAsFactors = F);
dat  <- read.table("gene4matrix.txt", header=T);
kegg <- read.table("hsa04024.txt", header=T);

g1.i <- which(kegg[,1] %in% dat[,2]);
g2.i <- which(kegg[,2] %in% dat[,2]);
g.i  <- intersect(g1.i, g2.i);

write.table(kegg[g.i,], "hsa04024_f.txt", quote=F, sep="\t");

