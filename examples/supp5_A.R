rm(list=ls());

options(stringsAsFactors = F);
clu.n <- c(seq(40, 100, length.out = 7), seq(200, 1000, length.out = 9));
ty.n  <- c("CD4");
num.n <- c("n0", "n5", "n10", "n15");
top.n <- 40;

cols  <- rainbow(10, alpha=0.8);

pdff  <- paste0("supp5_A.pdf");
pdf(pdff, 9, 12);
par(mfrow=c(4,3));
for (t.n in ty.n){
  for (n.n in num.n){
    if (n.n == "n0"){
      inff  <- paste0("../data/supp/09cor_glm_clu_", t.n, "/", top.n, ".txt");
    } else {
      inff  <- paste0("../data/supp/13cor_glm_clu_", t.n, "_", n.n, "/", top.n, ".txt");
    }
    dat0  <- read.table(inff, header=T);
    gen0  <- paste0(dat0[1:10,1], "_", dat0[1:10,2]);
    
    out.s <- NULL;
    for (n in clu.n){
      if (n.n == "n0"){
        inff  <- paste0("../data/supp/09cor_glm_clu_", t.n, "/", n, ".txt");
      } else {
        inff  <- paste0("../data/supp/13cor_glm_clu_", t.n, "_", n.n, "/", n, ".txt");
      }
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
    if (length(i)>0){
      out.s[i, 5] <- max(out.s[-i,5]);
    }
    
    ylim  <- range(out.s[,5]);
    i     <- 0;
    main1 <- paste0(t.n, " ", n.n, " P value");
    for (g in gen.u){
      i <- i + 1;
      if (i == 1){
        g.j <- which(out.s[,2]==g);
        plot(out.s[g.j,5], type="b", col=cols[i], xlab="clu.num", ylab="-log10 P value", 
             ylim=ylim, pch=19, lwd=1.2, xaxt="n", main=main1);
      } else {
        g.j <- which(out.s[,2]==g);
        points(out.s[g.j,5], type="b", col=cols[i], pch=19, lwd=1.2);
      }
    }
    axis(1, at=1:length(clu.n), labels=clu.n)
    
    ylim  <- range(out.s[,3]);
    i     <- 0;
    main2 <- paste0(t.n, " ", n.n, " Pearson R");
    for (g in gen.u){
      i <- i + 1;
      if (i == 1){
        g.j <- which(out.s[,2]==g);
        plot(out.s[g.j,3], type="b", col=cols[i], xlab="clu.num", ylab="Pearson Correlation Coefficient", 
             ylim=ylim, pch=19, lwd=1.2, xaxt="n", main=main2);
      } else {
        g.j <- which(out.s[,2]==g);
        points(out.s[g.j,3], type="b", col=cols[i], pch=19, lwd=1.2);
      }
    }
    axis(1, at=1:length(clu.n), labels=clu.n)
    
    ylim  <- range(out.s[,4]);
    i     <- 0;
    main3 <- paste0(t.n, " ", n.n, " Spearman R");
    for (g in gen.u){
      i <- i + 1;
      if (i == 1){
        g.j <- which(out.s[,2]==g);
        plot(out.s[g.j,4], type="b", col=cols[i], xlab="clu.num", ylab="Spearman Correlation Coefficient", 
             ylim=ylim, pch=19, lwd=1.2, xaxt="n", main=main3);
      } else {
        g.j <- which(out.s[,2]==g);
        points(out.s[g.j,4], type="b", col=cols[i], pch=19, lwd=1.2);
      }
    }
    axis(1, at=1:length(clu.n), labels=clu.n);
  }
}
dev.off();
