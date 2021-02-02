load("../data_sets/matrix_nor_Seurat.RData")
ann <- read.table("../data_sets/gene4matrix_Seurat.txt", header=T, row.names=1);
sum(row.names(dat)==row.names(ann))==nrow(dat);



z1   <- apply(dat, 1, function(x) sum(x==0));
z1   <- z1/ncol(dat) * 100;

gene <- read.table("../data_sets/hsa04662_f.txt", header=T);
g.u  <- unique(c(gene[,1], gene[,2]));

dat.i <- which(ann[,1] %in% g.u);
dat.s <- dat[dat.i,];

z2   <- apply(dat.s, 1, function(x) sum(x==0));
z2   <- z2/ncol(dat.s) * 100;

cols <- rainbow(10, alpha=0.8);

z3 <- apply(dat, 2, function(x) sum(x==0));
z3   <- z3/nrow(dat) * 100;

z4   <- apply(dat.s, 2, function(x) sum(x==0));
z4   <- z4/nrow(dat.s) * 100;

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
