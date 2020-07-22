

do_rotation <- function (xy, angle){
  xy <- as.matrix(xy)
  cos.angle <- cos(angle)
  sin.angle <- sin(angle)
  xy.rot <- xy %*% t(matrix(c(cos.angle, sin.angle, -sin.angle, 
                              cos.angle), 2, 2))
  return(xy.rot)
}
