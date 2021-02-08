
# data: tSNE output  
# clu: cluster IDs are correspondence to data row name. 

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



  



