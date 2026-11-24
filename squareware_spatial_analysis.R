
# Setup
knitr::opts_chunk$set(echo = TRUE, warning = FALSE, message = FALSE)

# Libraries
# include your libraries here
# use echo = FALSE if you do not want the Code button to appear 
library(tidyverse)
library(dplyr)
library(readr)
library(tmap)
library(spatstat.geom)
library(spatstat.explore)
library(kableExtra)

library(sf)
library(here)

stores <- st_read(here("data", "squareland_stores.gpkg"))
influencers <- st_read(here("data", "squareland_influencers.gpkg"))

# Data Inspection

summary_stores <- stores %>%
  st_drop_geometry() %>%
  summarise(
    Metric = c("Min", "1st Qu.", "Median", "Mean", "3rd Qu.", "Max"),
    Bundle = c(min(Bundle), quantile(Bundle, 0.25), median(Bundle), mean(Bundle), quantile(Bundle, 0.75), max(Bundle)),
    Small  = c(min(Small),  quantile(Small, 0.25),  median(Small),  mean(Small),  quantile(Small, 0.75),  max(Small)),
    Medium = c(min(Medium), quantile(Medium, 0.25), median(Medium), mean(Medium), quantile(Medium, 0.75), max(Medium)),
    Large  = c(min(Large),  quantile(Large, 0.25),  median(Large),  mean(Large),  quantile(Large, 0.75),  max(Large))
  )
summary_stores %>%
  knitr::kable(
    caption = "Table 1: Summary statistics for store sales variables"
  ) %>%
  kable_styling(
    full_width = FALSE,
    position = "center",
    bootstrap_options = c("striped", "hover", "condensed")
  )

summary_inf <- influencers %>%
  st_drop_geometry() %>%
  summarise(
    Metric = c("Min", "1st Qu.", "Median", "Mean", "3rd Qu.", "Max"),
    Bundle = c(min(Bundle), quantile(Bundle, 0.25), median(Bundle), mean(Bundle), quantile(Bundle, 0.75), max(Bundle)),
    Small  = c(min(Small),  quantile(Small, 0.25),  median(Small),  mean(Small),  quantile(Small, 0.75),  max(Small)),
    Medium = c(min(Medium), quantile(Medium, 0.25), median(Medium), mean(Medium), quantile(Medium, 0.75), max(Medium)),
    Large  = c(min(Large),  quantile(Large, 0.25),  median(Large),  mean(Large),  quantile(Large, 0.75),  max(Large))
  )
summary_inf %>%
  knitr::kable(
    caption = "Table 2: Summary statistics for influencer sales variables"
  ) %>%
  kable_styling(
    full_width = FALSE,
    position = "center",
    bootstrap_options = c("striped", "hover", "condensed")
  )

# Store Sales Analysis

# Compute total sales and product mix
# Stores:      Bundle = 2 Small + 1 Medium + 1 Large
# Influencers: Bundle = 2 Small + 2 Medium + 1 Large

stores <- stores %>%
  mutate(
    Total_boxes = Bundle + Small + Medium + Large,
    Total_items = Bundle * 4 + Small + Medium + Large,  #2S+1M+1L per bundle
    Bundle_share = Bundle / Total_boxes,
    Small_share = Small / Total_boxes,
    Medium_share = Medium / Total_boxes,
    Large_share = Large  / Total_boxes
  )

influencers <- influencers %>%
  mutate(
    Total_boxes = Bundle + Small + Medium + Large,
    Total_items = Bundle * 5 + Small + Medium + Large,  #2S+2M+1L per bundle
    Bundle_share = Bundle / Total_boxes,
    Small_share = Small / Total_boxes,
    Medium_share = Medium / Total_boxes,
    Large_share = Large  / Total_boxes
  )

