# ==============================================================================
# COMBINED 3x3 GRID CWT WAVELET SPECTRUM FOR SOUTHEASTERN ANATOLIA
# ==============================================================================

library(nasapower)
library(tidyverse)
library(WaveletComp)

output_dir <- "cwt_combined_outputs"
if (!dir.exists(output_dir)) dir.create(output_dir)

# 1. City Coordinates
city_coords <- tibble::tibble(
  city = c("Diyarbakir", "Gaziantep", "Sanliurfa", "Mardin", 
           "Batman", "Adiyaman", "Siirt", "Sirnak", "Kilis"),
  lat = c(37.91, 37.06, 37.16, 37.31, 37.88, 37.76, 37.93, 37.51, 36.71),
  lon = c(40.23, 37.38, 38.79, 40.73, 41.13, 38.27, 41.94, 42.45, 37.11)
)

# Target Variables
target_vars <- c("PRECTOTCORR", "T2M")

# 2. Fetch Data and Perform Wavelet Analysis for All Cities
cwt_results <- list()

for (i in seq_len(nrow(city_coords))) {
  current_city <- city_coords$city[i]
  cat(sprintf("[%d/9] Fetching & Analyzing: %s...\n", i, current_city))
  
  df_raw <- get_power(
    community = "AG",
    pars = target_vars,
    temporal_api = "MONTHLY",
    lonlat = c(city_coords$lon[i], city_coords$lat[i]),
    dates = c("1981", "2024")
  )
  
  df_clean <- df_raw %>%
    select(YEAR, PARAMETER, JAN:DEC) %>%
    pivot_longer(cols = JAN:DEC, names_to = "MONTH", values_to = "VALUE") %>%
    pivot_wider(names_from = PARAMETER, values_from = VALUE) %>%
    mutate(
      month_num = match(MONTH, c("JAN", "FEB", "MAR", "APR", "MAY", "JUN", 
                                 "JUL", "AUG", "SEP", "OCT", "NOV", "DEC")),
      date = as.Date(paste(YEAR, month_num, "01", sep = "-")),
      PRECTOTCORR = as.numeric(PRECTOTCORR),
      T2M = as.numeric(T2M)
    ) %>%
    filter(PRECTOTCORR >= 0 & T2M > -90) %>%
    drop_na(PRECTOTCORR, T2M) %>%
    arrange(date) %>%
    as.data.frame()
  
  # Perform CWT for Precipitation and Temperature
  cwt_precip <- analyze.wavelet(
    df_clean, my.series = "PRECTOTCORR", loess.span = 0,
    dt = 1/12, dj = 1/250, lowerPeriod = 1/4, upperPeriod = 16,
    make.pval = TRUE, n.sim = 100
  )
  
  cwt_temp <- analyze.wavelet(
    df_clean, my.series = "T2M", loess.span = 0,
    dt = 1/12, dj = 1/250, lowerPeriod = 1/4, upperPeriod = 16,
    make.pval = TRUE, n.sim = 100
  )
  
  cwt_results[[current_city]] <- list(precip = cwt_precip, temp = cwt_temp)
}

# 3. Generate Single 3x3 Combined Grid Image for Precipitation
jpeg(file.path(output_dir, "Combined_Wavelet_Precipitation_3x3.jpg"), 
     width = 2400, height = 1800, res = 200)

par(mfrow = c(3, 3), mar = c(4, 4, 3, 1))

for (city_name in city_coords$city) {
  wt.image(
    cwt_results[[city_name]]$precip,
    main = paste("Precipitation -", city_name),
    periodlab = "Period (Yrs)",
    timelab = "Time",
    legend.params = list(lab = "Power"),
    graphics.reset = FALSE
  )
}

dev.off()

# 4. Generate Single 3x3 Combined Grid Image for Temperature
jpeg(file.path(output_dir, "Combined_Wavelet_Temperature_3x3.jpg"), 
     width = 2400, height = 1800, res = 200)

par(mfrow = c(3, 3), mar = c(4, 4, 3, 1))

for (city_name in city_coords$city) {
  wt.image(
    cwt_results[[city_name]]$temp,
    main = paste("Temperature -", city_name),
    periodlab = "Period (Yrs)",
    timelab = "Time",
    legend.params = list(lab = "Power"),
    graphics.reset = FALSE
  )
}

dev.off()

cat("\nCompleted! Check 'cwt_combined_outputs' for 3x3 combined grid images.\n")