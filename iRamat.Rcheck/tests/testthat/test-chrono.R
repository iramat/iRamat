test_that("chrono returns expected ggplot objects", {
  dummy_df <- data.frame(
    context_name = "SiteA",
    id_chips = 1,
    longitude = 5,
    latitude = 49,
    edtf = "-0025~/0450~",
    sample_name = "Sample",
    typology = "Ore"
  )
  
  # ---- without PeriodO ----
  g <- chrono(dummy_df, use_periodo = FALSE)
  
  expect_type(g, "list")
  expect_named(g, c("sites", "periodo"))
  expect_true(inherits(g$sites, "ggplot"))
  expect_null(g$periodo)
  
  # ---- with PeriodO ----
  g <- chrono(dummy_df, use_periodo = TRUE)
  
  expect_type(g, "list")
  expect_named(g, c("sites", "periodo"))
  expect_true(inherits(g$sites, "ggplot"))
  expect_true(inherits(g$periodo, "ggplot"))
})