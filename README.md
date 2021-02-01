scCorr: R package for single cell association or correlation analysis
=====================================================================

### 1.Installaling

    library('devtools')
    install_github("CBIIT-CGBB/scCorr",auth_token = 'cbd6dad89a1f8c12c8cb54bfca9c3027796835ea')

### 2. Basic Usage

    library('scCorr')

#### Load the toy data

    data(toy_dat)
    head(toy_dat[,1:4],)

    ##                 X159.TAGGCATTCACATGCA.1 X180.CGGAGCTGTAGAAAGG.1
    ## ENSG00000000003               0.5662308                       0
    ## ENSG00000000005               0.0000000                       0
    ## ENSG00000000419               0.0000000                       0
    ## ENSG00000000457               0.0000000                       0
    ## ENSG00000000460               0.0000000                       0
    ## ENSG00000000938               0.0000000                       0
    ##                 X159.GCCTCTAGTCCAGTGC.1 X180.CTGTGCTAGCTGTCTA.1
    ## ENSG00000000003                       0               0.6849492
    ## ENSG00000000005                       0               0.0000000
    ## ENSG00000000419                       0               0.0000000
    ## ENSG00000000457                       0               0.0000000
    ## ENSG00000000460                       0               0.0000000
    ## ENSG00000000938                       0               0.0000000

#### Using scCorr to compute the correlation of “ENSG00000000003” and “ENSG00000000005”

#### 2.1 Apply dimension reduction methods (usually t-SNE or U-map)

    #install.packages(Rtsne)
    library(Rtsne)
    dat_dr <- Rtsne(t(toy_dat),pca = TRUE,verbose = FALSE)$Y
    rownames(dat_dr) <- colnames(toy_dat)

#### 2.2 Apply scCorr cluter methods to reconstruct our data

    # Using cluster method with default cluster numbers
    c.list <- c_list(dat_dr)

    ## make graph ...
    ## make graph clustering with k ...
    ## graph clustering was done.
    ## re-make graph clustering ...
    ## re-make graph clustering ...
    ## re-make graph clustering ...
    ## re-make graph clustering ...
    ## re-make graph clustering ...
    ## re-make graph clustering ...
    ## re-make graph clustering ...
    ## re-make graph clustering ...
    ## re-make graph clustering ...
    ## re-make graph clustering ...
    ## re-make graph clustering ...

    merged.list <- c.list[[1]]

    new_data <- get_value(dat = toy_dat, d_list = merged.list)
    head(new_data[,1:4],)

    ##                      [,1]     [,2]      [,3] [,4]
    ## ENSG00000000003 0.5662308 0.164252 0.0000000    0
    ## ENSG00000000005 0.0000000 0.000000 0.0000000    0
    ## ENSG00000000419 0.0000000 0.000000 0.0560539    0
    ## ENSG00000000457 0.0000000 0.000000 0.0000000    0
    ## ENSG00000000460 0.0000000 0.000000 0.0000000    0
    ## ENSG00000000938 0.0000000 0.000000 0.0000000    0

#### 2.3 Compute the correlation
