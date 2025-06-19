#' Classify a point pattern distribution
#'
#' @name ppa
#' @description Classify a point pattern distribution from raster (images)
#'
#' @param root The path to the raster dataset.
#' @param img.paths Name of the images.
#' @param ppa_tests A list of test to perform, in a vector. By default: Quadrat Test ("quadrat"), Ripley’s K ("ripley"), G-function ("gfunction"). The vector looks like: c("quadrat", "ripley", "gfunction")
#' @param verbose if TRUE (by default), verbose.
#'
#' @return Geostatistical test results.
#'
#' @examples
#'
#' Kfar_Hahoresh.crane_afg_nd_pl_polygon.wkt <- conv_geojson_to_wkt()
#'
#'

# Install if necessary
# install.packages("imager")

# library(imager)
# library(spatstat.geom)
# library(spatstat)

# Load image

ppa <- function(root = "https://raw.githubusercontent.com/iramat/iRamat/master/inst/extdata/",
                img.paths = c("clustered_distribution.png", 
                              "random_distribution.png", 
                              "regular_distribution.png"),
                ppa_tests = c("quadrat", "ripley", "gfunction"),
                verbose = TRUE){
  for (i in seq(1, length(img.paths))){
    # i <- 3
    print(paste0("Read: ", img.paths[i]))
    img.path <- paste0(root, img.paths[i])
    img <- load.image(img.path)
    # Convert to grayscale if needed
    img_gray <- grayscale(img)
    # Threshold to binary (assuming black points on white background)
    img_bin <- img_gray < 0.5
    # Extract black pixel coordinates
    coords <- which(img_bin, arr.ind = TRUE)
    points_df <- data.frame(x = coords[, 2], y = coords[, 1])  # Swap due to matrix order
    # Define window (image is 100x100)
    window <- owin(xrange = c(0, 100), yrange = c(0, 100))
    # Create point pattern object
    pp <- ppp(points_df$x, points_df$y, window = window)
    
    # Tests
    quadrat.test(pp, nx = 5, ny = 5) # If p < 0.05 → the pattern is likely non-random (either clustered or regular).
    #
    K <- Kest(pp)
    plot(K)
    #
    G <- Gest(pp)
    plot(G)
  }
}

#   | Method       | Random      | Clustered | Regular   |
#   | ------------ | ----------- | --------- | --------- |
#   | Quadrat Test | p > 0.05    | p < 0.05  | p < 0.05  |
#   | Ripley’s K   | Matches CSR | Above CSR | Below CSR |
#   | G-function   | Matches CSR | Steeper   | Flatter   |


