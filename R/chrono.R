#' Create a timeline of a selected dataset
#'
#' @name chrono
#' @description Read EDTF data and return a ggplot timeline
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
#' # Show the dataset timeline
#' chrono(df$dataset_adisser17)
#' 
#' @export
chrono <- function(d = NA,
                   verbose = TRUE){
  library(dplyr)
  library(stringr)
  library(ggplot2)
  library(forcats)
  
  df_parsed <- df$dataset_adisser17 %>%
    filter(!is.na(edtf)) %>%
    mutate(
      start_str = str_extract(edtf, "^[^/]+"),
      end_str   = str_extract(edtf, "(?<=/).+$"),
      
      start_num = as.integer(str_extract(start_str, "-?\\d+")),
      end_num   = as.integer(str_extract(end_str, "-?\\d+")),
      
      start_uncertain = str_detect(start_str, "\\?"),
      end_uncertain   = str_detect(end_str, "\\?"),
      start_approx    = str_detect(start_str, "~"),
      end_approx      = str_detect(end_str, "~")
    ) %>%
    # re-order site_name by minimum (earliest) date
    mutate(site_name = fct_reorder(site_name, start_num, .fun = min, .desc = TRUE))
  
  gg <- ggplot(df_parsed) +
    geom_segment(aes(
      x = start_num, xend = end_num,
      y = site_name, yend = site_name
    ), size = 1) +
    
    geom_point(aes(x = start_num, y = site_name),
               data = filter(df_parsed, start_uncertain),
               shape = 4, size = 3, color = "black") +
    geom_point(aes(x = end_num, y = site_name),
               data = filter(df_parsed, end_uncertain),
               shape = 4, size = 3, color = "black") +
    
    geom_point(aes(x = start_num, y = site_name),
               data = filter(df_parsed, start_approx),
               shape = 3, size = 3, color = "black") +
    geom_point(aes(x = end_num, y = site_name),
               data = filter(df_parsed, end_approx),
               shape = 3, size = 3, color = "black") +
    
    theme_minimal() +
    labs(
      x = "Year",
      y = "Site (ordered by earliest date)",
      title = "Timeline of sites with EDTF intervals",
      subtitle = "Cross = uncertain (?), Plus = approximate (~)"
    )
  return(gg)
}

df <- db_api_connect()
chrono(df$dataset_adisser17)
