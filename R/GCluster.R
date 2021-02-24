## merge clusters: if the cluster number > k
merge_short_dist <- function(dat.m, k){
  do.dist <- TRUE;
  while(do.dist){
    ## calculate distance
    dat.d <- dist(dat.m);
    ## reformat 
    m <- data.frame(t(combn(rownames(dat.m),2)), as.numeric(dat.d));
    ## get the shortest distance
    c.i <- which.min(m[,3]);
    ## names of nodes in the shortest distance
    r1 <- m[c.i,1];
    r2 <- m[c.i,2];
    ## get the indices of the nodes
    r1.i <- which(row.names(dat.m)==r1);
    r2.i <- which(row.names(dat.m)==r2);
    ## calculate the average of the coordinates of the merged nodes 
    x.m <- mean(dat.m[c(r1.i, r2.i), 1]);
    y.m <- mean(dat.m[c(r1.i, r2.i), 2]);
    ## remove the merged nodes
    oth.n <- row.names(dat.m)[-c(r1.i, r2.i)];  ## for nrow==2 only
    dat.m <- dat.m[-c(r1.i, r2.i),];
    ## add the new node, the average of the coordinates of the merged nodes 
    dat.m <- rbind(dat.m, c(x.m, y.m));
    ## name the new node names 
    if (dim(dat.m)[1]==2){
      row.names(dat.m)[1] <- oth.n;
    }
    row.names(dat.m)[nrow(dat.m)] <- paste0(r1, ".", r2);
    ## 
    if (nrow(dat.m) <= k){
      do.dist <- FALSE;
    }
  }
  return(dat.m);
}

##
GCluster <- function(dat=dat, wt=4, k=NULL, method="louvain"){
  ## check dat is object of igraph
  in.g <- FALSE;
  if (class(dat)=="dist"){
    dat.d <- dat;
  } else if (class(dat)=="igraph") {
    in.g <- TRUE;
  } else {
    dat.s   <- as.matrix(dat);
    dat.d   <- dist(dat.s);
  }

  ## BEGIN k is NULL
  ## If k is NULL, the clustering is performed by wt only.
  if (is.null(k) | in.g){
    if (!is.numeric(wt)){
      stop("If \"k\" is NULL, \"wt\" must be numeric.");
    }
    cat("make graph ...\n")
    if (in.g){
      g <- dat;
    } else {
      g       <- igraph::graph_from_adjacency_matrix(as.matrix(dat.d), weighted =T, mode = "upper");
    }
    w.i     <- which(E(g)$weight > wt);
    igraph::E(g)$weight[w.i] <- 0;
    cat("do graph clustering without k  ...\n")
    if (method=="louvain"){
      out     <- igraph::cluster_louvain(g, weights = E(g)$weight);  
    } else if (method=="fast_greedy"){
      out     <- igraph::cluster_fast_greedy(g, weights = E(g)$weight);
    } else if (method=="infomap"){
      out     <- igraph::cluster_infomap(g, e.weights = E(g)$weight);
    } else if (method=="label_prop"){
      out     <- igraph::cluster_label_prop(g, weights = E(g)$weight); 
    } else if (method=="spinglass"){
      out     <- igraph::cluster_spinglass(g, weights = E(g)$weight); 
    } else {
      stop("The method is louvain, fast_greedy, infomap, label_prop or spinglass.\n")
    }
    
    return(out);
  }
  ## END k is NULL
  
  ## BEGIN if k is not NULL
  ## 
  k <- round(k);
  ## initial the weight
  if (!is.numeric(wt)){
    warning("The wt (weight) is not initialed. wt will be 3.");
    wt <- 3;
  }
  cat("make graph ...\n")
  if (in.g){
    g       <- dat;
  } else {
    g       <- igraph::graph_from_adjacency_matrix(as.matrix(dat.d), weighted =T, mode = "upper");
  }
  
  g0      <- g;
  w.i     <- which(E(g)$weight > wt);
  igraph::E(g)$weight[w.i] <- 0;
  cat("make graph clustering with k ...\n")
  if (method=="louvain"){
    out     <- igraph::cluster_louvain(g, weights = E(g)$weight);  
  } else if (method=="fast_greedy"){
    out     <- igraph::cluster_fast_greedy(g, weights = E(g)$weight);
  } else if (method=="infomap"){
    out     <- igraph::cluster_infomap(g, e.weights = E(g)$weight);
  } else if (method=="label_prop"){
    out     <- igraph::cluster_label_prop(g, weights = E(g)$weight); 
  } else if (method=="spinglass"){
    out     <- igraph::cluster_spinglass(g, weights = E(g)$weight); 
  } else {
    stop("The method is louvain, fast_greedy, infomap, label_prop or spinglass.\n")
  }
  cat("graph clustering was done.\n")
  clu.i   <- out$membership;
  clu.n   <- length(unique(clu.i));
  wt0     <- wt;

  ## BEGIN: if the cluster number < k
  if (clu.n < k){
    do.cluster <- TRUE;
    while (do.cluster){
      wt0     <- wt0 - wt0/2;
      g       <- g0;
      w.i     <- which(E(g)$weight > wt0);
      igraph::E(g)$weight[w.i] <- 0;
      cat("re-make graph clustering ...\n")
      if (method=="louvain"){
        out     <- igraph::cluster_louvain(g, weights = E(g)$weight);  
      } else if (method=="fast_greedy"){
        out     <- igraph::cluster_fast_greedy(g, weights = E(g)$weight);
      } else if (method=="infomap"){
        out     <- igraph::cluster_infomap(g, e.weights = E(g)$weight);
      } else if (method=="label_prop"){
        out     <- igraph::cluster_label_prop(g, weights = E(g)$weight); 
      } else if (method=="spinglass"){
        out     <- igraph::cluster_spinglass(g, weights = E(g)$weight); 
      } else {
        stop("The method is louvain, fast_greedy, infomap, label_prop or spinglass.\n")
      }
      clu.i   <- out$membership;
      clu.n   <- length(unique(clu.i));
      if (clu.n >= k){
        do.cluster <- FALSE;
      }
    }
  }
  ## END: if the cluster number < k
  if (clu.n == k){
    return(out);
  } 
  
  ## if clu.n > k
  ## calculate the centers of the clusters
  out.s <- NULL;
  for (i in 1:clu.n){
    s.i <- which(clu.i == i);
    x.m <- mean(dat.s[s.i, 1]);
    y.m <- mean(dat.s[s.i, 2]);
    out.s <- rbind(out.s, c(x.m, y.m));
  }

  row.names(out.s) <- c(1:nrow(out.s));
  out.m <- merge_short_dist(out.s, k);
  out.i <- grep(".", row.names(out.m));
  out.l <- list();
  for (j in 1:length(out.i)){
    out.l[[j]] <- unlist(strsplit(row.names(out.m)[out.i[j]], "[.]"));
  }
  out.c <- mgGCluster(out$membership, out.l, rename=TRUE);
  out$membership <- out.c$renamed;
  return(out);
}






