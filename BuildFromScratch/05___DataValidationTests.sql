-- 
-- Summary Table 
-- (Against Itself)
-- 

-- Verify Violent Crime Total
SELECT  year,
        violent_crime,
        calc_violent_crime
FROM (
    SELECT  year,
            violent_crime,
            murder_and_nonnegligent_manslaughter + rape_legacy_definition + robbery + aggravated_assault AS calc_violent_crime
    FROM fbi_violent_crime_stats_2005_2019.summary
) t1
WHERE violent_crime <> calc_violent_crime;


-- Verify Violent Crime Rate (per 100,000)
SELECT  year,
        violent_crime_rate,
        calc_violent_crime_rate
FROM (
    SELECT  year,
            violent_crime_rate,
            ROUND(violent_crime / population * 100000, 1) AS calc_violent_crime_rate
    FROM fbi_violent_crime_stats_2005_2019.summary
) t1
WHERE violent_crime_rate <> calc_violent_crime_rate;


-- Verify Murder Rate (per 100,000)
SELECT  year,
        murder_and_nonnegligent_manslaughter_rate,
        calc_murder_and_nonnegligent_manslaughter_rate
FROM (
    SELECT  year,
            murder_and_nonnegligent_manslaughter_rate,
            ROUND(murder_and_nonnegligent_manslaughter / population * 100000, 1) AS calc_murder_and_nonnegligent_manslaughter_rate
    FROM fbi_violent_crime_stats_2005_2019.summary
) t1
WHERE murder_and_nonnegligent_manslaughter_rate <> calc_murder_and_nonnegligent_manslaughter_rate;


-- Verify Rape (Revised) Rate (per 100,000)
SELECT  year,
        rape_revised_definition_rate,
        calc_rape_revised_definition_rate
FROM (
    SELECT  year,
            rape_revised_definition_rate,
            ROUND(rape_revised_definition / population * 100000, 1) AS calc_rape_revised_definition_rate
    FROM fbi_violent_crime_stats_2005_2019.summary
) t1
WHERE rape_revised_definition_rate <> calc_rape_revised_definition_rate;


-- Verify Rape (Legacy) Rate (per 100,000)
SELECT  year,
        rape_legacy_definition_rate,
        calc_rape_legacy_definition_rate
FROM (
    SELECT  year,
            rape_legacy_definition_rate,
            ROUND(rape_legacy_definition / population * 100000, 1) AS calc_rape_legacy_definition_rate
    FROM fbi_violent_crime_stats_2005_2019.summary
) t1
WHERE rape_legacy_definition_rate <> calc_rape_legacy_definition_rate;


-- Verify Robbery Rate (per 100,000)
SELECT  year,
        robbery_rate,
        calc_robbery_rate
FROM (
    SELECT  year,
            robbery_rate,
            ROUND(robbery / population * 100000, 1) AS calc_robbery_rate
    FROM fbi_violent_crime_stats_2005_2019.summary
) t1
WHERE robbery_rate <> calc_robbery_rate;


-- Verify Aggravated Assault Rate (per 100,000)
SELECT  year,
        aggravated_assault_rate,
        calc_aggravated_assault_rate
FROM (
    SELECT  year,
            aggravated_assault_rate,
            ROUND(aggravated_assault / population * 100000, 1) AS calc_aggravated_assault_rate
    FROM fbi_violent_crime_stats_2005_2019.summary
) t1
WHERE aggravated_assault_rate <> calc_aggravated_assault_rate;


-- Verify Property Crime Rate (per 100,000)
SELECT  year,
        property_crime_rate,
        calc_property_crime_rate
FROM (
    SELECT  year,
            property_crime_rate,
            ROUND(property_crime / population * 100000, 1) AS calc_property_crime_rate
    FROM fbi_violent_crime_stats_2005_2019.summary
) t1
WHERE property_crime_rate <> calc_property_crime_rate;


-- Verify Burglary Rate (per 100,000)
SELECT  year,
        burglary_rate,
        calc_burglary_rate
FROM (
    SELECT  year,
            burglary_rate,
            ROUND(burglary / population * 100000, 1) AS calc_burglary_rate
    FROM fbi_violent_crime_stats_2005_2019.summary
) t1
WHERE burglary_rate <> calc_burglary_rate;


