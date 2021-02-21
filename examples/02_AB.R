rm(list=ls());
source('supp_func.R');
pdf("2_AB.pdf", 20,10);
layout(matrix(c(1,2), nrow = 1, ncol = 2, byrow = TRUE))
par("mar"=c(7, 7, 7, 2))
dat1     <- read.table("../data/02/08cor_glm_CD4.txt", header=T);
dat1[,8] <- -log10(dat1[,8]);
gen1     <- paste0(dat1[,1], "_", dat1[,2]);
dat1.i   <- which(dat1[,8] > -log10(0.05));
g1.s     <- gen1[dat1.i];

n <- 100
clu.n <- 100
cols  <- rainbow(10, alpha=0.8);
dat2 <- read.table('../data/02/100.txt', header=T);
dat2[,8] <- -log10(dat2[,8]);
gen2   <- paste0(dat2[,1], "_", dat2[,2]);
dat2.i <- which(dat2[,8] > -log10(0.05));
g2.s   <- gen2[dat2.i];
g.s    <- unique(c(g1.s, g2.s));
d1.j   <- match(g.s, gen1);
d2.j   <- match(g.s, gen2);
t.s    <- dat1[d1.j, 3] * dat2[d2.j, 3];
t.s.i  <- which(t.s < 0);
col2   <- rep(cols[7], length(d1.j));
col2[t.s.i] <- cols[1];
main   <- paste0(n," Clusters -log10 P value");
main2  <- paste0(n," Clusters Pearson Correlation");
plot(dat1[d1.j,8], dat2[d2.j,8], main=main, xlab="", ylab="",
     col=col2, pch=19, cex=5,cex.main=3,font.main = 1,cex.lab=2.5, cex.axis=2.5);
title(ylab="scCorr Cluster", line=4, cex.lab =4.5, family = "sans")
title(xlab="Unclustered Single Cell", line=5, cex.lab =4.5, family = "sans")
fig_label('A', pos='topleft',cex=5)

plot(dat1[d1.j,3], dat2[d2.j,3], main=main2,  xlab="", ylab="",
     col=col2, pch=19, cex=5,cex.main=3,font.main = 1,cex.lab=2.5, cex.axis=2.5);
title(ylab="scCorr Cluster", line=4, cex.lab =4.5, family = "sans")
title(xlab="Unclustered Single Cell", line=5, cex.lab =4.5, family = "sans")
abline(v=0,col='black',lty=5,lwd=4)
abline(h=0,col='black',lty=5,lwd=4)
fig_label('B', pos='topleft',cex=5)
dev.off();
