rm(list=ls());

dat <- read.table(gzfile("matrix_nor_Seurat.txt.gz"), header=T);
ann <- read.table("gene4matrix.txt", header=T, row.names=1);
ct  <- read.table("do_tsne30_2000_ctype.txt", header=T);

sum(row.names(dat)==row.names(ann))==nrow(dat);
sum(colnames(dat)==row.names(ct))==nrow(ct);

ct.n  <- unique(ct[,4]);
out.s <- NULL;
for (c.n in ct.n){
  i <- which(ct[,4]==c.n);
  out.s <- c(out.s, length(i))
  n <- row.names(ct)[i];
  dat.i <- which(colnames(dat) %in% n);
  outf  <- paste0("ct_", c.n, ".RData");
  cdat  <- dat[,dat.i];
  save(cdat, file=outf);
}

df <- data.frame(ct=ct.n, number=out.s);
write.table(df, "cell_type_number.txt", quote=F, sep="\t", row.names=F);

