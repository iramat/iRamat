#' Connect the DB API and return an R object (dataframe, etc.)
#'
#' @name db_api_connect
#' @description Connect the DB API and return an R object (dataframe, etc.)
#'
#' @param d A hash object. If none is provided, a new one will be created.
#' @param api_url An URL landing to an API. Default: 'dataset_adisser17'.
#' @param output_format The selected output format. Default "dataframe".
#' @param verbose if TRUE (by default), verbose.
#'
#' @return An R object.
#'
#' @examples
#' df <- db_api_connect()
#' # Show the first rows of the dataframe
#' head(df$dataset_adisser17)
#' 
#' @export
db_api_connect <- function(d = NA,
                           api_url = "http://157.136.252.188:3000/dataset_adisser17",
                           output_format = "dataframe",
                           verbose = TRUE){
  data.label <- unlist(strsplit(api_url, "/"))
  df.label <- data.label[length(data.label)]
  if (is.na(d)){
    if(verbose){
      print(paste0("Will store the results in a new variable"))
    }
    d <- hash::hash()
  }
  response <- httr::GET(api_url)
  # Check if the request was successful
  if (httr::status_code(response) == 200) {
    content_json <- httr::content(response, as = "text", encoding = "UTF-8")
    df <- jsonlite::fromJSON(content_json, flatten = TRUE)
  } else {
    stop("Failed to retrieve data. Status code: ", status_code(response))
  }
  d[[df.label]] <- df
  return(d)
}


