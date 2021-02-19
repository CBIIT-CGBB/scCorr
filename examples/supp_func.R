## convert cluster matrix to cluster table
m2table <- function(dat){
  ## generate list, the last cluster ID and row.name
  c2n   <- list();
  ## the largest cluster number in the data set from the last columns
  clu.n <- length(unique(dat[,ncol(dat)]));
  for (i in 1:clu.n){
    j <- which(dat[,ncol(dat)] == i);
    c2n[[i]] <- row.names(dat)[j];
  }
  
  out.c <- NULL;
  out.n <- NULL;
  pb <- txtProgressBar(min = 0, max = length(ncol(dat)), style = 3);
  for (j in 1:ncol(dat)){
    out1 <- NULL;
    out2 <- NULL;
    for (i in 1:clu.n){
      n   <- c2n[[i]];
      k   <- which(row.names(dat) %in% n);
      clu <- unique(dat[k, j]);
      out1 <- c(out1, clu);
      out2 <- c(out2, length(k));
    }
    out.c <- cbind(out.c, out1);
    out.n <- cbind(out.n, out2);
    setTxtProgressBar(pb, j);
  }
  close(pb);
  colnames(out.c)  <- colnames(dat);
  colnames(out.n)  <- colnames(dat);
  row.names(out.c) <- paste0("clu", 1:clu.n);
  row.names(out.n) <- paste0("clu", 1:clu.n);
  return(list(cluID=out.c, cluNum=out.n));
}

mapper <- function(dat, clu, mst=TRUE){
  clu.u <- unique(clu);
  out.s <- NULL;
  for (i in 1:length(clu.u)){
    j <- which(clu==clu.u[i]);
    x <- mean(dat[j,1]);
    y <- mean(dat[j,2]);
    out.s <- rbind(out.s, c(x, y, length(j)));
  }
  mdat  <- out.s;
  row.names(mdat) <- paste0("clu", clu.u);
  colnames(mdat)  <- c("x", "y", "size");
  if (mst){
    dat.d <- dist(mdat[,c(1,2)]);
    g     <- igraph::graph_from_adjacency_matrix(as.matrix(dat.d), weighted =T, mode = "upper");
    mst.g <- igraph::minimum.spanning.tree(graph=g, weights=E(g)$weight);
    mst.e <- igraph::get.edgelist(mst.g);
    p1 <- c();
    p2 <- c();
    coord <- NULL;
    for (j in 1:nrow(mst.e)){
      p1.i <- which(row.names(mdat) == mst.e[j,1]);
      p2.i <- which(row.names(mdat) == mst.e[j,2]);
      coord <- rbind(coord, c(row.names(mdat)[p1.i], mdat[p1.i,1], mdat[p1.i,2], 
                              row.names(mdat)[p2.i], mdat[p2.i,1], mdat[p2.i,2]))
    }
    colnames(coord) <- c("node1", "node1.x", "node1.y", "node2", "node2.x", "node2.y");
    coord   <- coord[,c(2,3,5,6)];
    coord   <- as.matrix(coord);
    return(list(coord=mdat, seg.coord=coord));
  } else {
    return(list(coord=mdat, seg.coord=NA))
  }
}

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


