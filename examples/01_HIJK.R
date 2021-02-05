cty <- read.table("./data/01/01cluster_ct.txt", header=T);
clu <- read.table("./data/01/03clust_table.txt", header=T);
pdf("1_HIJK.pdf", 40, 40);
layout(matrix(c(1,1,2,2,
                1,1,2,2,
                3,3,4,4,
                3,3,5,5), nrow = 4, ncol = 4, byrow = TRUE));
par("mar"=c(7, 7, 7, 7));

shadowtext <- function(x, y=NULL, labels, col='white', bg='black', 
                       theta= seq(0, 2*pi, length.out=50), r=0.1, ... ) {
  xy <- xy.coords(x,y)
  xo <- r*strwidth('A')
  yo <- r*strheight('A')
  # draw background text with small shift in x and y in background colour
  for (i in theta) {
    text( xy$x + cos(i)*xo, xy$y + sin(i)*yo, labels, col=bg, ... )
  }
  # draw actual text in exact xy position in foreground colour
  text(xy$x, xy$y, labels, col=col, ... )
}
cols <- rainbow(10, alpha=0.8);

clu.v <- clu[,23];
dat <- read.table("./data/01/do_tsne30_2000.txt", header=T); 



cty.n <- c("NK Cells", "CD4 T\nCells", "B Cell", "CD8 T\nCells",      
           "CD14\nMonocytes", "Dendritic\nCell", "FCGR3A\nMonocytes")

col0  <- rainbow(10, alpha=0.1);
cty.u <- unique(cty[,15]);
cols  <- rainbow(10, alpha=0.6)[c(1,2,3,6,7,8,9)];
plot(dat[,c(1,2)], xlab="", ylab="", pch=19, col=col0[7], 
     xlim=c(-50, 70), cex.main=2.3,cex.lab=2, cex.axis=2);
title(ylab="tSNE 2", line=4, cex.lab=4, family = "sans")
title(xlab="tSNE 1", line=4, cex.lab=4, family = "sans")
for (i in 1:length(cty.u)){
  n   <- cty.u[i];
  c.i <- which(cty[,15]==n);
  n.i <- which(clu.v %in% cty[c.i,1]);
  s.n <- row.names(clu)[n.i];
  d.i <- which(row.names(dat) %in% s.n);
  points(dat[d.i, c(1,2)], col=cols[i], pch=19, cex=0.4)
  x   <- mean(dat[d.i, 1]);
  y   <- mean(dat[d.i, 2]);
  shadowtext(x, y, cty.n[i],col ='black',bg = 'white',cex = 3);
}

col0 <- rainbow(10, alpha=0.6);
clu.n <- c(100,1000);
for (n in clu.n){
  clu.name <- paste0("clu", n);
  clu.i    <- which(colnames(clu) %in% clu.name);
  clu.v    <- clu[,clu.i];
  clu.u    <- unique(clu.v);
  clu.j    <- length(clu.u)
  set.seed(123);
  cols  <- rainbow(clu.j, alpha=0.6);
  cols  <- sample(cols);
  main  <- paste0("cluster number:", clu.j)
  plot(dat[,c(1,2)], pch=19, col=cols[clu.v], cex.main=3,font.main = 1,cex.lab=2, cex.axis=2, 
       xlab="", ylab="", main=main);
  title(ylab="tSNE 2", line=4, cex.lab=3.5, family = "sans")
  title(xlab="tSNE 1", line=4, cex.lab=4.5, family = "sans")
}


num    <- 15973;
dat    <- read.table("./data/01/02clust_table_raw.txt", header=T);

clu1.n <- seq(100, 1000, length.out = 10);
clu1.e <- num/clu1.n;
clu1.s <- paste0("clu", clu1.n);
clu2.n <- seq(10, 100, length.out = 10);
clu2.e <- num/clu2.n;
clu2.s <- paste0("clu", clu2.n);


cols  <- rainbow(10, alpha=0.8);

dat1.i <- which(colnames(dat) %in% clu1.s);
dat2.i <- which(colnames(dat) %in% clu2.s);

dat1.s <- dat[,dat1.i];
dat2.s <- dat[,dat2.i];

dat1.l <- NULL;
dat2.l <- NULL;
for (i in 1:10){
  dat1.l[[i]] <- as.numeric(table(dat1.s[,i]));
  dat2.l[[i]] <- as.numeric(table(dat2.s[,i]));
}
names(dat1.l) <- clu1.s;
names(dat2.l) <- clu2.s;
par(cex.axis=2)

par("mar"=c(5,7,5,5))
boxplot(dat2.l, col='#CCCC00', border = '#CC0000',
        names = c("10","20","30","40","50","60","70","80","90","100"),cex.lab=2);
points(1:10, clu2.e, col='#CC0000', pch=19,cex = 2);
title(ylab="Number of Cells", line=4, cex.lab=4, family = "sans")
title(xlab="Cluster Number", line=4, cex.lab=4, family = "sans")

boxplot(dat1.l, col='#CCCC00', border = '#CC0000',
        names = c("100","200","300","400","500","600","700","800","900","1000"),cex.lab=2);
points(1:10, clu1.e, col='#CC0000', pch=19,cex = 2);
title(ylab="Number of Cells", line=4, cex.lab=4, family = "sans")
title(xlab="Cluster Number", line=4, cex.lab=4, family = "sans")

dev.off();
