# Applied Data Science – Squareware Spatial Analysis

## Project Overview

This project was completed as part of the MA52098 Applied Data Science module for the MSc Statistics and Data Science programme at the University of Bath.

The project analyses historical Squareware sales data to explore the relative performance of two sales channels: in-store purchases and influencer-hosted events.

Using R and spatial analysis techniques, the project investigates geographical sales patterns, product preferences, influencer activity and differences in sales performance across districts.

## Analysis

The analysis includes:

- Data inspection and descriptive statistics
- Calculation of total sales and product composition by channel
- Choropleth mapping of store sales across districts
- Spatial analysis of influencer event locations
- Kernel Density Estimation (KDE)
- Ripley's K/L function for spatial clustering
- Nearest neighbour distance analysis
- Aggregation of influencer sales by district
- Comparison of store and influencer sales
- Product mix and sales ratio analysis
- Spearman's rank correlation
- Influencer productivity analysis by district

## Tools and Libraries

- R
- RStudio
- tidyverse
- dplyr
- readr
- sf
- tmap
- spatstat.geom
- spatstat.explore
- kableExtra
- here

## Repository Structure

- `squareware_spatial_analysis.R` – R script containing the spatial and sales analysis
- `data/` – Information about the datasets and their availability

## Dataset

The project uses two spatial datasets containing historical Squareware sales information:

- Store sales data (`squareland_stores.gpkg`)
- Influencer event sales data (`squareland_influencers.gpkg`)

The original datasets are not included in this repository because they are not publicly available. See `data/README.md` for further information.
