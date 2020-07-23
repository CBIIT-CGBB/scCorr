rm(list=ls());

options(stringsAsFactors = F);
ct.s <- c("Bcell");

dat  <- NULL;
for (ct in ct.s){
  infd <- paste0("../scCorr_data_sets/ct_", ct, ".RData");
  load(infd);
  if (ct == "Bcell"){
    dat <- cdat;
  } else {
    dat  <- cbind(dat, cdat);
  }
}

## remove genes without reads
v0    <- apply(dat, 1, function(x) sum(x));
v0.i  <- which(v0==0);
dat.s <- dat[-v0.i,];
dat.s <- as.matrix(dat.s);

## permutation number
p_n <- 1000;
## cell number
c_num <- 2:200;

set.seed(1234);
## for single cell
out <- NULL;
for (i in 1:p_n){
  c.i <- sample(1:ncol(dat.s), 1);
  out <- c(out, sum(dat.s[,c.i]==0));   
}
out.s <- out;
## for more than 2 cells
for (j in c_num){
  print(j);
  out <- NULL;
  for (i in 1:p_n){
    c.i <- sample(1:ncol(dat.s), j);
    g.v <- apply(dat.s[,c.i], 1, function(x) sum(x));
    out <- c(out, sum(g.v==0));   
  }
  out.s <- rbind(out.s, out);
}

save(out.s, file="01do_simulation.RData");

