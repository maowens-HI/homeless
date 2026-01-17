/*******************************************************************************
* Figure 3: California Housing Inventory and Homeless Population Counts over Time
* Source: HUD Exchange
*
* NOTES:
* - Data extracted from official HUD Exchange Excel files:
*   - 2007-2020-PIT-Estimates-by-state.xlsx (Homeless population counts)
*   - 2007-2020-HIC-Counts-by-State.xlsx (Housing inventory counts)
* - SB 1380 passed in 2016
* - 2020 Difference between Homeless Population and Permanent Units: 73,065
*******************************************************************************/

clear all
set more off

*-------------------------------------------------------------------------------
* CREATE DATASET
* Data from HUD Exchange: PIT Estimates and HIC Counts by State (2007-2020)
*-------------------------------------------------------------------------------

input year overall_homeless unsheltered sheltered perm_housing shelter_units
2010  123480  72581  50899  39772  20010
2011  125128  74437  50691  42530  19958
2012  120098  74208  45890  50057  17541
2013  118552  72998  45554  42180  16680
2014  113952  71437  42515  49084  17869
2015  115738  73699  42039  56894  20857
2016  118142  78390  39752  65191  20240
2017  131532  88896  42636  71653  24799
2018  129972  89543  40429  80743  27246
2019  151278  108432  42846  85838  31028
2020  161548  113660  47888  88483  38241
end

* Note: perm_housing = PSH + RRH beds from HIC data
* 2020 Gap = 161548 - 88483 = 73065

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
    text(130000 2018.5 "2020 Difference between" "Homeless Population and Permanent Units:" "73,065", ///
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
    text(125000 2018.8 "2020 Difference between" "Homeless Population and Permanent Units:" "73,065", ///
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
