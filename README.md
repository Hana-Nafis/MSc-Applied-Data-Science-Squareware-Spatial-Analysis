# Squareware Spatial Sales Analysis

## Project Overview

This project was completed as part of the MA52098 Applied Data Science module for the MSc Statistics and Data Science programme at the University of Bath.

The analysis investigates sales patterns across two distribution channels: physical stores and influencer-hosted events. It uses spatial data to explore geographical sales patterns, product preferences, event locations, and differences in channel performance across Squareland.

The project combines exploratory data analysis with spatial statistical techniques to investigate how sales activity is distributed geographically and how the two channels compare.

## Project Objectives

- Explore and compare sales performance across store and influencer channels.
- Investigate geographical patterns in store sales across districts.
- Identify spatial concentrations and potential hotspots in influencer event locations.
- Examine differences in product and bundle composition between channels.
- Compare channel performance across geographical districts.
- Investigate the relationship between store sales and influencer sales.

## Methodology

The analysis was conducted in R using spatial data processing, visualisation, and statistical techniques.

Key stages included:

1. Data preparation – importing and inspecting store and influencer spatial datasets.
2. Spatial visualisation – mapping store sales across districts using choropleth maps.
3. Spatial density analysis – applying Kernel Density Estimation (KDE) to identify concentrations of influencer events.
4. Spatial clustering analysis – using Ripley's L function to investigate whether influencer event locations exhibited spatial clustering.
5. Nearest-neighbour analysis – comparing observed nearest-neighbour distances against expectations under Complete Spatial Randomness (CSR).
6. Product mix analysis – comparing the composition of products and bundles sold through each channel.
7. District-level analysis – aggregating sales by district and comparing store and influencer performance.
8. Statistical comparison – examining the relationship between district-level store and influencer sales using Spearman's rank correlation.
9. Influencer productivity – exploring average sales per influencer event across districts.

## Key Findings

- Influencer sales accounted for approximately twice the sales volume recorded through physical stores. However, this comparison requires caution because the two channels used different bundle compositions.
- Influencer event locations exhibited spatial clustering, with Kernel Density Estimation identifying areas of higher event concentration.
- Ripley's L analysis indicated clustering beyond the expected pattern under Complete Spatial Randomness.
- The observed mean nearest-neighbour distance between influencer events was 2.73, compared with an expected distance of 3.37 under CSR.
- Store sales were distributed more evenly across districts, whereas influencer sales were geographically more concentrated.
- Product composition differed between channels. Store bundles contained two small, one medium, and one large item, while influencer bundles contained two small, two medium, and one large item.
- District-level store and influencer sales showed a negative Spearman correlation (ρ = -0.39, p = 0.054). This was not statistically significant at the conventional 5% significance level.
- Districts 6, 7, and 12 had relatively high influencer-to-store sales ratios, while districts 17 and 23 were more store-dominant.

Overall, the findings suggest differences in geographical distribution and sales patterns between the two channels. The analysis is exploratory and does not establish that one channel causes higher sales or performs better independently of its product composition.

## Tools and Libraries

- R
- RStudio
- sf
- tidyverse
- dplyr
- readr
- tmap
- spatstat.geom
- spatstat.explore
- kableExtra
- here
- knitr
- scales

## Repository Structure

```text
MSc-Applied-Data-Science-Squareware-Spatial-Analysis/
│
├── README.md
├── squareware_spatial_analysis.R
│
└── data/
    └── README.md
```

## Dataset Information

The project uses two spatial datasets supplied for academic coursework:

- `squareland_stores.gpkg` – geographical data representing store sales across districts.
- `squareland_influencers.gpkg` – point-based geographical data representing influencer event locations.

The datasets are not included in this repository because they are not publicly available.

Authorised copies of both GeoPackage files are required to reproduce the analysis. Place them in the appropriate data directory and ensure the file paths in the R script match their locations.

See `data/README.md` for further information.

## Reproducibility

The R script contains the code used for data preparation, spatial analysis, statistical comparisons, and visualisation. The original GeoPackage datasets are required to reproduce the analysis and generate the outputs.

