rm(list=ls());
options(stringsAsFactors = F);
pdf("supp6_ABC.pdf", 15,5);
layout(matrix(c(1,2,3), nrow = 1 , ncol = 3, byrow = TRUE))
par("mar"=c(5, 5, 7, 5))


## Equation
eq = function(x){80*(1250*x - 140823)/1700}
plot(eq(100:500), type='l',,main  = 'range(xy) = 112.65840 + 0.01799 * cell number',ylab = '', xlab = 'Range of XY Coordinates')
## Compution Time for 5967 single cells
out.s <- read.table("../data/supp/01clust1_out.txt", header=T);
clu.u <- unique(out.s[,1]);
y.max <- max(out.s[,3]);
cols  <- rainbow(length(clu.u), alpha=0.8);
o.i <- which(out.s[,1]==10);
out <- out.s[o.i,];
plot(out[,2], out[,3], xlab="xy.coordinate", ylab="Time (minute)", 
     type="l", col=cols[1], lwd=2, main="cutoff = 4", ylim=c(0, y.max));
for (i in 2:length(clu.u)){
  o.i <- which(out.s[,1]==clu.u[i]);
  out <- out.s[o.i,];
  points(out[,2], out[,3], type="l", col=cols[i], lwd=2);
}
legend(20, 170, legend=clu.u[1:10], lwd=2, col=cols[1:10], bty="n");
legend(150, 170, legend=clu.u[10:19], lwd=2, col=cols[10:19], bty="n");

## Compution Time for 15973 single cells
out.s <- read.table("../data/supp/02clust2_out.txt", header=T);
clu.u <- unique(out.s[,1]);
y.max <- max(out.s[,3]);
clu.u <- unique(out.s[,1]);
cols  <- rainbow(length(clu.u), alpha=0.8);
o.i <- which(out.s[,1]==10);
out <- out.s[o.i,];
plot(out[,2], out[,3], xlab="xy.coordinate", ylab="Time (minute)", 
     type="l", col=cols[1], lwd=2, main="cutoff = 4", ylim=c(0, y.max));
for (i in 2:length(clu.u)){
  o.i <- which(out.s[,1]==clu.u[i]);
  out <- out.s[o.i,];
  points(out[,2], out[,3], type="l", col=cols[i], lwd=2);
}
legend(200, 550, legend=clu.u[1:10], lwd=2, col=cols[1:10], bty="n");
legend(350, 550, legend=clu.u[10:19], lwd=2, col=cols[10:19], bty="n");
dev.off();