# Summary table of total sales by channel
data.frame(
  Channel  = c("Stores", "Influencers"),
  Bundle   = c(sum(stores$Bundle),      sum(influencers$Bundle)),
  Small    = c(sum(stores$Small),       sum(influencers$Small)),
  Medium   = c(sum(stores$Medium),      sum(influencers$Medium)),
  Large    = c(sum(stores$Large),       sum(influencers$Large)),
  Total_boxes = c(sum(stores$Total_boxes), sum(influencers$Total_boxes)),
  Total_items = c(sum(stores$Total_items), sum(influencers$Total_items))
) %>%
  knitr::kable(caption = "Table 3: Total sales by channel",
               col.names = c("Channel", "Bundle", "Small", "Medium", 
                             "Large", "Total Boxes", "Total Items"),
               format.args = list(big.mark = ","),
               align = "lrrrrrr")%>%
  kable_styling(
    full_width = FALSE,
    position = "center",
    bootstrap_options = c("striped", "hover", "condensed", "responsive")
  )

# Choropleth Maps - Store Sales
tmap_mode("plot")

# Total boxes sold per district
p_store_total <- tm_shape(stores) +
  tm_polygons("Total_boxes",
              palette    = "Reds",
              style      = "quantile",
              n          = 5) +
  tm_text("District", size = 0.6, col = "grey20") +
  tm_scale_bar()

# Bundle share per district
p_store_bundle <- tm_shape(stores)+
  tm_polygons("Bundle_share",
              palette    = "Blues",
              style      = "quantile",
              n          = 5) +
  tm_text("District", size = 0.6, col = "grey20") 

tmap_arrange(p_store_total, p_store_bundle, nrow = 1)

# Top 5 districts by store sales
stores %>%
  st_drop_geometry() %>%
  select(District, Total_boxes, Bundle_share) %>%
  arrange(desc(Total_boxes)) %>%
  head(5) %>%
  knitr::kable(caption = "Table 4: Top 5 Districts by Total Store Sales",
               col.names = c("District", "Total Boxes", "Bundle Share"),
               digits = 2)%>%
  kable_styling(full_width = FALSE, position = "center",
                bootstrap_options = c("striped", "hover", "condensed"))

p_small <- tm_shape(stores) +
  tm_polygons("Small_share", 
              palette = "Greens", 
              style = "quantile", 
              n = 5) +
  tm_text("District", size = 0.6, col = "grey20")

p_large <- tm_shape(stores) +
  tm_polygons("Large_share", 
              palette = "Oranges",
              style = "quantile", 
              n = 5) +
  tm_text("District", size = 0.6, col = "grey20")

tmap_arrange(p_small, p_large, nrow = 1)

# Top 5 districts by bundle share and large share
stores %>%
  st_drop_geometry() %>%
  select(District, Bundle_share, Small_share, Medium_share, Large_share) %>%
  arrange(desc(Bundle_share)) %>%
  head(5) %>%
  knitr::kable(caption = "Table 5: Product share breakdown for top 5 districts by bundle share",
               col.names = c("District", "Bundle", "Small", "Medium", "Large"),
               digits = 2)%>%
  kable_styling(full_width = FALSE, position = "center",
                bootstrap_options = c("striped", "hover", "condensed"))

# Influencer Sales Analysis

# Point-Pattern Analysis: Influencer Locations
# Extract coordinates
inf_coords <- st_coordinates(influencers)

# Define observation window (0-100 x 0-100 to match stores grid)
w <- owin(c(0,100),c(0,100))
ppp_inf <- ppp(inf_coords[,1], inf_coords[,2], window = w)

# Kernel Density Estimation (KDE) - shows where influencers cluster
kde_inf <- density(ppp_inf, sigma = 8)
plot(kde_inf,
     col  = hcl.colors(20, "YlOrRd", rev = TRUE))
points(ppp_inf, pch = 16, cex = 0.4, col = "black")

# Ripley's K / L function – tests for spatial clustering
L_inf <- Lest(ppp_inf, correction = "Ripley")
plot(L_inf,
     xlab = "Distance (units)", ylab = "L(r) - r")
abline(h = 0, lty = 2, col = "red")   # red = CSR expectation

#  Nearest neighbour analysis 
# Compute values
nnd <- nndist(ppp_inf)
mean_nnd <- round(mean(nnd), 2)
expected_nnd <- round(0.5 / sqrt(ppp_inf$n / area(w)), 2)

# Create table
nn_table <- data.frame(
  Metric = c("Observed mean nearest neighbour distance",
             "Expected distance under CSR"),
  Value = c(mean_nnd, expected_nnd)
)

