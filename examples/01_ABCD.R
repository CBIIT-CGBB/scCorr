
load('./data/cd4_dat.Rdata')
load('./data/cd8_dat.Rdata')
load('./data/NK_dat.Rdata')
load('./data/other_dat.Rdata')
load('./data/b_dat.Rdata')

dat <- dplyr::bind_cols(cd4_dat,cd8_dat,b_dat,NK_dat,other_dat)
ann <- read.table("./data/01/gene4matrix_Seurat.txt", header=T, row.names=1);



gene <- read.table("./data/01/hsa04662_f.txt", header=T);
g.u  <- unique(c(gene[,1], gene[,2]));
dat.i <- which(ann[,1] %in% g.u);
dat.s <- dat[dat.i,];


z1   <- apply(dat, 1, function(x) sum(x==0));
z1   <- z1/ncol(dat) * 100;


z2   <- apply(dat.s, 1, function(x) sum(x==0));
z2   <- z2/ncol(dat.s) * 100;

z3 <- apply(dat, 2, function(x) sum(x==0));
z3   <- z3/nrow(dat) * 100;

z4   <- apply(dat.s, 2, function(x) sum(x==0));
z4   <- z4/nrow(dat.s) * 100;



pdf("1_ABCD.pdf", 40, 30);
layout(matrix(c(1,2,3,4), nrow = 2, ncol = 2, byrow = TRUE));
par("mar"=c(7, 7, 7, 7));
cols <- rainbow(10, alpha=0.8);


hist(z1, col=cols[7], border=cols[7], breaks=100, xlim=c(70, 100), 
     font.main = 1,main="21430 full genes; 15973 single cells", xlab="",
     ylab = '',cex.main=3,cex.lab=4, cex.axis = 2.5);
title(ylab="Number of Genes", line=4, cex.lab=4, family = "sans")
title(xlab="% of Zero Value", line=4.5, cex.lab=4, family = "sans")


hist(z3, col=cols[7], border=cols[7], breaks=100, xlim=c(70, 100), 
     font.main = 1,main="15973 single cells; 21430 genes", xlab="",
     ylab = '',cex.main=3,cex.lab=4, cex.axis= 2.5);
title(ylab="Number of Cells", line=4, cex.lab=4, family = "sans")
title(xlab="% of Zero Value", line=4.5, cex.lab=4, family = "sans")


hist(z2, col=cols[7], border=cols[7], breaks=100, xlim=c(70, 100), 
     font.main = 1,main="347 pathway genes with 15973 single cells", xlab="",ylab = '',
     cex.main=3,cex.lab=4, cex.axis= 2.5);
title(ylab="Number of Genes", line=4, cex.lab=4, family = "sans")
title(xlab="% of Zero Value", line=4.5, cex.lab=4, family = "sans")


hist(z4, col=cols[7], border=cols[7], breaks=100, xlim=c(70, 100), 
     font.main = 1,main="15973 single cells with 347 pathway genes", xlab="",ylab = '',
     cex.main=3,cex.lab=4, cex.axis= 2.5);
title(ylab="Number of Cells", line=4, cex.lab=4, family = "sans")
title(xlab="% of Zero Value", line=4.5, cex.lab=4, family = "sans")

dev.off();


