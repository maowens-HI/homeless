# Figure 3: California Housing Inventory and Homeless Population Counts over Time

## Files

- `figure3_ca_homeless.do` - Stata do-file to create the figure
- `figure3_data.csv` - Data used in the figure (values approximated from original)

## Data Sources

The exact data can be downloaded from HUD Exchange:

1. **Point-in-Time (PIT) Counts by State (2007-2020)**
   - Download: [2020 AHAR Part 1 Data Files](https://www.huduser.gov/portal/datasets/ahar/2020-ahar-part-1-pit-estimates-of-homelessness-in-the-us.html)
   - File: "2007 - 2020 Point-in-Time Estimates by State (XLSX)"
   - Contains: Overall homeless, sheltered, unsheltered counts by state/year

2. **Housing Inventory Count (HIC) by State (2007-2020)**
   - Download: Same link above
   - File: "2007 - 2020 Housing Inventory Count by State (XLSX)"
   - Contains: Permanent Housing beds, Shelter beds by state/year

## Variables in Figure

| Variable | Description | HUD Data Source |
|----------|-------------|-----------------|
| Overall Homeless Population | Total homeless persons (PIT count) | PIT Estimates by State |
| Sheltered Population | Emergency Shelter + Transitional Housing persons | PIT Estimates by State |
| Unsheltered Population | Persons not in shelter | PIT Estimates by State |
| Permanent Housing incl. RRH | PSH + Rapid Re-Housing beds | HIC by State |
| Shelter Units | Emergency Shelter + Transitional Housing beds | HIC by State |

## Notes

- **SB 1380** (Homeless Coordinating and Financing Council) passed in 2016
- **2020 Gap**: 64,358 = difference between Overall Homeless (161,000) and Permanent Housing (96,642)
- Data values in `figure3_data.csv` are approximated from visual inspection of the original figure
- For publication, replace with exact values from HUD downloads

## Usage

```stata
cd "/path/to/fig3"
do figure3_ca_homeless.do
```

Output files:
- `figure3_ca_homeless.png` (high resolution)
- `figure3_ca_homeless.pdf` (vector format)
- `figure3_data.dta` (Stata dataset)
