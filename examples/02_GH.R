pdf("2_GH.pdf", 20,10);
layout(matrix(c(1,2), nrow = 1, ncol = 2, byrow = TRUE))
par("mar"=c(7, 7, 7, 2))



load("./data/02/06sc_roc.RData");
text2 <- paste0("Single Cell AUC:", round(out$auc, 2));

num  <- c(20:40, seq(10, 1000, length.out=100));
num  <- sort(unique(num));
num  <- num[-1];
cols <- rainbow(length(num), alpha=0.8);

text2 <- paste0("Unclustered Single Cell:", round(out$auc, 2));
main <- paste0(length(num), " clusters: 20-1000")
plot(out$perf@x.values[[1]], out$perf@y.values[[1]], type="l", col="black", lwd=2,
     xlab="", ylab="", 
     main=main,cex.main=3,cex.lab=2.5, cex.axis=2.5,font.main = 1);
title(ylab="True positive rate", line=4, cex.lab =4.5, family = "sans")
title(xlab="False positive rate", line=5, cex.lab =4.5, family = "sans")
segments(0, 0, 1, 1, lty=2);

i   <- 0;
out2 <- NULL;
for (n in num){
  i <- i + 1;
  inff <- paste0("./data/02/07clu_roc/CD4_", n, ".RData");
  load(inff);
  x <- out$perf@x.values[[1]];
  y <- out$perf@y.values[[1]];
  points(x, y, type="l", col=cols[i], lwd=2);
  out2 <- c(out2, out$auc);
}

text1 <- paste0("scCorr Cluster AUC:", round(mean(out2), 2));
text(0.7, 0.3, text1,cex=3.5);
text(0.7, 0.18, text2,cex=3.5);


load("./data/02/06sc_roc.RData");


text2 <- paste0("Unclustered Single Cell:", round(out$auc, 2));
cols  <- rainbow(10, alpha=0.8);

plot(out$perf@x.values[[1]], out$perf@y.values[[1]], type="l", col="black", lwd=2,
     xlab="", ylab="", 
     main="10 clusters: 100-1000",cex.main=3,cex.lab=2.5, cex.axis=2.5,font.main = 1);
title(ylab="True positive rate", line=4, cex.lab =4.5, family = "sans")
title(xlab="False positive rate", line=5, cex.lab =4.5, family = "sans")
segments(0, 0, 1, 1, lty=2);

num <- seq(100, 1000, length.out = 10);
i   <- 0;
out2 <- NULL;
for (n in num){
  i <- i + 1;
  inff <- paste0("./data/02/07clu_roc/CD4_", n, ".RData");
  load(inff);
  x <- out$perf@x.values[[1]];
  y <- out$perf@y.values[[1]];
  points(x, y, type="l", col=cols[i], lwd=2);
  out2 <- c(out2, out$auc);
}

text1 <- paste0("scCorr Cluster AUC:", round(mean(out2), 2));
text(0.7, 0.3, text1,cex=3.5);
text(0.7, 0.18, text2,cex=3.5);


dev.off()