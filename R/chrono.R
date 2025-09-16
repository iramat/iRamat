#' Create a timeline of a selected dataset
#'
#' @name chrono
#' @description Read EDTF data and return a ggplot timeline
#'
#' @param d A dataframe 
#' @param seriated If TRUE (default), re-order by minimum (earliest) date.
#' @param all_dates If TRUE, show all sites, including those with no date. Default: FALSE.
#' @param verbose If TRUE (default), verbose.
#'
#' @return A ggplot graph.
#'
#' @examples
#' df <- db_api_connect()
#' # Show the dataset timeline (seriated)
#' chrono(df$dataset_adisser17)
#' 
#' # Show the dataset timeline (not seriated)
#' chrono(df$dataset_adisser17, seriated = FALSE)
#' 
#' # Show all sites (including those with no date)
#' chrono(df$dataset_adisser17, all_dates = TRUE)
#' 
#' @export
chrono <- function(d = NA,
                   seriated = TRUE,
                   all_dates = FALSE,
                   verbose = TRUE){
  `%>%` <- dplyr::`%>%` 
  
  # parse all rows (even with NA edtf)
  df_parsed <- d %>%
    dplyr::mutate(
      start_str = stringr::str_extract(edtf, "^[^/]+"),
      end_str   = stringr::str_extract(edtf, "(?<=/).+$"),
      start_num = as.integer(stringr::str_extract(start_str, "-?\\d+")),
      end_num   = as.integer(stringr::str_extract(end_str, "-?\\d+")),
      start_uncertain = stringr::str_detect(start_str, "\\?"),
      end_uncertain   = stringr::str_detect(end_str, "\\?"),
      start_approx    = stringr::str_detect(start_str, "~"),
      end_approx      = stringr::str_detect(end_str, "~"),
      dated           = !is.na(edtf)  # flag for grey labels later
    )
  
  # if not all_dates, drop undated
  if(!all_dates){
    df_parsed <- dplyr::filter(df_parsed, dated)
  }
  
  # reorder sites if seriated
  if(seriated){
    df_parsed <- df_parsed %>%
      dplyr::mutate(site_name = forcats::fct_reorder(site_name, 
                                                     dplyr::if_else(dated, start_num, Inf), 
                                                     .fun = min, 
                                                     .desc = TRUE))
  }
  unique_sitename <- length(unique(df_parsed$site_name))
  site_legend <- ifelse(seriated, "Sites (ordered by earliest date)", "Sites")
  tit <- paste0("Timeline of ", unique_sitename," sites with EDTF intervals")
  
  gg <- ggplot2::ggplot(df_parsed) +
    ggplot2::geom_segment(ggplot2::aes(
      x = start_num, xend = end_num,
      y = site_name, yend = site_name
    ), size = 1, na.rm = TRUE) +
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
      title = tit,
      subtitle = "Cross = uncertain (?), Plus = approximate (~)"
    ) +
    # Grey labels for undated sites
    ggplot2::theme(
      axis.text.y = ggplot2::element_text(
        colour = ifelse(levels(df_parsed$site_name) %in% df_parsed$site_name[df_parsed$dated], 
                        "black", "grey50")
      )
    )
  
  return(gg)
}

