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
    mst.g <- igraph::minimum.spanning.tree(graph=g, weights=igraph::E(g)$weight);
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

scale.v <- function(v, a, b) {
  v <- v-min(v);
  v <- v/max(v);
  v <- v*(b-a);
  v+a
}

count.rows2 <- function(x){
  out   <- as.data.frame(table(as.data.frame(x)));
  out.i <- which(out[,3]==0);
  if (length(out.i) > 0){
    out   <- out[-out.i,];
  }
  out.j <- order(out[,1]);
  out   <- out[out.j,];
  out   <- out[,c(3,1,2)];
  out;
}

## radian and degree
n2p <- function(cx, cy, r, n, start.w=1, end.w=360){
  dg   <- seq(start.w, end.w, length.out=n) + 270;
  w    <- dg/180*pi;
  x    <- cx + r*cos(w);
  y    <- cy - r*sin(w);
  y    <- y;
  return(list(x=x, y=y));
}

y2y <- function(y){
  xylim   <- par("usr");
  plotdim <- par("pin");
  ymult   <- (xylim[4] - xylim[3])/(xylim[2] - xylim[1]) * plotdim[1]/plotdim[2];
  y       <- y * ymult;
}

distance <- function(from, to){
  D <- sqrt((abs(from[,1]-to[,1])^2) + (abs(from[,2]-to[,2])^2))
  return(D)
}

angle0 <- function(from, to){
  # dot.prods <- rowSums(from * to)
  dot.prods <- from$x*to$x + from$y*to$y
  norms.x <- distance(from = `[<-`(from,,,0), to = from)
  norms.y <- distance(from = `[<-`(to,,,0), to = to)
  thetas <- acos(dot.prods / (norms.x * norms.y))
  as.numeric(thetas)
}

## get angle with two points
angle <- function(x, y, cx, cy){
  delta_x <- x - cx
  delta_y <- y - cy
  radian  <- atan2(delta_y, delta_x);
  degree  <- radian*180/pi + 270;
  return(list(radian=radian, degree=degree));
}

## get angle by one point
angle1 <- function(x, y){
  angle <- atan(y / x) * 180 / pi;
  return(angle);
}

fig_label <- function(text, region="figure", pos="topleft", cex=NULL, ...) {

  region <- match.arg(region, c("figure", "plot", "device"))
  pos <- match.arg(pos, c("topleft", "top", "topright",
                          "left", "center", "right",
                          "bottomleft", "bottom", "bottomright","customized"))

  if(region %in% c("figure", "device")) {
    ds <- dev.size("in")
    # xy coordinates of device corners in user coordinates
    x <- grconvertX(c(0, ds[1]), from="in", to="user")
    y <- grconvertY(c(0, ds[2]), from="in", to="user")

    # fragment of the device we use to plot
    if(region == "figure") {
      # account for the fragment of the device that
      # the figure is using
      fig <- par("fig")
      dx <- (x[2] - x[1])
      dy <- (y[2] - y[1])
      x <- x[1] + dx * fig[1:2]
      y <- y[1] + dy * fig[3:4]
    }
  }

  # much simpler if in plotting region
  if(region == "plot") {
    u <- par("usr")
    x <- u[1:2]
    y <- u[3:4]
  }

  sw <- strwidth(text, cex=cex) * 60/100
  sh <- strheight(text, cex=cex) * 60/100

  x1 <- switch(pos,
               topleft     =x[1] + sw,
               left        =x[1] + sw,
               bottomleft  =x[1] + sw,
               top         =(x[1] + x[2])/2,
               center      =(x[1] + x[2])/2,
               bottom      =(x[1] + x[2])/2,
               topright    =x[2] - sw,
               right       =x[2] - sw,
               bottomright =x[2] - sw,
               customized  =(x[1] + (x[2] -x[1])/8) + sw)

  y1 <- switch(pos,
               topleft     =y[2] - sh,
               top         =y[2] - sh,
               topright    =y[2] - sh,
               left        =(y[1] + y[2])/2,
               center      =(y[1] + y[2])/2,
               right       =(y[1] + y[2])/2,
               bottomleft  =y[1] + sh,
               bottom      =y[1] + sh,
               bottomright =y[1] + sh,
               customized  =y[2] - sh)

  old.par <- par(xpd=NA)
  on.exit(par(old.par))

  text(x1, y1, text, cex=cex,font = 2, ...)
  return(invisible(c(x,y)))
}
