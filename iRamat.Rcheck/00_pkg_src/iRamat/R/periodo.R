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
#' @param location Optional string. If provided, only periods whose `spatial_coverage`
#'   field contains this string will be included (e.g. "France"). Default: `NA` (no filtering).
#' @param seriated Logical, if TRUE (default), reorder periods by earliest start date.
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
  if (verbose) message("Read PeriodO authority name and periods")
  read_periodo_json <- function(
    periodo_authority = "https://n2t.net/ark:/99152/p02chr4",
    cache_file = NULL
  ) {
    url <- paste0(periodo_authority, ".json")
    
    if (is.null(cache_file)) {
      cache_file <- system.file(
        "extdata",
        "periodo-authority-2chr4.json",
        package = "iRamat"
      )
    }
    
    tryCatch({
      res <- httr::GET(
        url,
        httr::timeout(300),
        httr::user_agent("Mozilla/5.0")
      )
      
      httr::stop_for_status(res)
      
      jsonlite::fromJSON(
        httr::content(res, as = "text", encoding = "UTF-8"),
        simplifyVector = FALSE
      )
    }, error = function(e) {
      message("Could not fetch live PeriodO JSON. Using local cache instead.")
      message("Original error: ", conditionMessage(e))
      
      jsonlite::fromJSON(
        cache_file,
        simplifyVector = FALSE
      )
    })
  }
  url <- paste0(periodo_authority, ".json")
  raw_periodo <- read_periodo_json(url)
  # url <- paste0(periodo_authority, ".json")
  # res <- httr::GET(
  #   url,
  #   httr::timeout(300),
  #   # httr::config(
  #   #   timeout = 300,
  #   #   connecttimeout = 120,
  #   #   ipresolve = 1,
  #   #   http_version = 2
  #   # ),
  #   httr::user_agent("Mozilla/5.0")
  # )
  # httr::stop_for_status(res)
  # raw_periodo <- jsonlite::fromJSON(
  #   httr::content(res, as = "text", encoding = "UTF-8"),
  #   simplifyVector = FALSE
  # )
  periodo_creator_names <- vapply(raw_periodo$source$creators, 
                                  function(x) x$name, character(1))
  periodo_creators_str <- paste(periodo_creator_names, 
                                collapse = ", ")
  `%||%` <- function(x, y) {
    if (is.null(x)) y else x
  }
  df_periodo <- purrr::imap_dfr(raw_periodo$periods, function(x, period_id) {
    dplyr::tibble(
      id = x$id %||% period_id,
      label = x$label %||% NA_character_,
      start = x$start$`in`$year %||% NA_character_,
      stop  = x$stop$`in`$year %||% NA_character_
    )
  }) %>%
    dplyr::mutate(
      start_num = as.integer(.data$start),
      end_num = as.integer(.data$stop),
      site_name = .data$label
    ) %>%
    dplyr::filter(
      !is.na(.data$start_num),
      !is.na(.data$end_num)
    )  
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
      dplyr::mutate(context_name = factor(label))
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
      dplyr::mutate(context_name = forcats::fct_reorder(factor(context_name), start_num, .desc = TRUE))
  }
  
  # --- 6. Plot
  unique_periods <- length(unique(df_periodo$label))
  tit_period <- paste0("Timeline of ", unique_periods, " periods")
  capt <- paste0("PeriodO authority: ", periodo_creators_str, " (", periodo_authority, ")")
  
  p_periodo <- ggplot2::ggplot(df_periodo) +
    ggplot2::geom_segment(
      ggplot2::aes(x = start_num, xend = end_num,
                   y = context_name, yend = context_name),
      linewidth = 1, color = "darkblue"
    ) +
    ggplot2::geom_text(
      ggplot2::aes(x = (start_num + end_num) / 2, y = context_name, label = label),
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
