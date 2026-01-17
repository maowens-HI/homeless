/*******************************************************************************
* Figure 3: California Housing Inventory and Homeless Population Counts over Time
* Source: HUD Exchange
*
* NOTES:
* - Data values are approximated from visual inspection of the original figure
* - For exact values, download from HUD Exchange:
*   https://www.huduser.gov/portal/datasets/ahar/2020-ahar-part-1-pit-estimates-of-homelessness-in-the-us.html
*   (2007-2020 Point-in-Time Estimates by State and 2007-2020 HIC by State)
* - SB 1380 passed in 2016
* - 2020 Difference between Homeless Population and Permanent Units: 64,358
*******************************************************************************/

clear all
set more off

*-------------------------------------------------------------------------------
* CREATE DATASET
* Values read from Figure 3 (approximate)
*-------------------------------------------------------------------------------

input year overall_homeless unsheltered sheltered perm_housing shelter_units
2010  123000  72000  51000  32000  50000
2011  130000  78000  52000  36000  52000
2012  136000  85000  51000  50000  52000
2013  118000  69000  49000  38000  48000
2014  114000  67000  47000  45000  47000
2015  116000  69000  47000  54000  45000
2016  118000  72000  46000  62000  44000
2017  134000  91000  43000  70000  44000
2018  129000  89000  40000  80000  44000
2019  151000  108000 43000  88000  47000
2020  161000  114000 47000  96642  50000
end

* Note: perm_housing in 2020 = 161000 - 64358 = 96642 (from figure annotation)

label variable year "Year"
label variable overall_homeless "Overall Homeless Population"
label variable unsheltered "Unsheltered Population"
label variable sheltered "Sheltered Population"
label variable perm_housing "Permanent Housing incl. RRH"
label variable shelter_units "Shelter Units"

*-------------------------------------------------------------------------------
* CALCULATE STATISTICS FOR ANNOTATION
*-------------------------------------------------------------------------------

* 2020 gap between homeless and permanent housing
quietly sum overall_homeless if year == 2020
local homeless_2020 = r(mean)
quietly sum perm_housing if year == 2020
local perm_2020 = r(mean)
local gap_2020 = `homeless_2020' - `perm_2020'
di "2020 Gap: `gap_2020'"

*-------------------------------------------------------------------------------
* CREATE FIGURE 3
*-------------------------------------------------------------------------------

* Set graph scheme
set scheme s2color

* Create the figure
twoway ///
    (line overall_homeless year, lcolor(cranberry) lwidth(thick) lpattern(solid)) ///
    (line unsheltered year, lcolor(cranberry) lwidth(medthick) lpattern(longdash)) ///
    (line sheltered year, lcolor(cranberry) lwidth(medthick) lpattern(dash_dot)) ///
    (line perm_housing year, lcolor(teal) lwidth(thick) lpattern(solid)) ///
    (line shelter_units year, lcolor(gs8) lwidth(medthick) lpattern(solid)), ///
    ///
    /* Y-axis settings */ ///
    ylabel(50000 "50,000" 100000 "100,000" 150000 "150,000", ///
        angle(horizontal) labsize(small) nogrid) ///
    yscale(range(25000 175000)) ///
    ytitle("") ///
    ///
    /* X-axis settings */ ///
    xlabel(2010(2)2020, labsize(small)) ///
    xtitle("") ///
    ///
    /* Vertical line for SB 1380 */ ///
    xline(2016, lcolor(black) lpattern(dash) lwidth(thin)) ///
    ///
    /* Title */ ///
    title("Figure 3. California Housing Inventory and Homeless Population Counts over Time", ///
        size(medium) position(11) justification(left)) ///
    ///
    /* Legend */ ///
    legend(order(1 "Overall Homeless" "Population" ///
                 3 "Sheltered Population" ///
                 2 "Unsheltered Population" ///
                 4 "Permanent Housing" "incl. RRH" ///
                 5 "Shelter Units") ///
        cols(1) position(4) ring(0) ///
        region(lstyle(none)) size(vsmall)) ///
    ///
    /* Graph region */ ///
    graphregion(color(white)) ///
    plotregion(margin(small)) ///
    ///
    /* Add text annotations */ ///
    text(155000 2014.5 "Passage of" "SB 1380", size(vsmall) placement(west)) ///
    text(130000 2018.5 "2020 Difference between" "Homeless Population and Permanent Units:" "64,358", ///
        size(vsmall) placement(east) justification(left)) ///
    ///
    note("Source: HUD Exchange", size(vsmall))

* Export figure
graph export "figure3_ca_homeless.png", replace width(1200)
graph export "figure3_ca_homeless.pdf", replace

* Save dataset
save "figure3_data.dta", replace

*-------------------------------------------------------------------------------
* ALTERNATIVE VERSION WITH SEPARATE LEGEND (closer to original)
*-------------------------------------------------------------------------------

twoway ///
    (line overall_homeless year, lcolor(cranberry) lwidth(thick) lpattern(solid)) ///
    (line unsheltered year, lcolor(maroon) lwidth(medthick) lpattern(longdash)) ///
    (line sheltered year, lcolor(maroon) lwidth(medthick) lpattern(dash_dot)) ///
    (line perm_housing year, lcolor("0 128 128") lwidth(thick) lpattern(solid)) ///
    (line shelter_units year, lcolor(gs10) lwidth(medthick) lpattern(solid)), ///
    ///
    ylabel(50000 "50,000" 100000 "100,000" 150000 "150,000", ///
        angle(horizontal) labsize(small) nogrid format(%9.0fc)) ///
    yscale(range(25000 175000)) ///
    ytitle("") ///
    xlabel(2010(2)2020, labsize(small)) ///
    xtitle("") ///
    xline(2016, lcolor(black) lpattern(dash) lwidth(thin)) ///
    title("Figure 3. California Housing Inventory and Homeless Population Counts over Time", ///
        size(medsmall) position(11) justification(left)) ///
    legend(order(1 "Overall Homeless Population" ///
                 3 "Sheltered Population" ///
                 2 "Unsheltered Population" ///
                 4 "Permanent Housing incl. RRH" ///
                 5 "Shelter Units") ///
        cols(1) position(4) ring(0) ///
        region(lstyle(none) fcolor(white)) size(vsmall) ///
        symxsize(8) keygap(1)) ///
    graphregion(color(white)) ///
    plotregion(margin(small)) ///
    text(155000 2014.3 "Passage of" "SB 1380", size(vsmall) placement(west)) ///
    text(125000 2018.8 "2020 Difference between" "Homeless Population and Permanent Units:" "64,358", ///
        size(vsmall) placement(east) justification(left)) ///
    note("Source: HUD Exchange", size(vsmall) position(7))

graph export "figure3_ca_homeless_v2.png", replace width(1200)

*-------------------------------------------------------------------------------
* DISPLAY DATA TABLE
*-------------------------------------------------------------------------------

di _newline(2) "=== California Homeless Data 2010-2020 ==="
list year overall_homeless unsheltered sheltered perm_housing shelter_units, sep(0)

di _newline "=== Key Statistics ==="
di "2020 Overall Homeless: " %9.0fc overall_homeless[11]
di "2020 Permanent Housing: " %9.0fc perm_housing[11]
di "2020 Gap: " %9.0fc (overall_homeless[11] - perm_housing[11])

*-------------------------------------------------------------------------------
* END
*-------------------------------------------------------------------------------

di _newline "Figure 3 created successfully!"
di "Output files: figure3_ca_homeless.png, figure3_ca_homeless.pdf, figure3_data.dta"
