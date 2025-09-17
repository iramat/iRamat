test_that("chrono returns a ggplot object", {
  dummy_df <- data.frame(
    site_name = c("SiteA"),
    id_chips = 1,
    longitude = 5,
    latitude = 49,
    edtf = "-0025~/0450~",
    sample_name = "Sample",
    typology = "Ore"
  )
  g <- chrono(dummy_df, seriated = TRUE)
  expect_s3_class(g, "ggplot")  # should produce a ggplot object
})
