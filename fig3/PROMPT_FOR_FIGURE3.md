# Prompt: Create Figure 3 from HUD Excel Data

## Task

Using the Excel files in `fig3/`, extract California data and update `figure3_ca_homeless.do` with exact values to recreate Figure 3.

## Input Files

1. `fig3/2007 - 2020 Point-in-Time Estimates by State.xlsx` (or similar name)
   - Extract for California, years 2010-2020:
     - **Overall Homeless** = Total Homeless
     - **Sheltered** = Total Sheltered (or Emergency Shelter + Transitional Housing persons)
     - **Unsheltered** = Total Unsheltered

2. `fig3/2007 - 2020 Housing Inventory Count by State.xlsx` (or similar name)
   - Extract for California, years 2010-2020:
     - **Permanent Housing incl. RRH** = Permanent Supportive Housing beds + Rapid Re-Housing beds
     - **Shelter Units** = Emergency Shelter beds + Transitional Housing beds

3. For 2021-2024 data, use the PDFs already in:
   - `fig3/homeless_hud/CoC_PopSub_State_CA_202X.pdf` (homeless counts)
   - `fig3/housing/CoC_HIC_State_CA_202X.pdf` (housing inventory)

## Output

Update these files with exact values:
- `fig3/figure3_data.csv`
- `fig3/figure3_ca_homeless.do` (the `input` data block)

## Figure Details

- Title: "Figure 3. California Housing Inventory and Homeless Population Counts over Time"
- X-axis: Years (2010-2020, or extended to 2024)
- Y-axis: Count (with labels at 50,000, 100,000, 150,000)
- Vertical dashed line at 2016 labeled "Passage of SB 1380"
- Annotation showing 2020 gap: "2020 Difference between Homeless Population and Permanent Units: 64,358"
- Source: HUD Exchange

## Line Styles

| Series | Color | Pattern |
|--------|-------|---------|
| Overall Homeless Population | Red (cranberry) | Solid, thick |
| Unsheltered Population | Red (maroon) | Long dash |
| Sheltered Population | Red (maroon) | Dash-dot |
| Permanent Housing incl. RRH | Teal | Solid, thick |
| Shelter Units | Gray | Solid |

## Example Data Format

```
year,overall_homeless,unsheltered,sheltered,perm_housing,shelter_units
2010,XXXXX,XXXXX,XXXXX,XXXXX,XXXXX
...
```

Read the Excel files, filter to California, extract the relevant columns, and populate the CSV and do-file with exact values.
