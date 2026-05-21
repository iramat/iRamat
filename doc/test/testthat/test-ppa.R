test_that("ppa basic functionality works", {
  result <- ppa (d = NA,
                 root = "https://raw.githubusercontent.com/iramat/iRamat/master/inst/extdata/",
                 img.paths = c("clustered_distribution.png", 
                               "random_distribution.png", 
                               "regular_distribution.png"),
                 ppa_tests = c("quadrat", "ripley", "gfunction"),
                 verbose = TRUE)
  expect_s4_class(result, "hash")       
})