-- Verify Larceny-theft Rate (per 100,000)
SELECT  year,
        larceny_theft_rate,
        calc_larceny_theft_rate
FROM (
    SELECT  year,
            larceny_theft_rate,
            ROUND(larceny_theft / population * 100000, 1) AS calc_larceny_theft_rate
    FROM fbi_violent_crime_stats_2005_2019.summary
) t1
WHERE larceny_theft_rate <> calc_larceny_theft_rate;


-- Verify Motor Vehicle Theft Rate (per 100,000)
SELECT  year,
        motor_vehicle_theft_rate,
        calc_motor_vehicle_theft_rate
FROM (
    SELECT  year,
            motor_vehicle_theft_rate,
            ROUND(motor_vehicle_theft / population * 100000, 1) AS calc_motor_vehicle_theft_rate
    FROM fbi_violent_crime_stats_2005_2019.summary
) t1
WHERE motor_vehicle_theft_rate <> calc_motor_vehicle_theft_rate;



-- 
-- Population
-- 

-- Verify the state populations match between the robbery & aggravated assault tables.
-- 
-- The only discrepancy is for Colorado in 2019. But this discrepancy
-- exists in the original .xls files on the FBI website.
SELECT *
  FROM (
        SELECT rob.year,
               rob.state,
               rob.population AS rob_pop,
               agg.population AS agg_pop,
               ABS(rob.population - agg.population) AS pop_diff
        FROM fbi_violent_crime_stats_2005_2019.robbery rob
        JOIN fbi_violent_crime_stats_2005_2019.aggravated_assault agg
          ON rob.year = agg.year
         AND rob.state = agg.state
  ) pops
 WHERE rob_pop <> agg_pop;



-- 
-- Agency Count
-- 

-- Verify the state agency counts match between the robbery & aggravated assault tables.
SELECT *
  FROM (
        SELECT rob.year,
               rob.state,
               rob.agency_count AS rob_cnt,
               agg.agency_count AS agg_cnt,
               ABS(rob.agency_count - agg.agency_count) AS cnt_diff
        FROM fbi_violent_crime_stats_2005_2019.robbery rob
        JOIN fbi_violent_crime_stats_2005_2019.aggravated_assault agg
          ON rob.year = agg.year
         AND rob.state = agg.state
  ) pops
 WHERE rob_cnt <> agg_cnt;



-- 
-- Murder
-- 

-- Verify Murder Category Values Against TOTAL_MURDERS
SELECT *
  FROM (
        SELECT year,
               state,
               total_murders,
               total_firearms + knives_or_cutting_instruments + hands_fists_feet_etc + other_weapons AS calc_totalMurders
        FROM fbi_violent_crime_stats_2005_2019.Murder
  ) murderCats
 WHERE total_murders <> calc_totalMurders;


-- Verify Firearm Category Values Against TOTAL_FIREARMS;
SELECT *
  FROM (
        SELECT year,
               state,
               total_firearms,
               handguns + rifles + shotguns + firearms_type_unknown AS calc_totalFirearms
        FROM fbi_violent_crime_stats_2005_2019.Murder
  ) firearmCats
 WHERE total_firearms <> calc_totalFirearms;



-- 
-- Robbery
-- 

-- Verify Robbery Category Values Against TOTAL_ROBBERIES
SELECT *
  FROM (
        SELECT year,
               state,
               total_robberies,
               firearms + knives_or_cutting_instruments + hands_fists_feet_etc + other_weapons AS calc_totalRobberies
        FROM fbi_violent_crime_stats_2005_2019.Robbery
  ) robCats
 WHERE total_robberies <> calc_totalRobberies;



-- 
-- Aggravated Assault
-- 

-- Verify Aggravated Assault Category Values Against TOTAL_AGGRAVATED_ASSAULTS
SELECT *
  FROM (
        SELECT year,
               state,
               total_aggravated_assaults,
               firearms + knives_or_cutting_instruments + hands_fists_feet_etc + other_weapons AS calc_totalAggravatedAssaults
        FROM fbi_violent_crime_stats_2005_2019.Aggravated_Assault
  ) assaultCats
 WHERE total_aggravated_assaults <> calc_totalAggravatedAssaults;


