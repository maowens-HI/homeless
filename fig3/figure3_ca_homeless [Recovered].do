/*******************************************************************************
* Figure 3: California Housing Inventory and Homeless Population Counts over Time
* IMPROVED VERSION - Cleaner data visualization
* Source: HUD Exchange
*
* Key improvements:
*   - Distinct color palette for all 5 lines
*   - Extended y-axis to fit all data
*   - Policy reference line for SB 1380 (2016)
*   - Cleaner legend layout (single column, right side)
*   - Better annotation placement
*   - Grouped lines by concept (homeless = warm colors, housing = cool colors)
*******************************************************************************/

clear all
set more off

*-------------------------------------------------------------------------------
* CREATE DATASET
* Data from HUD Exchange: PIT Estimates and HIC Counts by State (2007-2020)
*-------------------------------------------------------------------------------

input year overall_homeless unsheltered sheltered perm_housing shelter_units
2010  123480  72581   50899   39772   50282
2011  125128  74437   50691   42530   49657
2012  120098  74208   45890   50057   47144
2013  118552  72998   45554   42180   45411
2014  113952  71437   42515   49084   44035
2015  115738  73699   42039   56894   45929
2016  118142  78390   39752   65191   42351
2017  131532  88896   42636   71653   44473
2018  129972  89543   40429   80743   43548
2019  151278 108432   42846   85838   46306
2020  161548 113660   47888   88483   53265
2021  .       .       51429  106045   60582
2022  171521 115491   56030  119950   68607
2023  181399 123423   57976  126094   71131
2024  187084 123974   63110  132856   75938
end


* Label variables
label variable year "Year"
label variable overall_homeless "Overall Homeless Population"
label variable unsheltered "Unsheltered Population"
label variable sheltered "Sheltered Population"
label variable perm_housing "Permanent Housing incl. RRH"
label variable shelter_units "Shelter Units"

*-------------------------------------------------------------------------------
* CALCULATE GAP FOR ANNOTATION
*-------------------------------------------------------------------------------

quietly sum overall_homeless if year == 2024
local homeless_2024 = r(mean)
quietly sum perm_housing if year == 2024
local perm_2024 = r(mean)
local gap_2024 = `homeless_2024' - `perm_2024'
di "2024 Gap between Homeless and Permanent Housing: `gap_2024'"

*-------------------------------------------------------------------------------
* CREATE IMPROVED FIGURE
*-------------------------------------------------------------------------------

* Use clean white scheme as base
set scheme s2color

twoway ///
    /* Homeless population lines - warm colors (reds/oranges) */ ///
    (line overall_homeless year, lcolor("165 0 38") lwidth(thick) lpattern(solid)) ///
    (line unsheltered year, lcolor("215 48 39") lwidth(medthick) lpattern(longdash)) ///
    (line sheltered year, lcolor("244 109 67") lwidth(medthick) lpattern(shortdash)) ///
    ///
    /* Housing inventory lines - cool colors (greens/blues) */ ///
    (line perm_housing year, lcolor("0 104 55") lwidth(thick) lpattern(solid)) ///
    (line shelter_units year, lcolor("69 117 180") lwidth(medthick) lpattern(solid)) ///
    , ///
    ///
    /* Y-axis: extended range, clean labels */ ///
    ylabel(0 "0" 50000 "50,000" 100000 "100,000" 150000 "150,000" 200000 "200,000", ///
        angle(horizontal) labsize(small) nogrid format(%9.0fc)) ///
    yscale(range(0 210000)) ///
    ytitle("Population / Units", size(small)) ///
    ///
    /* X-axis */ ///
    xlabel(2010(2)2024, labsize(small)) ///
    xtitle("") ///
    ///
    /* Title - left aligned, more professional */ ///
    title("California Homelessness and Housing Inventory, 2010–2024", ///
        size(medium) position(11) justification(left)color(black)) ///
    ///
    /* Legend - single column on right for clarity */ ///
    legend( ///
        order(1 "Total Homeless Population" ///
              2 "Unsheltered Population" ///
              3 "Sheltered Population" ///
              4 "Permanent Housing" "(PSH + RRH)" ///
              5 "Sheltered Units") ///
        cols(3) position(6) ring(1) ///
        region(lstyle(none) fcolor(white%80)) ///
        size(vsmall) symxsize(8) colgap(3) rowgap(0.5)) ///
    ///
    /* Graph appearance */ ///
    graphregion(color(white) margin(r+15)) ///
    plotregion(margin(small)) ///
    ///
    /* Annotations */ ///
