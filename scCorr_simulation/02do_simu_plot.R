rm(list=ls());

## 16621 genes
## 2109 cells
load("01do_simulation.RData");

cols <- rainbow(10, alpha=0.8);

pdf("02do_simu_plot.pdf", 6, 6);
dat <- t(out.s);
dat <- dat/16621 * 100;
colnames(dat) <- 1:ncol(dat);
boxplot(dat, ylab="zero %", xlab="cell number", pch=19, col=cols[7], border=cols[7], cex=0.2);
dev.off();

pdf("02do_simu_plot2.pdf", 6, 6);
dat <- t(out.s);
dat <- dat/16621 * 100;
colnames(dat) <- 1:ncol(dat);
boxplot(dat[,c(1:20)], ylab="zero %", xlab="cell number per group", pch=19, col=cols[7], border=cols[7], cex=0.2);
dev.off();