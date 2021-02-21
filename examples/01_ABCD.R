rm(list=ls());
options(stringsAsFactors = F);
## load data
load('../data/cd4_dat.Rdata')
load('../data/cd8_dat.Rdata')
load('../data/NK_dat.Rdata')
load('../data/other_dat.Rdata')
load('../data/b_dat.Rdata')

source('supp_func.R');
## merge data
dat <- dplyr::bind_cols(cd4_dat,cd8_dat,b_dat,NK_dat,other_dat)
## gene annotation
ann <- read.table("../data/01/gene4matrix_Seurat.txt", header=T, row.names=1);
sum(row.names(dat)==row.names(ann))==nrow(ann);
## relationships of 3 pathway genes of KEGG
gene <- read.table("../data/01/hsa04662_f.txt", header=T);
g.u  <- unique(c(gene[,1], gene[,2]));
dat.i <- which(ann[,1] %in% g.u);
dat.s <- dat[dat.i,];
## count zero number of genes among cells
z1   <- apply(dat, 1, function(x) sum(x==0));
z1   <- z1/ncol(dat) * 100;

z2   <- apply(dat.s, 1, function(x) sum(x==0));
z2   <- z2/ncol(dat.s) * 100;

z3 <- apply(dat, 2, function(x) sum(x==0));
z3   <- z3/nrow(dat) * 100;

z4   <- apply(dat.s, 2, function(x) sum(x==0));
z4   <- z4/nrow(dat.s) * 100;

pdf("1_ABCD.pdf", 23, 20);
layout(matrix(c(1,2,3,4), nrow = 2, ncol = 2, byrow = TRUE));
par("mar"=c(7, 7, 7, 7));
cols <- rainbow(10, alpha=0.8);

hist(z1, col=cols[7], border=cols[7], breaks=100, xlim=c(70, 100), 
     font.main = 1,main="21430 full genes; 15973 single cells", xlab="",
     ylab = '',cex.main=3,cex.lab=4, cex.axis = 2.5);
title(ylab="Number of Genes", line=4, cex.lab=4, family = "sans")
title(xlab="% of Zero Value", line=4.5, cex.lab=4, family = "sans")
fig_label('A', pos='topleft',cex=5)

hist(z3, col=cols[7], border=cols[7], breaks=100, xlim=c(70, 100), 
     font.main = 1,main="15973 single cells; 21430 genes", xlab="",
     ylab = '',cex.main=3,cex.lab=4, cex.axis= 2.5);
title(ylab="Number of Cells", line=4, cex.lab=4, family = "sans")
title(xlab="% of Zero Value", line=4.5, cex.lab=4, family = "sans")
fig_label('B', pos='topleft',cex=5)

hist(z2, col=cols[7], border=cols[7], breaks=100, xlim=c(70, 100), 
     font.main = 1,main="347 pathway genes with 15973 single cells", xlab="",ylab = '',
     cex.main=3,cex.lab=4, cex.axis= 2.5);
title(ylab="Number of Genes", line=4, cex.lab=4, family = "sans")
title(xlab="% of Zero Value", line=4.5, cex.lab=4, family = "sans")
fig_label('C', pos='topleft',cex=5)

hist(z4, col=cols[7], border=cols[7], breaks=100, xlim=c(70, 100), 
     font.main = 1,main="15973 single cells with 347 pathway genes", xlab="",ylab = '',
     cex.main=3,cex.lab=4, cex.axis= 2.5);
title(ylab="Number of Cells", line=4, cex.lab=4, family = "sans")
title(xlab="% of Zero Value", line=4.5, cex.lab=4, family = "sans")
fig_label('D', pos='topleft',cex=5)

dev.off();


