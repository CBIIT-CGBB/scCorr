rm(list=ls());

dat <- read.table("hsa04024_org.txt", header=T);
ty  <- rep("P", nrow(dat));
i   <- which(dat[,4] == "--|");
j   <- which(dat[,4] == "---");
ty[i] <- "N";
ty[j] <- "C";

df <- data.frame(dat, type=ty);
write.table(df, "hsa04024.txt", quote=F, sep="\t", row.names=F);

