## rotate coordinate by two points or angle
r_c <- function (dat, radian=NULL, degree=NULL, twopoints=NULL){
  dat <- as.matrix(dat)
  if (length(radian) > 0 & is.numeric(radian)){
  } else if (length(degree) > 0 & is.numeric(degree)){
    radian <- degree * pi / 180;
  } else if (length(twopoints)==4) {
    x1    <- twopoints[1];
    y1    <- twopoints[2];
    x2    <- twopoints[3];
    y2    <- twopoints[4];
    radian <- atan2(y2 - y1, x2 - x1) * 180 / pi;
  } else if (length(twopoints)==2){
    x1    <- dat[twopoints[1], 1];
    y1    <- dat[twopoints[1], 2];
    x2    <- dat[twopoints[2], 1];
    y2    <- dat[twopoints[2], 2];
    radian <- atan2(y2 - y1, x2 - x1) * 180 / pi;
  } else {
    stop("radian is NULL or degree is NULL or twopoints is NULL or ....\n")
  }

  cos.radian <- cos(radian)
  sin.radian <- sin(radian)
  dat.rot    <- dat %*% t(matrix(c(cos.radian, sin.radian, -sin.radian, 
                              cos.radian), 2, 2))
  return(dat.rot)
}




