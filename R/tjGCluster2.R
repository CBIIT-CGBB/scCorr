tjGCluster2 <- function(m, from=NULL, to=NULL, cutoff=25){
  tj.out   <- tjGCluster(m, from=from, to=to);
  br.list  <- branch_list(tj.out$mst, tj.out$node);
  br.len   <- unlist(lapply(br.list, length));
  br.i     <- which(br.len > cutoff);
  if (length(br.i) < 1){
    return(list(coord=tj.out$coord, node=tj.out$node, mst=tj.out$mst, level=br.list));
  }
  br.out   <- br.list[br.i];
  br2.n    <- lapply(br.out, "[[", 1);
  br2.list <- list();
  for (br.j in 1:length(br.out)){
    n        <- br.out[[br.j]];
    n.i      <- which(V(tj.out$mst)$name %in% n);
    mst2     <- igraph::induced_subgraph(tj.out$mst, n.i);
    tj2.out  <- tjGCluster(mst2);
    br3.list <- branch_list(tj2.out$mst, tj2.out$node);
    br2.list[[br.j]] <- br3.list;
  }
  names(br2.list) <- br2.n;
  ## add the sub brach coordinates
  coord <- NULL;
  for (i in 1:length(br2.list)){
    l.n <- unlist(br2.list[[i]]);
    for (n1 in tj.out$node){
      l.n2   <- c(n1, l.n);
      mst2.i <- which(V(tj.out$mst)$name %in% l.n2);
      mst2   <- igraph::induced_subgraph(tj.out$mst, mst2.i);
      mst2.o <- igraph::components(mst2);
      mst2.l <- length(unique(mst2.o$membership));
      if (mst2.l == 2){
        # the vecter, n1, was not linked with the branch
        next;
      }
      l.n3 <- n1;
    }
    ## the sub-brach linked main branch
    l.n4 <- unique(c(l.n, l.n3));
    l.j  <- which(row.names(m) %in% l.n4);
    m.s  <- m[l.j,]
    
    out3  <- tjGCluster(m.s, from=l.n3);
    coord <- rbind(coord, out3$coord);
  }
  coord <- rbind(tj.out$coord, coord);
  return(list(coord=coord, node=tj.out$node, mst=tj.out$mst, level1=br.list, level2=br2.list));
}

branch_list <- function(g, nodes){
  ## g: mst graph; nodes: the spine skeleton vertices of g
  ## remove vectices from the mst
  g2   <- igraph::delete_vertices(g, nodes)
  ## get the braches
  g2.o <- igraph::components(g2)
  ## brach indices
  g2.c <- g2.o$membership;
  
  g2.u   <- unique(g2.c);
  out1   <- list();
  list.i <- 0;
  pb <- txtProgressBar(min = 0, max = length(nodes), style = 3);
  i  <- 0;
  for (n1 in nodes){
    i       <- i + 1;
    touched <- 0;
    for (g.u.i in g2.u){
      g2.i   <- which(g2.c==g.u.i);
      g2.n   <- V(g2)$name[g2.i];
      n2     <- c(n1, g2.n);
      mst2.i <- which(V(g)$name %in% n2);
      mst2   <- igraph::induced_subgraph(g, mst2.i);
      mst2.o <- igraph::components(mst2);
      mst2.l <- length(unique(mst2.o$membership));
      if (mst2.l > 2){
        stop("check g.u.i loop.")
      }
      if (mst2.l == 2){
        # the vecter, n1, was not linked with the branch
        next;
      }
      list.i <- list.i + 1;
      out1[[list.i]] <- c(n1, g2.n);
      touched <- 1;
    }
    if (touched==0){
      list.i <- list.i + 1;
      out1[[list.i]] <- n1;
    }
    setTxtProgressBar(pb, i);
  }
  close(pb);
  return(out1);
}

tree_list <- function(g, nodes){
  n.i   <- which(V(g)$name %in% nodes);
  g2    <- igraph::delete_vertices(g, nodes)
  g2.o  <- igraph::components(g2)
  g2.c  <- g2.o$membership;
  g2.u  <- unique(g2.c);
  out1  <- list();
  pb <- txtProgressBar(min = 0, max = length(nodes), style = 3);
  i  <- 0;
  for (n1 in nodes){
    i <- i + 1;
    touched <- 1;
    for (g.u.i in g2.u){
      ## check if the node linked the sub-graph
      g2.i   <- which(g2.c==g.u.i);
      g2.n   <- V(g2)$name[g2.i];
      n2     <- c(n1, g2.n);
      mst2.i <- which(V(g)$name %in% n2);
      mst2   <- igraph::induced_subgraph(g, mst2.i);
      mst2.o <- igraph::components(mst2);
      mst2.l <- length(unique(mst2.o$membership));
      if (mst2.l == 2){
        # n1, was not linked with the branch (the vecter g2.n)
        next;
      }
      if (touched > 1){
        out1[[i]] <- c(out1[[i]], n2);
        out1[[i]] <- unique(out1[[i]]);
      } else {
        out1[[i]] <- n2;
      }
      touched   <- touched + 1;
    }
    if (touched == 1){
      out1[[i]] <- n1;
    }
    setTxtProgressBar(pb, i);
  }
  close(pb);
  return(out1);
} 