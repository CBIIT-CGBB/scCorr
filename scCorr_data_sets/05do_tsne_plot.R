rm(list=ls());

f.s <- dir("tsne", ".txt");
cols <- rainbow(10, alpha=0.6);

pdf("05do_tsne_plot.pdf", 8, 8);
par(mfrow=c(2,2));
for (f in f.s){
  inff <- paste0("tsne/", f);
  main <- gsub("tsne_", "", f);
  main <- gsub(".txt", "", main);
  dat  <- read.table(inff, header=T);
  plot(dat[,c(1,2)], pch=19, col=cols[7], xlab="tSNE 1", ylab="tSNE 2", main=main);
}
dev.off();

