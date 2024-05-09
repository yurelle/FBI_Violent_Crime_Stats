-- 
-- State Crime Rates are close to Summary Rates
-- 
-- Robbery (within 4%)
-- Aggravated Assault (within 6%)
-- 
-- Murder (No Population Column)
-- 

-- Robbery
WITH StateReportedTotals AS (
    SELECT year,
           SUM(total_robberies) / SUM(population) * 100000 AS robbery_rate
      FROM fbi_violent_crime_stats_2005_2019.Robbery
     GROUP BY year
),
Calc AS (
    SELECT  summary.year,
            summary.robbery_rate AS summary_rob_rate,
            state_totals.robbery_rate AS reported_rob_rate,
            ABS(summary.robbery_rate - state_totals.robbery_rate) AS rate_diff,
            ABS(summary.robbery_rate - state_totals.robbery_rate) / summary.robbery_rate AS rate_diff_ratio
    FROM fbi_violent_crime_stats_2005_2019.Summary summary
    JOIN StateReportedTotals state_totals
      ON summary.year = state_totals.year
)
SELECT  year,
        summary_rob_rate,
        reported_rob_rate,
        ROUND(rate_diff, 4) AS rate_diff,
        CONCAT(ROUND(rate_diff_ratio * 100, 2), '%') AS rate_diff_percent
FROM Calc
;-- WHERE rate_diff_percent > 4; -- All within 4%; Most within 3%


-- Aggravated Assault
WITH StateReportedTotals AS (
    SELECT year,
           SUM(total_aggravated_assaults) / SUM(population) * 100000 AS aggravated_assault_rate
      FROM fbi_violent_crime_stats_2005_2019.Aggravated_Assault
     GROUP BY year
),
Calc AS (
    SELECT  summary.year,
            summary.aggravated_assault_rate AS summary_agg_rate,
            state_totals.aggravated_assault_rate AS reported_agg_rate,
            ABS(summary.aggravated_assault_rate - state_totals.aggravated_assault_rate) AS rate_diff,
            ABS(summary.aggravated_assault_rate - state_totals.aggravated_assault_rate) / summary.robbery_rate AS rate_diff_ratio
    FROM fbi_violent_crime_stats_2005_2019.Summary summary
    JOIN StateReportedTotals state_totals
      ON summary.year = state_totals.year
)
SELECT  year,
        summary_agg_rate,
        reported_agg_rate,
        ROUND(rate_diff, 4) AS rate_diff,
        CONCAT(ROUND(rate_diff_ratio * 100, 2), '%') AS rate_diff_percent
FROM Calc
;-- WHERE rate_diff_percent > 6; -- All within 6%; Half within 2%

