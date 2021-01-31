scale.v <- function(v, v.start=v.start, v.end=v.end){
  v.start + (v - min(v)) * (v.end-v.start)/(max(v) - min(v));
}