# Display with kableExtra
nn_table %>%
  knitr::kable(
    caption = "Table 6: Nearest neighbour distance summary",
    col.names = c("Metric", "Distance")
  ) %>%
  kable_styling(
    full_width = FALSE,
    position = "center",
    bootstrap_options = c("striped", "hover", "condensed")
  )

# Comparing Channels

# Aggregate Influencer Sales to District Grid
# Spatial join: assign each influencer event to a district polygon
influencers <- st_set_crs(influencers, st_crs(stores))

inf_by_district <- st_join(influencers, stores["District"]) %>%
  st_drop_geometry() %>%
  group_by(District) %>%
  summarise(
    n_influencers  = n(),
    Inf_Bundle     = sum(Bundle),
    Inf_Small      = sum(Small),
    Inf_Medium     = sum(Medium),
    Inf_Large      = sum(Large),
    Inf_Total      = sum(Total_boxes),
    .groups = "drop"
  )

# Join aggregated influencer data back to stores sf
combined <- stores %>%
  left_join(inf_by_district, by = "District") %>%
  mutate(
    n_influencers  = replace_na(n_influencers, 0),
    Inf_Total      = replace_na(Inf_Total, 0),
    Ratio_inf_store = Inf_Total / Total_boxes
  )

# Number of influencer events per district
inf_by_district %>%
  arrange(desc(n_influencers)) %>%
  head(5) %>%
  knitr::kable(caption = "Table 7: Top 5 Influencer Events per District",
               col.names = c("District", "N Events", "Bundle", 
                             "Small", "Medium", "Large", "Total Boxes"))%>%
  kable_styling(full_width = FALSE, position = "center",
                bootstrap_options = c("striped", "hover", "condensed"))

data.frame(
  Channel = c("Stores", "Influencers"),
  Total_items = c(sum(stores$Total_items), sum(influencers$Total_items))
) %>%
  ggplot(aes(x = Channel, y = Total_items, fill = Channel)) +
  geom_col(width = 0.5) +
  scale_fill_manual(values = c("Stores" = "orange", "Influencers" = "lightblue")) +
  labs(title = "Total Individual Items Sold by Channel",
       y = "Total items", x = "") +
  theme_minimal(base_size = 13)

# Product Mix Comparison
# Long-format product mix for stores
store_mix <- stores %>%
  st_drop_geometry() %>%
  summarise(Bundle = sum(Bundle), Small = sum(Small),
            Medium = sum(Medium), Large  = sum(Large)) %>%
  tidyr::pivot_longer(everything(), names_to = "Product", values_to = "Count") %>%
  mutate(Channel = "Store", Share = Count / sum(Count))

# Influencer mix
inf_mix <- influencers %>%
  st_drop_geometry() %>%
  summarise(Bundle = sum(Bundle), Small = sum(Small),
            Medium = sum(Medium), Large  = sum(Large)) %>%
  tidyr::pivot_longer(everything(), names_to = "Product", values_to = "Count") %>%
  mutate(Channel = "Influencer", Share = Count / sum(Count))

mix_df <- bind_rows(store_mix, inf_mix) %>%
  mutate(Product = factor(Product, levels = c("Bundle","Small","Medium","Large")))

ggplot(mix_df, aes(x = Product, y = Share, fill = Channel)) +
  geom_col(position = "dodge") +
  scale_y_continuous(labels = scales::percent) +
  scale_fill_manual(values = c("Store" = "orange", "Influencer" = "lightblue")) +
  labs(title  = "Product Mix: Stores vs. Influencer Parties",
       x      = "Product",
       y      = "Share of boxes sold",
       fill   = "Channel") +
  theme_minimal(base_size = 13)

# Side-by-side Maps: Store vs Influencer Totals
p_stores_map <- tm_shape(combined) +
  tm_polygons("Total_boxes",
              palette = "YlOrRd",
              style = "quantile", 
              n = 5)+
  tm_text("District", size = 0.6, col = "grey20")

p_inf_map <- tm_shape(combined) +
  tm_polygons("Inf_Total",
              palette = "PuBuGn",
              style = "quantile", 
              n = 5) +
  tm_text("District", size = 0.6, col = "grey20")+
  tm_shape(influencers) +
  tm_dots(size = 0.15, col = "black", alpha = 0.5)

