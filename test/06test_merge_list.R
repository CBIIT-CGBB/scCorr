rm(list=ls());

library(scCorr);

## simulate data
set.seed(1234);
## length of list
list.l <- 50;
out.s  <- NULL;
for (i in 1:list.l){
  n          <- sample(1:50, 1);
  out.s[[i]] <- sample(1:100, n);
}
## check length
lengths(out.s);
out <- merge_list(out.s, cutoff=10)
## check output list lengths
lengths(out)

