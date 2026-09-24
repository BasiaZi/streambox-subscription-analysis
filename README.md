# StreamBox Subscription Analysis

## Project overview

StreamBox is a fictional video streaming platform.

For this portfolio project, I chose to investigate subscription cancellation behaviour.

The main focus of the analysis was identifying patterns in cancellation timing, especially early cancellations and the association between cancellation timing and payment success.

## Dataset

The dataset used in this project comes from Maven Analytics. The original brand is MavenFlix; for this project, I use StreamBox as a fictional rebranding.

The dataset consists of a main table with 3,069 rows, each representing a subscription, and a data dictionary describing the columns of the main table.

## Analysis approach

I initially explored the dataset in Google Sheets to understand its structure, check data types and identify potential data quality issues.
I then used SQL (MySQL) to investigate cancellation timing, early cancellations and payment success rates. 
Finally, I used Power BI to create the data model, measures and dashboard.

## Key findings

- The dataset contains 3,069 subscription records from 2,877 unique customers
- 2,004 subscriptions (65.3%) were cancelled during the observation period
- 282 cancellations (14.1% of all cancellations) occurred within 0–1 days of subscription creation
- Payment success rates differed markedly by cancellation timing: 75.9% for subscriptions cancelled on the same day as creation, 46.0% for those cancelled one day later, 99.8% for subscriptions cancelled after 2 or more days, and 99.1% for subscriptions that were not cancelled

## Dashboard

## Tools

- Google Sheets
- MySQL
- Power BI
- Power Query
- DAX

## Further analysis

The distribution of cancellations by days since subscription creation shows several distinct peaks, suggesting that cancellation behaviour could be investigated further. Cohort retention analysis could provide additional insight into longer-term customer behaviour.