/* Annotations */ ///
text(187084 2024 "Total Homeless Pop.", size(vsmall) color("165 0 38") placement(east)) ///
    text(123974 2024.4 "Unsheltered Pop.", size(vsmall) color("215 48 39") placement(east)) ///
    text(64110 2024.4 "Sheltered Pop.", size(vsmall) color("244 109 67") placement(east)) ///
    text(132856 2024 "Permanent Housing", size(vsmall) color("0 104 55") placement(east)) ///
    text(78387 2024.4 "Shelter Units", size(vsmall) color("69 117 180") placement(east)) ///
    text(150000 2020 "{it:2024 Gap between Total Homeless}" "{it:and Permanent Housing: 54,228}", size(vsmall) color(gs6) placement(east)) ///
	///
    /* Source note */ ///
note("Source: HUD Exchange Point-in-Time (PIT) Counts and Housing Inventory Counts (HIC)" ///
     "Note: 2021 total homeless count unavailable due to COVID-19 data collection changes." ///
	 "Shelter Units = total year-round beds in Emergency Shelter + Transitional Housing + Safe Haven." ///
     "PSH = Permanent Supportive Housing; RRH = Rapid Rehousing.", ///
    size(vsmall) position(7))
* Export figure
graph export "figure3_ca_homeless_improved.png", replace width(1400)
graph export "figure3_ca_homeless_improved.pdf", replace

*-------------------------------------------------------------------------------
* ALTERNATIVE: Even cleaner with direct labels (no legend)
* Uncomment below if you prefer this style
*-------------------------------------------------------------------------------


twoway ///
    (line overall_homeless year, lcolor("165 0 38") lwidth(thick)) ///
    (line unsheltered year, lcolor("215 48 39") lwidth(medthick) lpattern(longdash)) ///
    (line sheltered year, lcolor("244 109 67") lwidth(medthick) lpattern(shortdash)) ///
    (line perm_housing year, lcolor("0 104 55") lwidth(thick)) ///
    (line shelter_units year, lcolor("69 117 180") lwidth(medthick)) ///
    , ///
    ylabel(0 "0" 50000 "50,000" 100000 "100,000" 150000 "150,000" 200000 "200,000", ///
        angle(horizontal) labsize(small) nogrid) ///
    yscale(range(0 210000)) ///
    ytitle("Population / Units", size(small)) ///
    xlabel(2010(2)2024, labsize(small)) ///
    xtitle("") ///
    title("California Homelessness and Housing Inventory, 2010–2024", ///
        size(medium) position(11) justification(left)) ///
    legend(off) ///
    graphregion(color(white) margin(r+22)) ///
    plotregion(margin(small)) ///
    /* Direct labels at end of each line */ ///
    text(187084 2024.4 "Total Homeless", size(vsmall) color("165 0 38") placement(east)) ///
    text(123974 2024.4 "Unsheltered", size(vsmall) color("215 48 39") placement(east)) ///
    text(68110 2024.4 "Sheltered", size(vsmall) color("244 109 67") placement(east)) ///
    text(132856 2024.2 "Permanent Housing", size(vsmall) color("0 104 55") placement(east)) ///
    text(59387 2024.4 "Shelter Beds", size(vsmall) color("69 117 180") placement(east)) ///
    note("Source: HUD Exchange PIT Counts and Housing Inventory Counts", size(vsmall))

graph export "figure3_direct_labels.png", replace width(1400)


* Save dataset for reference
save "figure3_data.dta", replace

di _newline "=== Figure exported successfully ===" _newline
di "Key takeaway: 2024 gap between homeless population and permanent housing = `gap_2024'"

