test_that("db_api_connect returns a dataframe", {
  # skip("Needs live DB connection") # optional, if you can’t connect in CI
  df <- db_api_connect()
  expect_s4_class(df, "hash")
})
