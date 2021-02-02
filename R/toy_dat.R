#' @docType data

#' @usage data(toy_dat)



#' @examples
#' library('Rtsne')
#' data(toy_dat)
#' dat_dr <- Rtsne(t(toy_dat),pca = TRUE,verbose = TRUE)
#' dat_dr <- dat_dr$Y
#' rownames(dat_dr) <- colnames(toy_dat)
#' c.list <- c_list(dat_dr,20)
#' merged.list <- c.list[[1]]
#' new_data <- get_value(dat = toy_dat, d_list = merged.list)

"toy_dat"
