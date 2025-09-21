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
#' 
#' # Download the dataset
#' df <- db_api_connect()
#' 
#' # Show the dataset timeline (seriated)
#' chrono(df$dataset_adisser17)
#' 
#' # Show the dataset timeline (not seriated)
#' chrono(df$dataset_adisser17, seriated = FALSE)
#' 
#' # Show all sites (including those with no date)
#' chrono(df$dataset_adisser17, all_dates = TRUE)
#' 
#' # Compute the related periodo chronology plot
#' plots <- chrono(df$dataset_adisser17, use_periodo = TRUE)
#' 
#' @export
library(dplyr)
library(ggplot2)
library(stringr)
library(forcats)
library(readr)

chrono <- function(d,
                   use_periodo = FALSE,
                   periodo_authority = "https://n2t.net/ark:/99152/p02chr4",
                   seriated = TRUE,
                   all_dates = FALSE,
                   time_match = 0.9,
                   verbose = TRUE) {
  `%>%` <- dplyr::`%>%`
  
  # --- 1. Parse dataset
  df_sites <- d %>%
    mutate(
      start_str = str_extract(edtf, "^[^/]+"),
      end_str   = str_extract(edtf, "(?<=/).+$"),
      start_num = as.integer(str_extract(start_str, "-?\\d+")),
      end_num   = as.integer(str_extract(end_str, "-?\\d+")),
      start_uncertain = str_detect(start_str, "\\?"),
      end_uncertain   = str_detect(end_str, "\\?"),
      start_approx    = str_detect(start_str, "~"),
      end_approx      = str_detect(end_str, "~"),
      dated           = !is.na(edtf),
      type = case_when(
        start_uncertain | end_uncertain ~ "uncertain",
        start_approx | end_approx       ~ "approximate",
        TRUE                            ~ "exact"
      )
    )
  
  if (!all_dates) {
    df_sites <- filter(df_sites, dated)
  }
  
  if (seriated) {
    df_sites <- df_sites %>%
      mutate(site_name = fct_reorder(
        site_name,
        if_else(dated, start_num, Inf),
        .fun = min, .desc = TRUE
      ))
  } else {
    df_sites <- df_sites %>%
      mutate(site_name = factor(site_name))
  }
  
  min_date <- min(df_sites$start_num, na.rm = TRUE)
  max_date <- max(df_sites$end_num, na.rm = TRUE)
  if (verbose) message("Dataset range: ", min_date, " to ", max_date)
  
  
  unique_sitename <- length(unique(df_sites$site_name))
  site_legend <- ifelse(seriated, "Sites", "Sites")
  tit <- paste0("Timeline of ", unique_sitename," sites with EDTF intervals")
  
  if(use_periodo){
    # --- 2. Read PeriodO CSV
    source("R/periodo.R")
    p_periodo <- periodo(periodo_authority = periodo_authority,
                         use_periodo = use_periodo,
                         min_date = min_date,
                         max_date = max_date,
                         seriated = seriated,
                         time_match = time_match)
    #   periods <- read_csv(periodo_authority, show_col_types = FALSE)
    #   
    #   df_periodo <- periods %>%
    #     mutate(
    #       start_num = as.integer(start),
    #       end_num   = as.integer(stop)
    #     ) %>%
    #     filter(!is.na(start_num), !is.na(end_num))
    #   
    #   # --- 3. Filter by overlap with dataset range
    #   df_periodo <- df_periodo %>%
    #     rowwise() %>%
    #     mutate(
    #       overlap_start = max(start_num, min_date),
    #       overlap_stop  = min(end_num, max_date),
    #       overlap_len   = max(0, overlap_stop - overlap_start),
    #       period_len    = end_num - start_num,
    #       inside_ratio  = ifelse(period_len > 0, overlap_len / period_len, 0)
    #     ) %>%
    #     ungroup() %>%
    #     filter(overlap_len > 0, inside_ratio >= time_match) %>%
    #     mutate(site_name = factor(label))
    #   
    #   if (seriated) {
    #     df_periodo <- df_periodo %>%
    #       mutate(site_name = fct_reorder(site_name, start_num, .desc = TRUE))
    #   }
    #   
    #   unique_periods <- length(unique(df_periodo$label))
    #   period_legend <- ifelse(seriated, "Periods (ordered by earliest date)", "Periods")
    #   tit_period <- paste0("Timeline of ", unique_periods," periods")
    #   
    #   # --- 5. Plot PeriodO periods
    #   p_periodo <- ggplot(df_periodo) +
    #     geom_segment(
    #       aes(x = start_num, xend = end_num,
    #           y = site_name, yend = site_name),
    #       linewidth = 1, color = "darkblue"
    #     ) +
    #     geom_text(
    #       aes(x = (start_num + end_num)/2, y = site_name, label = label),
    #       color = "darkblue", size = 3, vjust = -0.5
    #     ) +
    #     theme_minimal() +
    #     labs(
    #       x = "BCE/CE",
    #       y = "PeriodO",
    #       title = "Timeline of PeriodO periods"
    #     ) 
    # }
    
    # --- 4. Plot sites
    p_sites <- ggplot(df_sites) +
      geom_segment(
        aes(x = start_num, xend = end_num,
            y = site_name, yend = site_name, linetype = type),
        linewidth = 1, color = "gray30", na.rm = TRUE
      ) +
      geom_point(
        aes(x = start_num, y = site_name, shape = type),
        size = 3, color = "black", na.rm = TRUE
      ) +
      geom_point(
        aes(x = end_num, y = site_name, shape = type),
        size = 3, color = "black", na.rm = TRUE
      ) +
      scale_linetype_manual(values = c(
        exact = "solid",
        uncertain = "dashed",
        approximate = "solid"
      )) +
      scale_shape_manual(values = c(
        exact       = 16,
        uncertain   = 1,
        approximate = 15
      )) +
      theme_minimal() +
      labs(
        x = if (use_periodo) NULL else "BCE/CE",
        y = site_legend,
        title = tit
      ) +
      # Grey labels for undated sites
      ggplot2::theme(
        axis.text.y = ggplot2::element_text(
          colour = ifelse(levels(df_sites$site_name) %in% 
                            df_sites$site_name[df_sites$dated], 
                          "black", "grey50")
        )
      )
    
    
    
    # --- 6. Return both plots
    if(use_periodo){
      return(list(sites = p_sites, periodo = p_periodo))
    } else {
      return(list(sites = p_sites))
    }
  }
}

plots <- chrono(df$dataset_adisser17, use_periodo = TRUE)

# Display sites timeline
# plots$sites

# Display PeriodO timeline
# plots$periodo

ggpubr::ggarrange(plots$sites, plots$periodo, heights = c(1,2), ncol = 1, align = "v")
