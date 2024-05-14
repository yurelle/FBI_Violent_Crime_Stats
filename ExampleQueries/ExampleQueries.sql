-- Yearly Violent Crime Rates (Summary Table)
--
-- Murder
-- Rape
-- Robbery
-- Aggravated Assault
SELECT year,
       violent_crime_rate                        AS Total_Violent_Crime_Rate,
       murder_and_nonnegligent_manslaughter_rate AS Murder_Rate,
       rape_legacy_definition_rate               AS Rape_Rate,
       Robbery_Rate                              AS Robbery_Rate,
       Aggravated_Assault_Rate                   AS Aggravated_Assault_Rate
  FROM fbi_violent_crime_stats_2005_2019.Summary;



-- Yearly Violent Crime by Weapon
-- 
-- Murder
-- Robbery
-- Aggravated Assault
WITH MurderWeapons AS (
    SELECT year,
           SUM(total_firearms)                AS Firearms,
           SUM(knives_or_cutting_instruments) AS Knives,
           SUM(hands_fists_feet_etc)          AS Hands,
           SUM(other_weapons)                 AS Other
      FROM fbi_violent_crime_stats_2005_2019.Murder
     GROUP BY year
),
RobberyWeapons AS (
    SELECT year,
           SUM(firearms)                      AS Firearms,
           SUM(knives_or_cutting_instruments) AS Knives,
           SUM(hands_fists_feet_etc)          AS Hands,
           SUM(other_weapons)                 AS Other
      FROM fbi_violent_crime_stats_2005_2019.Robbery
     GROUP BY year
),
AggravatedAssaultWeapons AS (
    SELECT year,
           SUM(firearms)                      AS Firearms,
           SUM(knives_or_cutting_instruments) AS Knives,
           SUM(hands_fists_feet_etc)          AS Hands,
           SUM(other_weapons)                 AS Other
      FROM fbi_violent_crime_stats_2005_2019.Aggravated_Assault
     GROUP BY year
)
SELECT murder.year,
       murder.firearms + robbery.firearms + aggAss.firearms AS Firearms,
       murder.knives   + robbery.knives   + aggAss.knives   AS knives_or_cutting_instruments,
       murder.hands    + robbery.hands    + aggAss.hands    AS hands_fists_feet_etc,
       murder.other    + robbery.other    + aggAss.other    AS other_weapons
  FROM MurderWeapons murder
  JOIN RobberyWeapons robbery
    ON murder.year = robbery.year
  JOIN AggravatedAssaultWeapons aggAss
    ON murder.year = aggAss.year;



-- Yearly Murders by Weapon
SELECT year,
       SUM(total_murders)                 AS Total_Murders,
       SUM(total_firearms)                AS Firearms,
       SUM(knives_or_cutting_instruments) AS Knives_Or_Cutting_Instruments,
       SUM(hands_fists_feet_etc)          AS Hands_Fists_Feet_Etc,
       SUM(other_weapons)                 AS Other
  FROM fbi_violent_crime_stats_2005_2019.Murder
 GROUP BY year;



-- Yearly Firearm Murders by Type of Firearm
SELECT year,
       SUM(total_firearms)        AS Total_Firearm_Murders,
       SUM(handguns)              AS Handguns,
       SUM(rifles)                AS Rifles,
       SUM(shotguns)              AS Shotguns,
       SUM(firearms_type_unknown) AS Firearm_Type_Unknown
  FROM fbi_violent_crime_stats_2005_2019.Murder
 GROUP BY year;



-- Yearly Murders by Weapon For A Specific State
SELECT year,
       total_murders                 AS Murders,
       total_firearms                AS Firearms,
       knives_or_cutting_instruments AS Knives_Or_Cutting_Instruments,
       hands_fists_feet_etc          AS Hands_Fists_Feet_Etc,
       other_weapons                 AS Other
  FROM fbi_violent_crime_stats_2005_2019.Murder
 WHERE state = 'New York'; -- Case Sensitive



-- Yearly Robberies by Weapon
SELECT year,
       SUM(total_robberies)               AS Total_Robberies,
       SUM(firearms)                      AS Firearms,
       SUM(knives_or_cutting_instruments) AS Knives_Or_Cutting_Instruments,
       SUM(hands_fists_feet_etc)          AS Hands_Fists_Feet_Etc,
       SUM(other_weapons)                 AS Other
  FROM fbi_violent_crime_stats_2005_2019.Robbery
 GROUP BY year;



-- Yearly Robberies by Weapon For A Specific State
SELECT year,
       total_robberies               AS Total_Robberies,
       firearms                      AS Firearms,
       knives_or_cutting_instruments AS Knives_Or_Cutting_Instruments,
       hands_fists_feet_etc          AS Hands_Fists_Feet_Etc,
       other_weapons                 AS Other
  FROM fbi_violent_crime_stats_2005_2019.Robbery
 WHERE state = 'New York'; -- Case Sensitive



-- Yearly Aggravated Assaults by Weapon
SELECT year,
       SUM(total_aggravated_assaults)     AS Total_Aggravated_Assault,
       SUM(firearms)                      AS Firearms,
       SUM(knives_or_cutting_instruments) AS Knives_Or_Cutting_Instruments,
       SUM(hands_fists_feet_etc)          AS Hands_Fists_Feet_Etc,
       SUM(other_weapons)                 AS Other
  FROM fbi_violent_crime_stats_2005_2019.Aggravated_Assault
 GROUP BY year;



-- Yearly Aggravated Assaults by Weapon For A Specific State
SELECT year,
       population,
       agency_count,
       total_aggravated_assaults     AS Total_Aggravated_Assault,
       firearms                      AS Firearms,
       knives_or_cutting_instruments AS Knives_Or_Cutting_Instruments,
       hands_fists_feet_etc          AS Hands_Fists_Feet_Etc,
       other_weapons                 AS Other
  FROM fbi_violent_crime_stats_2005_2019.Aggravated_Assault
 WHERE state = 'New York'; -- Case Sensitive






