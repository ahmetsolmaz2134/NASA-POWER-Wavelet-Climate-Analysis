# ------------------------------------------------------------------
# SOUTHEAST ANATOLIA - NASA POWER WAVELET ANALYSIS (FULLY FIXED)
# ------------------------------------------------------------------

library(nasapower)
library(tidyverse)
library(WaveletComp)

output_dir <- "wavelet_outputs"
if(!dir.exists(output_dir)) dir.create(output_dir)

city_coords <- tibble::tibble(
  city = c("Diyarbakir", "Gaziantep", "Sanliurfa", "Mardin", 
           "Batman", "Adiyaman", "Siirt", "Sirnak", "Kilis"),
  lat = c(37.91, 37.06, 37.16, 37.31, 37.88, 37.76, 37.93, 37.51, 36.71),
  lon = c(40.23, 37.38, 38.79, 40.73, 41.13, 38.27, 41.94, 42.45, 37.11)
)

for (i in seq_len(nrow(city_coords))) {
  current_city <- city_coords$city[i]
  cat("\n--------------------------------------------------\n")
  cat(paste0("[", i, "/", nrow(city_coords), "] Processing: ", current_city, "...\n"))
  
  # A. Fetch Monthly Data (1981 - 2024)
  df_power <- get_power(
    community = "AG",
    pars = c("T2M", "PRECTOTCORR"),
    temporal_api = "MONTHLY",
    lonlat = c(city_coords$lon[i], city_coords$lat[i]),
    dates = c("1981", "2024")
  )
  
  # B. Robust Reshape & Cleaning Step
  df_clean <- df_power %>%
    # Sadece ihtiya?? duyulan s??tunlar?? se?? (ANN ve metadata ??ak????mas??n?? engeller)
    select(YEAR, PARAMETER, JAN:DEC) %>%
    pivot_longer(cols = JAN:DEC, names_to = "MONTH", values_to = "VALUE") %>%
    pivot_wider(names_from = PARAMETER, values_from = VALUE) %>%
    mutate(
      month_num = match(MONTH, c("JAN", "FEB", "MAR", "APR", "MAY", "JUN", 
                                 "JUL", "AUG", "SEP", "OCT", "NOV", "DEC")),
      date = as.Date(paste(YEAR, month_num, "01", sep = "-")),
      # S??tun tiplerini kesin say??sal yap??lara d??n????t??r
      PRECTOTCORR = as.numeric(PRECTOTCORR),
      T2M = as.numeric(T2M)
    ) %>%
    # Hatal?? NASA de??erlerini ve NA'lar?? filtrele
    filter(PRECTOTCORR >= 0 & T2M > -90) %>%
    drop_na(PRECTOTCORR, T2M) %>%
    arrange(date) %>%
    # WaveletComp i??in tibble yap??s??n?? standart data.frame'e ??evir
    as.data.frame()
  
  # C. Continuous Wavelet Transform (CWT)
  my_wavelet <- analyze.wavelet(
    df_clean, 
    my.series = "PRECTOTCORR",
    loess.span = 0,
    dt = 1/12,          
    dj = 1/250,
    lowerPeriod = 1/4,  
    upperPeriod = 16,   
    make.pval = TRUE, 
    n.sim = 100         
  )
  
  # D. Save Plot
  file_path <- file.path(output_dir, paste0("Wavelet_", current_city, "_Precipitation.jpg"))
  
  jpeg(filename = file_path, width = 1200, height = 700, res = 130)
  wt.image(
    my_wavelet, 
    main = paste("Wavelet Power Spectrum -", current_city, "(Precipitation)"),
    legend.params = list(lab = "Wavelet Power"),
    periodlab = "Period (Years)",
    timelab = "Time (Years)"
  )
  dev.off()
  
  cat(paste0("-> Saved: ", file_path, "\n"))
}

cat("\nAll analyses completed successfully! Outputs are in 'wavelet_outputs'.\n")