#' Connect the CHIPS DB API and return an R object (dataframe, etc)
#'
#' @name db_api_connect
#' @description Connect the CHIPS DB API and return an R object (dataframe, etc.).
#'   The default dataset is dataset_adisser17, accessed at
#'   <http://157.136.252.188:3000/dataset_adisser17>.
#'
#'   If \code{all_datasets = TRUE}, all datasets whose \code{description} is
#'   "Dataset" in the GitHub-hosted table
#'   \url{https://github.com/iramat/iramat-dev/blob/main/dbs/chips/urls_data.tsv}
#'   are downloaded (using their \code{url_data} column), merged into a single
#'   \code{data.frame}, and a new column \code{dataset_name} is added to indicate
#'   the source dataset for each row.
#'
#' @param d A hash object. If none is provided, a new one will be created.
#'   Ignored when \code{all_datasets = TRUE}.
#' @param api_url An URL landing to an API. Default:
#'   \code{"http://157.136.252.188:3000/dataset_adisser17"}.
#'   Ignored when \code{all_datasets = TRUE}.
#' @param api_list An URL landing to a TSV file listing API URLs. Default:
#'   \code{"https://raw.githubusercontent.com/iramat/chips/hugo-files/static/data/urls_data.tsv"}.
#'   Ignored when \code{all_datasets = FALSE}.
#' @param output_format The selected output format. Default "dataframe"
#'   (currently not used).
#' @param verbose if TRUE (by default), verbose.
#' @param all_datasets Logical. If \code{TRUE}, download all datasets with
#'   \code{description == "Dataset"} listed in the GitHub table
#'   \url{https://github.com/iramat/iramat-dev/blob/main/dbs/chips/urls_data.tsv},
#'   merge them into a single \code{data.frame}, and add a column
#'   \code{dataset_name} with the name of the source dataset (last component
#'   of the API URL). Default \code{FALSE}.
#'
#' @return
#'   * If \code{all_datasets = FALSE} (default): a hash where each key is the
#'     dataset label (last part of \code{api_url}) and each value is a dataframe.
#'   * If \code{all_datasets = TRUE}: a single merged \code{data.frame} with an
#'     additional column \code{dataset_name}.
#'
#' @examples
#' # Default behaviour: one dataset stored in a hash
#' df_hash <- db_api_connect()
#' head(df_hash$dataset_adisser17)
#'
#' # All CHIPS datasets listed in urls_data.tsv, merged into a single dataframe
#' df_all <- db_api_connect(all_datasets = TRUE)
#' head(df_all)
#'
#' @export
db_api_connect <- function(d = NA,
                           api_url = "http://157.136.252.188:3000/dataset_adisser17",
                           api_list = "https://raw.githubusercontent.com/iramat/chips/hugo-files/static/data/urls_data.tsv",
                           output_format = "dataframe",
                           verbose = TRUE,
                           all_datasets = FALSE){
  
  # Helper to fetch a single API URL into a data.frame
  fetch_single_api <- function(api_url, verbose = TRUE) {
    if (verbose) {
      message("Requesting: ", api_url)
    }
    response <- httr::GET(api_url)
    
    # Check if the request was successful
    if (httr::status_code(response) == 200) {
      content_json <- httr::content(response, as = "text", encoding = "UTF-8")
      df <- jsonlite::fromJSON(content_json, flatten = TRUE)
      df <- as.data.frame(df)
    } else {
      stop("Failed to retrieve data from ", api_url,
           ". Status code: ", httr::status_code(response))
    }
  }
  
  if (isTRUE(all_datasets)) {
    if (verbose) {
      message("all_datasets = TRUE: collecting all datasets from urls_data.tsv")
    }
    
    # Raw URL for the TSV file on GitHub
    
    urls_df <- utils::read.table(
      api_list,
      header = TRUE,
      sep = "\t",
      stringsAsFactors = FALSE,
      check.names = FALSE
    )
    
    # Keep only rows with description == "Dataset"
    urls_df <- urls_df[urls_df$description == "Dataset" &
                         !is.na(urls_df$url_data) &
                         nzchar(urls_df$url_data), ]
    
    if (nrow(urls_df) == 0) {
      stop("No dataset URLs found in urls_data.tsv with description == 'Dataset'.")
    }
    
    # Fetch all datasets and add dataset_name column
    list_dfs <- lapply(seq_len(nrow(urls_df)), function(i) {
      api_i <- urls_df$url_data[i]
      df_i  <- fetch_single_api(api_i, verbose = verbose)
      
      # Use last part of URL as dataset name
      dataset_label <- basename(api_i)
      df_i$dataset_name <- dataset_label
      
      df_i
    })
    
    # Harmonise columns across data.frames (fill missing with NA) before rbind
    all_cols <- unique(unlist(lapply(list_dfs, names)))
    list_dfs <- lapply(list_dfs, function(x) {
      missing_cols <- setdiff(all_cols, names(x))
      if (length(missing_cols) > 0) {
        x[missing_cols] <- NA
      }
      x[, all_cols, drop = FALSE]
    })
    
    merged_df <- do.call(rbind, list_dfs)
    
    if (verbose) {
      message("Collected and merged ", nrow(urls_df),
              " datasets. Total rows: ", nrow(merged_df))
    }
    
    return(merged_df)
  }
  
  data.label <- unlist(strsplit(api_url, "/"))
  df.label   <- data.label[length(data.label)]
  
  if (is.na(d)[1]) {
    if (verbose) {
      message("Will store the results in a new variable (hash).")
    }
    d <- hash::hash()
  }
  
  df <- fetch_single_api(api_url, verbose = verbose)
  d[[df.label]] <- df
  
  return(d)
}
