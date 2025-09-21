#' Create a timeline of a selected dataset
#'
#' This function parses EDTF-formatted dates from a dataset and returns one or two
#' ggplot2 timelines: a site-based timeline and, optionally, a PeriodO timeline
#' for comparison.
#'
#' @param d A data frame containing at least a column `edtf` with EDTF dates
#'   and a column `site_name`.
#' @param use_periodo Logical, if TRUE (default FALSE), also fetch and plot periods
#'   from a PeriodO authority.
#' @param periodo_authority A string. URL of a PeriodO authority
#'   (default: "https://n2t.net/ark:/99152/p02chr4").
#' @param seriated Logical, if TRUE (default), reorder sites/periods by earliest start date.
#' @param all_dates Logical, if TRUE, include sites with missing/NA dates (default: FALSE).
#' @param time_match Numeric between 0 and 1. Minimum proportion of temporal overlap
#'   required between dataset range and a period to include the period (default: 0.9).
#' @param verbose Logical, if TRUE (default), print progress messages.
#'
#' @return A list of ggplot2 objects with elements:
#'   \describe{
#'     \item{sites}{A timeline of dataset sites (always returned).}
#'     \item{periodo}{A PeriodO timeline, if `use_periodo = TRUE`, otherwise NULL.}
#'   }
#'
#' @examples
#' \dontrun{
#' df <- db_api_connect()
#' plots <- chrono(df$dataset_adisser17, use_periodo = TRUE)
#' ggpubr::ggarrange(plots$sites, plots$periodo, heights = c(1,2), ncol = 1, align = "v")
#' }
#'
#' @import dplyr ggplot2 stringr forcats readr
#' @export
chrono <- function(d,
                   use_periodo = FALSE,
                   periodo_authority = "https://n2t.net/ark:/99152/p02chr4",
                   seriated = TRUE,
                   all_dates = FALSE,
                   time_match = 0.9,
                   verbose = TRUE) {
  
  # --- 1. Parse dataset
  df_sites <- d %>%
    dplyr::mutate(
      start_str = stringr::str_extract(edtf, "^[^/]+"),
      end_str   = stringr::str_extract(edtf, "(?<=/).+$"),
      start_num = as.integer(stringr::str_extract(start_str, "-?\\d+")),
      end_num   = as.integer(stringr::str_extract(end_str, "-?\\d+")),
      start_uncertain = stringr::str_detect(start_str, "\\?"),
      end_uncertain   = stringr::str_detect(end_str, "\\?"),
      start_approx    = stringr::str_detect(start_str, "~"),
      end_approx      = stringr::str_detect(end_str, "~"),
      dated           = !is.na(edtf),
      type = dplyr::case_when(
        start_uncertain | end_uncertain ~ "uncertain",
        start_approx | end_approx       ~ "approximate",
        TRUE                            ~ "exact"
      )
    )
  
  if (!all_dates) {
    df_sites <- dplyr::filter(df_sites, dated)
  }
  
  if (seriated) {
    df_sites <- df_sites %>%
      dplyr::mutate(site_name = forcats::fct_reorder(
        site_name,
        dplyr::if_else(dated, start_num, Inf),
        .fun = min, .desc = TRUE
      ))
  } else {
    df_sites <- df_sites %>%
      dplyr::mutate(site_name = factor(site_name))
  }
  
  min_date <- min(df_sites$start_num, na.rm = TRUE)
  max_date <- max(df_sites$end_num, na.rm = TRUE)
  if (verbose) message("Dataset range sites: ", min_date, " to ", max_date)
  
  unique_sitename <- length(unique(df_sites$site_name))
  tit <- paste0("Timeline of ", unique_sitename, " sites with EDTF intervals")
  
  # --- 2. Optionally build PeriodO plot
  p_periodo <- NULL
  if (use_periodo) {
    p_periodo <- periodo(
      periodo_authority = periodo_authority,
      use_periodo = TRUE,
      min_date = min_date,
      max_date = max_date,
      seriated = seriated,
      time_match = time_match,
      verbose = verbose
    )
  }
  
  # --- 3. Build site plot
  p_sites <- ggplot2::ggplot(df_sites) +
    ggplot2::geom_segment(
      ggplot2::aes(x = start_num, xend = end_num,
                   y = site_name, yend = site_name, linetype = type),
      linewidth = 1, color = "gray30", na.rm = TRUE
    ) +
    ggplot2::geom_point(
      ggplot2::aes(x = start_num, y = site_name, shape = type),
      size = 3, color = "black", na.rm = TRUE
    ) +
    ggplot2::geom_point(
      ggplot2::aes(x = end_num, y = site_name, shape = type),
      size = 3, color = "black", na.rm = TRUE
    ) +
    ggplot2::scale_linetype_manual(values = c(
      exact = "solid",
      uncertain = "dashed",
      approximate = "solid"
    )) +
    ggplot2::scale_shape_manual(values = c(
      exact       = 16,
      uncertain   = 1,
      approximate = 15
    )) +
    ggplot2::scale_x_continuous(limits = c(min_date, max_date), expand = c(0, 0)) +
    ggplot2::theme_minimal() +
    ggplot2::labs(
      x = if (use_periodo) NULL else "BCE/CE",
      y = "Sites",
      title = tit
    ) +
    ggplot2::theme(
      axis.text.y = ggplot2::element_text(
        colour = ifelse(levels(df_sites$site_name) %in% df_sites$site_name[df_sites$dated],
                        "black", "grey50")
      )
    )
  
  # --- 4. Return both plots
  return(list(sites = p_sites, periodo = p_periodo))
}
