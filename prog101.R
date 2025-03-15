##########################################################################
## Driver: (Alden) (aldenm34)                                       ##
## Navigator: (Name) (GitHub Handle)                                    ##
## Date: (2025-01-09)                                                   ##
##########################################################################

library(marinecs100b)

# Guiding questions -------------------------------------------------------

# What does KEFJ stand for?
# Kenai Fjords

# How was temperature monitored?
# HOBO V2 temperature loggers were placed at each rocky site.

# What's the difference between absolute temperature and temperature anomaly?
# Absolute temp. refers to recorded temperature, and temp. anomaly refers to how
# much that value deviates from the average.

# Begin exploring ---------------------------------------------------------

# How many kefj_* vectors are there?
#6

# How long are they?
# 2187966

# What do they represent? they represent the data sets for the separate
# categories (temp,site,datetime,tidelevel,exposure,season)

# Link to sketch


aialik_datetime <- kefj_datetime[kefj_site == "Aialik"]
aialik_interval <- aialik_datetime[2:length(aialik_datetime)] - aialik_datetime[1:(length(aialik_datetime)-1)]
table(aialik_interval)

# most common interval was 30 minutes

# Problem decomposition ---------------------------------------------------

# When and where did the hottest and coldest air temperature readings happen?
# The hottest temp occurred on July 7th, 2018, at 1 pm at the Aialik site.

# Link to sketch

# Plot the hottest day

hottest_idx <- which.max(kefj_temperature)
hottest_time <- kefj_datetime[hottest_idx]
hottest_site <- kefj_site[hottest_idx]
hotday_start <- as.POSIXct("2018-07-03 00:00:00", tz = "Etc/GMT+8")
hotday_end <- as.POSIXct("2018-07-03 23:59:59", tz = "Etc/GMT+8")
hotday_idx <- kefj_site == hottest_site &
  kefj_datetime >= hotday_start &
  kefj_datetime <= hotday_end
hotday_datetime <- kefj_datetime[hottest_idx]
hotday_temperature <- kefj_temperature[hottest_idx]
hotday_exposure <- kefj_exposure[hottest_idx]
plot_kefj(hotday_datetime, hotday_temperature, hotday_exposure)

# Repeat for the coldest day

coldest_idx <- which.min(kefj_temperature)
coldest_time <- kefj_datetime[coldest_idx]
coldest_site <- kefj_site[coldest_idx]
colday_start <- as.POSIXct("2013-01-27 00:00:00", tz = "Etc/GMT+8")
colday_end <- as.POSIXct("2013-01-27 23:59:59", tz = "Etc/GMT+8")
coldday_idx <- kefj_site == coldest_site &
  kefj_datetime >= colday_start &
  kefj_datetime <= colday_end
coldday_datetime <- kefj_datetime[coldest_idx]
coldday_temperature <- kefj_temperature[coldest_idx]
coldday_exposure <- kefj_exposure[coldest_idx]
plot_kefj(coldday_datetime, coldday_temperature, coldday_exposure)

# What patterns do you notice in time, temperature, and exposure? Do those
# patterns match your intuition, or do they differ?

#I notice that the hottest
# and coldest temperatures match the type of exposure present which would make
# sense as the sensor would give the coldest reading when underwater.

# How did Traiger et al. define extreme temperature exposure?
# extreme warm (≥25°C) and cold (≤−4°C)

# Translate their written description to code and calculate the extreme heat
# exposure for the hottest day.

extreme_warm_exposure <- kefj_temperature >= 25
extreme_heat_exposure <- kefj_exposure[extreme_warm_exposure]

extract_exposure <- function(site, start, end) {
  start_alaska <- convert_to_alaska(start)
  end_alaska <- convert_to_alaska(end)
  extract_idx <- kefj_site == site &
    kefj_datetime >= start_alaska &
    kefj_datetime <= end_alaska
  result <- kefj_exposure[extract_idx]
  return(result)
}

extract_exposure("Aialik", "2018-07-03 00:00:00", "2018-07-03 23:59:59")

# Compare your answer to the visualization you made. Does it look right to you?

# Repeat this process for extreme cold exposure on the coldest day.


# Putting it together -----------------------------------------------------

# Link to sketch

# Pick one site and one season. What were the extreme heat and cold exposure at
# that site in that season?

# Repeat for a different site and a different season.

# Optional extension: Traiger et al. (2022) also calculated water temperature
# anomalies. Consider how you could do that. Make a sketch showing which vectors
# you would need and how you would use them. Write code to get the temperature
# anomalies for one site in one season in one year.
