rm(list=ls());
source('supp_func.R');
pdf("supp1_AB.pdf", 20,10);
layout(matrix(c(1,1,2,2,0,5,5,5,
                1,1,2,2,0,5,5,5,
                3,3,4,4,0,5,5,5,
                3,3,4,4,0,0,0,0), nrow = 4, ncol = 8, byrow = TRUE))
par("mar"=c(7, 7, 7, 2))

f.s <- c(1000, 4000, 7000, 10000, 16337);

## gene number from 14do_simulation_num.R
num <- c(17992, 21145, 22461, 23257, 24304);
cols <- rainbow(10, alpha=0.8);
col2 <- cols[c(1,2,7,9,6)];
for (i in 1:4){
  n    <- f.s[i];
  inff <- paste0("../data/supp/14do_simulation/n", n, ".RData");
  load(inff);
  dat <- t(out.s);
  dat <- dat/num[i];
  v   <- apply(dat, 2, mean);
  colnames(dat) <- 1:200;
  main <- paste0("Single cell #:", n)
  plot(v, type="l", col=col2[i], lwd=2, main="",
       xlab="", ylab="");
  title(font.main = 1,main=main, xlab="", ylab = "",pch=19, cex.main=3,cex.lab=2, cex.axis= 2.5);
  title(ylab="zero percentage", line=4, cex.lab=2, family = "sans")
  title(xlab="merged cell number", line=4.5, cex.lab=2, family = "sans")
  if(i == 1){
    fig_label('A', pos='topleft',cex=5)
  }
}

for (i in 1:length(f.s)){
  n    <- f.s[i];
  inff <- paste0("../data/supp/14do_simulation/n", n, ".RData");
  load(inff);
  dat <- t(out.s);
  dat <- dat/num[i];
  v   <- apply(dat, 2, mean);
  colnames(dat) <- 1:200;
  main <- paste0("Single cell #:", n)
  if (i == 1){
    plot(v, type="l", col=col2[i], lwd=2, main="",
         xlab="", ylab="");
    legend("topright", legend=f.s, lwd=2, title="Cell Number", bty="n", col=col2);
    title(font.main = 1,main='B cells', xlab="", ylab = "",pch=19, cex.main=3,cex.lab=2, cex.axis= 2.5);
    title(ylab="zero percentage", line=4, cex.lab=2, family = "sans")
    title(xlab="merged cell number", line=4.5, cex.lab=2, family = "sans")
  } else {
    points(v, type="l", col=col2[i], lwd=2, main="", main="",
           xlab="", ylab="")
  }
}
fig_label('B', pos='topleft',cex=5)
dev.off()