tmap_arrange(p_stores_map, p_inf_map, nrow = 1)

# Influencer-to-Store Sales Ratio Map
tm_shape(combined) +
  tm_polygons("Ratio_inf_store",
              palette    = "RdYlGn",
              style      = "quantile",
              n          = 5) +
  tm_text("District", size = 0.6, col = "grey20") +
  tm_shape(influencers) +
  tm_dots(size = 0.1, col = "black", alpha = 0.3)

# Top 5 districts by influencer/store ratio
combined %>%
  st_drop_geometry() %>%
  select(District, Total_boxes, Inf_Total, Ratio_inf_store) %>%
  arrange(desc(Ratio_inf_store)) %>%
  head(5) %>%
  knitr::kable(
    caption = "Table 8: Top 5 districts by influencer-to-store ratio",
    col.names = c("District", "Store Boxes", "Inf Boxes", "Ratio"),
    digits = 2
  ) %>%
  kable_styling(full_width = FALSE, position = "center",
                bootstrap_options = c("striped", "hover", "condensed"))

# Bottom 5 districts by influencer/store ratio
combined %>%
  st_drop_geometry() %>%
  select(District, Total_boxes, Inf_Total, Ratio_inf_store) %>%
  arrange(Ratio_inf_store) %>%
  head(5) %>%
  knitr::kable(
    caption = "Table 9: Bottom 5 districts by influencer-to-store ratio",
    col.names = c("District", "Store Boxes", "Inf Boxes", "Ratio"),
    digits = 2
  ) %>%
  kable_styling(full_width = FALSE, position = "center",
                bootstrap_options = c("striped", "hover", "condensed"))

# Scatter: Store vs Influencer Sales by District
ggplot(combined, aes(x = Total_boxes, y = Inf_Total, label = District)) +
  geom_point(size = 3, colour = "yellow")+
  geom_text(nudge_y = 30, size = 3) +
  geom_abline(slope = 1, intercept = 0, linetype = "dashed", colour = "grey4") +
  labs(title = "District-level: Store Sales vs. Influencer Sales",
       x     = "Store boxes sold",
       y     = "Influencer boxes sold (aggregated)",
       caption = "Dashed line = 1:1 parity") +
  theme_minimal(base_size = 13)

# Districts with no influencer activity
combined %>%
  st_drop_geometry() %>%
  filter(n_influencers == 0) %>%
  select(District, Total_boxes) %>%
  knitr::kable(caption = "Table 10: Districts with No Influencer Activity")%>%
  kable_styling(full_width = FALSE, position = "center",
                bootstrap_options = c("striped", "hover", "condensed"))

cor_result <- cor.test(combined$Total_boxes, combined$Inf_Total, method = "spearman")

data.frame(
  Metric = c("Spearman's rho", "p-value"),
  Value  = c(round(cor_result$estimate, 3), round(cor_result$p.value, 3))
) %>%
  knitr::kable(caption = "Table 11: Spearman correlation between store and influencer sales",
               col.names = c("Metric", "Value")) %>%
  kable_styling(full_width = FALSE, position = "center",
                bootstrap_options = c("striped", "hover", "condensed"))

# Influencer Productivity

# Influencer Sales per Event by District
combined_with_rate <- combined %>%
  mutate(Inf_per_event = if_else(n_influencers > 0,
                                 Inf_Total / n_influencers,
                                 NA_real_))

tm_shape(combined_with_rate) +
  tm_polygons("Inf_per_event",
              palette        = "Purples",
              style          = "quantile",
              n              = 5) +
  tm_text("District", size = 0.6, col = "grey20")

combined_with_rate %>%
  st_drop_geometry() %>%
  select(District, n_influencers, Inf_Total, Inf_per_event) %>%
  filter(!is.na(Inf_per_event)) %>%
  arrange(desc(Inf_per_event)) %>%
  head(5) %>%
  knitr::kable(
    caption = "Table 12: Top 5 districts by average boxes per influencer event",
    col.names = c("District", "N Events", "Total Boxes", "Avg per Event"),
    digits = 1
  ) %>%
  kable_styling(full_width = FALSE, position = "center",
                bootstrap_options = c("striped", "hover", "condensed"))
