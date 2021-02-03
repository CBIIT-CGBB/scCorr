
pdf("t2.pdf", 30, 20);
layout(matrix(c(1,2,3), nrow = 1, ncol = 3, byrow = TRUE));
par("mar"=c(7, 7, 7, 7));

f.s <- c(1000, 4000, 7000, 10000, 13000, 15973);
## gene number from 14do_simulation_num.R
num <- c(15719, 18612, 19775, 20488, 21014, 21430);
cols <- rainbow(10, alpha=0.8);
col2 <- cols[c(1,2,7,3,9,6)];
data(zero_dist);

boxplot(out.f$out.s, col=cols[7], border=cols[7], cex.axis=2.3);
title(font.main = 1,main="21430 full genes", xlab="", ylab = "",pch=19, cex.main=3,cex.lab=2, cex.axis= 2.5);
title(ylab="% of Zero Value", line=4, cex.lab=4, family = "sans");
title(xlab="Number of Cells", line=4.5, cex.lab=4, family = "sans");

boxplot(out.f$out2, col=cols[7], border=cols[7], cex.axis=2.3);
title(font.main = 1,main="347 pathway genes", xlab="", ylab = "",pch=19, cex.main=3,cex.lab=2, cex.axis= 2.5);
title(ylab="% of Zero Value", line=4, cex.lab=4, family = "sans");
title(xlab="Number of Cells", line=4.5, cex.lab=4, family = "sans");

for (i in 1:length(f.s)){
  n    <- f.s[i];
  inff <- paste0("n", n);
 # print(inff)
  data(list=inff);
  dat <- t(out.s);
  dat <- dat/num[i];
  v   <- apply(dat, 2, mean);
  colnames(dat) <- 1:200;
  main <- paste0("Single cell #:", n)
  if (i == 1){
    plot(v, type="l", col=col2[i], lwd=6, main="",
         xlab="", ylab="",cex.main=3, cex.axis=2.5);
    title(ylab="% of Zero Value", line=4, cex.lab=4, family = "sans")
    title(xlab="Number of Merged Cells", line=4.5, cex.lab=4, family = "sans")
    legend("topright", legend=f.s, lwd=6, title="Cell Number", bty="n", col=col2, cex = 4.5);
  } else {
    points(v, type="l", col=col2[i], lwd=6)
  }
  
}


dev.off();
