#' Create a timeline of a selected dataset
#'
#' @name chrono
#' @description Read EDTF data and return a ggplot timeline
#'
#' @param d A dataframe 
#' @param seriated if TRUE (default), re-order by minimum (earliest) date.
#' @param verbose if TRUE (default), verbose.
#'
#' @return A ggplot graph.
#'
#' @examples
#' df <- db_api_connect()
#' # Show the dataset timeline (seriated)
#' chrono(df$dataset_adisser17)
#' # Show the dataset timeline (not seriated)
#' chrono(df$dataset_adisser17, seriated = FALSE)
#' 
#' @export
chrono <- function(d = NA,
                   seriated = TRUE,
                   verbose = TRUE){
  `%>%` <- dplyr::`%>%` 
  df_parsed <- d %>%
    dplyr::filter(!is.na(edtf)) %>%
    dplyr::mutate(
      start_str = stringr::str_extract(edtf, "^[^/]+"),
      end_str   = stringr::str_extract(edtf, "(?<=/).+$"),
      start_num = as.integer(stringr::str_extract(start_str, "-?\\d+")),
      end_num   = as.integer(stringr::str_extract(end_str, "-?\\d+")),
      start_uncertain = stringr::str_detect(start_str, "\\?"),
      end_uncertain   = stringr::str_detect(end_str, "\\?"),
      start_approx    = stringr::str_detect(start_str, "~"),
      end_approx      = stringr::str_detect(end_str, "~")
    ) %>%
    { if (seriated) 
      dplyr::mutate(., site_name = forcats::fct_reorder(site_name, start_num, .fun = min, .desc = TRUE))
      else . }
  site_legend <- ifelse(seriated, "Sites (ordered by earliest date)", "Sites")
  gg <- ggplot2::ggplot(df_parsed) +
    ggplot2::geom_segment(ggplot2::aes(
      x = start_num, xend = end_num,
      y = site_name, yend = site_name
    ), size = 1) +
    ggplot2::geom_point(ggplot2::aes(x = start_num, y = site_name),
                        data = dplyr::filter(df_parsed, start_uncertain),
                        shape = 4, size = 3, color = "black") +
    ggplot2::geom_point(ggplot2::aes(x = end_num, y = site_name),
                        data = dplyr::filter(df_parsed, end_uncertain),
                        shape = 4, size = 3, color = "black") +
    ggplot2::geom_point(ggplot2::aes(x = start_num, y = site_name),
                        data = dplyr::filter(df_parsed, start_approx),
                        shape = 3, size = 3, color = "black") +
    ggplot2::geom_point(ggplot2::aes(x = end_num, y = site_name),
                        data = dplyr::filter(df_parsed, end_approx),
                        shape = 3, size = 3, color = "black") +
    
    ggplot2::theme_minimal() +
    ggplot2::labs(
      x = "BCE/CE",
      y = site_legend,
      title = "Timeline of sites with EDTF intervals",
      subtitle = "Cross = uncertain (?), Plus = approximate (~)"
    )
  return(gg)
}

# df <- db_api_connect()
# chrono(d = df$dataset_adisser17, seriated = TRUE)
