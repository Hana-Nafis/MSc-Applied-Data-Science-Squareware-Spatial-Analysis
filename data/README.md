# Dataset Information

This project uses two spatial datasets provided as part of the MA52098 Applied Data Science coursework at the University of Bath.

## Datasets

1. `squareland_stores.gpkg` – Contains store sales information aggregated at the district level and represented as spatial polygons.

2. `squareland_influencers.gpkg` – Contains influencer-hosted event sales information, with each observation representing a geographic event location.

The datasets contain sales information for different product categories, including bundles, small boxes, medium boxes and large boxes.

## Data Availability

The original GeoPackage files are not included in this repository because they are not publicly available and are subject to access restrictions.

The R script uses the `here` package to load both datasets from the `data/` directory. An authorised copy of each dataset is required to run the analysis.
