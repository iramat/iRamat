#' Create a timeline of periods from a PeriodO authority
#'
#' This function reads a PeriodO authority file (CSV + JSON metadata) and
#' returns a ggplot2 timeline of the defined periods. Optionally, the timeline
#' can be restricted to a given temporal range, and periods can be filtered by
#' the amount of overlap with that range.
#'
#' @param periodo_authority A string. URL of a PeriodO authority
#'   (default: "https://n2t.net/ark:/99152/p02chr4", INRAP).
#' @param use_periodo Logical, if TRUE, the function is used as a subroutine
#'   (typically called from [chrono()]) and the plot title is suppressed.
#' @param min_date Optional numeric. Lower bound of the time interval (most ancient date).
#'   Default: `NA` (no lower bound).
#' @param max_date Optional numeric. Upper bound of the time interval (most recent date).
#'   Default: `NA` (no upper bound).
#' @param time_match Numeric between 0 and 1. Minimum proportion of temporal overlap
#'   required between a period and the given [min_date, max_date] interval
#'   for the period to be included. Default: `NA` (no filtering).
#' @param seriated Logical, if TRUE (default), reorder periods by earliest start date.
#' @param location Controlled value, default NA. Will subset the periods based on a location (e.g. France).
#' @param verbose Logical, if TRUE (default), print progress messages.
#'
#' @return A list with one ggplot2 object:
#'   \describe{
#'     \item{periodo}{A timeline of PeriodO periods.}
#'   }
#'
#' @examples
#' \dontrun{
#' # Default authority (INRAP)
#' periodo()
#'
#' # Restrict to a specific interval and require exact overlap
#' periodo(min_date = -700, max_date = 0, use_periodo = TRUE, time_match = 1)
#' 
#' # Authority ArkeOpen, France only
#' periodo(periodo_authority = "http://n2t.net/ark:/99152/p09hq4n", min_date = -500, max_date = 500, use_periodo = TRUE, time_match = 1, location = "France")
#' }
#'
#' @import dplyr ggplot2 forcats readr jsonlite
#' @export
periodo <- function(periodo_authority = "https://n2t.net/ark:/99152/p02chr4",
                    use_periodo = FALSE,
                    min_date = NA,
                    max_date = NA,
                    time_match = NA,
                    location = NA,
                    seriated = TRUE,
                    verbose = TRUE) {
  
  # --- 1. Read metadata
  if (verbose) message("Read PeriodO authority name")
  raw_periodo <- jsonlite::fromJSON(paste0(periodo_authority, ".json"), simplifyVector = FALSE)
  periodo_creator_names <- vapply(raw_periodo$source$creators, function(x) x$name, character(1))
  periodo_creators_str <- paste(periodo_creator_names, collapse = ", ")
  
  # --- 2. Read periods
  if (verbose) message("Read PeriodO periods")
  periods <- readr::read_csv(paste0(periodo_authority, ".csv"), show_col_types = FALSE)
  
  df_periodo <- periods %>%
    dplyr::mutate(
      start_num = as.integer(start),
      end_num   = as.integer(stop),
      site_name = label
    ) %>%
    dplyr::filter(!is.na(start_num), !is.na(end_num))
  
  # --- 3. Optional filtering by overlap
  if (!is.na(min_date) && !is.na(max_date) && !is.na(time_match)) {
    if (verbose) message("Dataset range PeriodO: ", min_date, " to ", max_date)
    df_periodo <- df_periodo %>%
      dplyr::rowwise() %>%
      dplyr::mutate(
        overlap_start = max(start_num, min_date),
        overlap_stop  = min(end_num, max_date),
        overlap_len   = max(0, overlap_stop - overlap_start),
        period_len    = end_num - start_num,
        inside_ratio  = ifelse(period_len > 0, overlap_len / period_len, 0)
      ) %>%
      dplyr::ungroup() %>%
      dplyr::filter(overlap_len > 0, inside_ratio >= time_match) %>%
      dplyr::mutate(site_name = factor(label))
  }
  
  # --- 4. Optionally filter on spatial_coverage
  if(!is.na(location)) {
    if (verbose) message("Dataset location PeriodO: ", location)
    df_periodo <- subset(df_periodo, grepl(location, spatial_coverage))
    df_periodo <- as.data.frame(df_periodo)
  }
  
  # --- 5. Optionally reorder
  if (seriated) {
    df_periodo <- df_periodo %>%
      dplyr::mutate(site_name = forcats::fct_reorder(site_name, start_num, .desc = TRUE))
  }
  
  # --- 6. Plot
  unique_periods <- length(unique(df_periodo$label))
  tit_period <- paste0("Timeline of ", unique_periods, " periods")
  capt <- paste0("PeriodO authority: ", periodo_creators_str, " (", periodo_authority, ")")
  
  p_periodo <- ggplot2::ggplot(df_periodo) +
    ggplot2::geom_segment(
      ggplot2::aes(x = start_num, xend = end_num,
                   y = site_name, yend = site_name),
      linewidth = 1, color = "darkblue"
    ) +
    ggplot2::geom_text(
      ggplot2::aes(x = (start_num + end_num) / 2, y = site_name, label = label),
      color = "darkblue", size = 3, vjust = -0.5
    ) +
    ggplot2::scale_x_continuous(
      limits = if (!is.na(min_date) & !is.na(max_date)) c(min_date, max_date) else NULL,
      expand = c(0, 0)
    ) +
    ggplot2::theme_minimal() +
    ggplot2::labs(
      x = "BCE/CE",
      y = "PeriodO",
      title = if (use_periodo) NULL else tit_period,
      caption = capt
    )
  
  return(p_periodo)
}

# gg <- periodo(periodo_authority = "http://n2t.net/ark:/99152/p09hq4n", min_date = -500, max_date = 500, use_periodo = TRUE, time_match = 1, location = "France")
# ggplot2::ggsave(gg, filename = "C:/Users/TH282424/Rprojects/iRamat/doc/periodo_periods_seriated_2.png", height = 10, width = 10)
