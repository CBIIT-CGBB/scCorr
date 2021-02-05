pdf("2_EF.pdf", 20,10);
layout(matrix(c(1,2), nrow = 1, ncol = 2, byrow = TRUE))
par("mar"=c(7, 7, 7, 2))


clu.n <- c(seq(40, 100, length.out = 7), seq(200, 1000, length.out = 9));
cols  <- rainbow(10, alpha=0.8);


dat0  <- read.table("./data/02/cor_glm_clu_CD4_n5/40.txt", header=T);
gen0  <- paste0(dat0[1:10,1], "_", dat0[1:10,2]);

out.s <- NULL;
for (n in clu.n){
  inff <- paste0("./data/02/cor_glm_clu_CD4_n5/", n, ".txt");
  dat2 <- read.table(inff, header=T);
  dat2[,8] <- -log10(dat2[,8]);
  gen2   <- paste0(dat2[,1], "_", dat2[,2]);
  g2.i   <- match(gen0, gen2);
  df.s   <- data.frame(clu=rep(n, length(gen0)), genes=gen0, 
                       pearson.R=dat2[g2.i,3], spearman.R=dat2[g2.i,4], fdr=dat2[g2.i,8]);
  out.s  <- rbind(out.s, df.s);
}

gen.u <- unique(out.s[,2]);
i     <- which(is.infinite(out.s[,5]));
out.s[i, 5] <- max(out.s[-i,5]);

ylim <- range(out.s[,5]);
i    <- 0;
for (g in gen.u){
  i <- i + 1;
  if (i == 1){
    g.j <- which(out.s[,2]==g);
    plot(out.s[g.j,5], type="b", col=cols[i], xlab="", ylab="", 
         ylim=ylim, pch=19, lwd=4,cex.main=3,cex.lab=2.5, cex.axis=2.5,xaxt='n',cex = 4);
    title(ylab="-log10 P Value", line=4, cex.lab =4.5, family = "sans")
    title(xlab="Number of Clusters", line=5, cex.lab =4.5, family = "sans")
  } else {
    g.j <- which(out.s[,2]==g);
    points(out.s[g.j,5], type="b", col=cols[i], pch=19, lwd=4,cex = 4);
  }
}
axis(1, at=1:length(clu.n), labels=clu.n,cex.axis=2.5)

ylim <- range(out.s[,3]);
i    <- 0;
for (g in gen.u){
  i <- i + 1;
  if (i == 1){
    g.j <- which(out.s[,2]==g);
    plot(out.s[g.j,3], type="b", col=cols[i], xlab="", ylab="", 
         ylim=ylim, pch=19, lwd=4,cex.main=3,cex.lab=2, cex.axis=2.5,cex = 4,xaxt='n');
    title(ylab="Pearson R Value", line=4, cex.lab =4.5, family = "sans")
    title(xlab="Number of Clusters", line=5, cex.lab =4.5, family = "sans")
  } else {
    g.j <- which(out.s[,2]==g);
    points(out.s[g.j,3], type="b", col=cols[i], pch=19, lwd=4,cex = 4);
  }
}
axis(1, at=1:length(clu.n), labels=clu.n,cex.axis=2.5)

dev.off()