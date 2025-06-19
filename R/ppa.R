#' Classify a point pattern distribution
#'
#' @name ppa
#' @description Classify a point pattern distribution from raster (images)
#'
#' @param root The path to the raster dataset.
#' @param img.paths Name of the images.
#' @param ppa_tests A list of test to perform, in a vector. By default: Quadrat Test ("quadrat"), Ripley’s K ("ripley"), G-function ("gfunction"). The vector looks like: c("quadrat", "ripley", "gfunction"). R quadrat.test() function: If p < 0.05 → the pattern is likely non-random (either clustered or regular). R Kest() (Ripley) function: ... R Gest() (G-function) function: ...
#' @param verbose if TRUE (by default), verbose.
#'
#' @return Geostatistical test results.
#'
#' @examples
#' d <- ppa()
#' # Show results of Quadrat test of the clustered distribution
#' d$clustered_distribution.png$quadrat
#' # Plot the K-Ripley of the clustered distribution
#' plot(d$clustered_distribution.png$ripley, main = "clustered distribution")
#' # Plot the G-function of the regular distribution
#' plot(d$regular_distribution.png$gfunction, main = "regular distribution")
#' 
#' @export
ppa <- function(d = NA,
                root = "https://raw.githubusercontent.com/iramat/iRamat/master/inst/extdata/",
                img.paths = c("clustered_distribution.png", 
                              "random_distribution.png", 
                              "regular_distribution.png"),
                ppa_tests = c("quadrat", "ripley", "gfunction"),
                verbose = TRUE){
  if (is.na(d)){
    if(verbose){
      print(paste0("Will store the results in a new variable"))
    }
    d <- hash::hash()
  }
  for (i in seq(1, length(img.paths))){
    # i <- 1
    im <- img.paths[i]
    if(verbose){
      print(paste0("Read image: ", im))
    }
    img.path <- paste0(root, im)
    img <- imager::load.image(img.path)
    # Convert to grayscale if needed
    img_gray <- suppressWarnings(imager::grayscale(img))
    # Threshold to binary (assuming black points on white background)
    img_bin <- img_gray < 0.5
    # Extract black pixel coordinates
    coords <- which(img_bin, arr.ind = TRUE)
    points_df <- data.frame(x = coords[, 2], y = coords[, 1])  # Swap due to matrix order
    # window <- owin(xrange = c(0, 100), yrange = c(0, 100)) # Define window (image is 100x100)
    window <- spatstat.geom::owin(xrange = c(0, ncol(img)), 
                                  yrange = c(0, nrow(img)))
    # Create point pattern object
    pp <- spatstat.geom::ppp(points_df$x, points_df$y, window = window)
    
    # Tests
    #   | Method       | Random      | Clustered | Regular   |
    #   | ------------ | ----------- | --------- | --------- |
    #   | Quadrat Test | p > 0.05    | p < 0.05  | p < 0.05  |
    #   | Ripley’s K   | Matches CSR | Above CSR | Below CSR |
    #   | G-function   | Matches CSR | Steeper   | Flatter   |
    
    if("quadrat" %in% ppa_tests){
      if(verbose){
        print(paste0("...runs Quadrat test"))
      }
      d[[im]][["quadrat"]] <- spatstat.explore::quadrat.test(pp, nx = 5, ny = 5)
    }
    if("ripley" %in% ppa_tests){
      if(verbose){
        print(paste0("...runs K-Ripley test"))
      }
      d[[im]][["ripley"]] <- spatstat.explore::Kest(pp)
    }
    if("gfunction" %in% ppa_tests){
      if(verbose){
        print(paste0("...runs G-function test"))
      }
      d[[im]][["gfunction"]] <- spatstat.explore::Gest(pp)
    }
  }
  return(d)
}