# FBI_Violent_Crime_Weapon_Stats
A manual ETL of the primary "by weapon" data from the FBI's yearly violent crime reports (years 2005 through 2019), as well as the 2019 summary table containing years 2000 - 2019. Even though I created this ETL in May of 2024, at the time of writing, the most recent data in the FBI's dataset is for 2019.

The original data can be found here: https://ucr.fbi.gov/crime-in-the-u.s

Click on a given year, and then choose the "Crime in the U.S. <year>" link, not the "Preliminary Report". Then, click the "Violent Crime" link under the "Offenses Known to Law Enforcement" section. The data tables will be in a long list on the right side of the page.

Example:
https://ucr.fbi.gov/crime-in-the-u.s/2019/crime-in-the-u.s.-2019/topic-pages/violent-crime

## Example Queries
Some example queries are provided, which demonstrate several simple views into this dataset that probably cover 80% of what people want from this project.

## Crime Rate Units
The "Rate" columns in the Summary table are in the unit of "Per 100,000 people"; ex: "Number of Murders per 100,000 people".

## Summary Table vs Detail Tables
**TLDR:**

The summary table should be used when determining national crime totals or overall crime rates. The detail tables should be used when determining the distribution of weapon type used, or more specific crime rates that do not exist in the summary table (ex: for a specific state or weapon type).

**Full explaination:**

The data for yearly population and crime totals do not match between the summary table and the aggregate totals of the detail tables. This is present in the original data from the FBI, and is intentional.

The detail tables provide the raw data which was reported to the FBI from the various agencies across the country. These tables contain more specific data than the summary table; including breakdown by State & weapon used. However, not all agencies reported all data for all years. Thus, the population for each state in a given year is the total population of only those agency districts which reported their data; excluding the population of the districts which did not report their data.

The summary table attempts to estimate the total number of crimes in the entire country (including those districts which did not report). For this reason the population for each year is according to the US Census, and is interpolated between the census years. The crime totals (and thus, their associated crime rates) are the result of taking the raw data that was reported by the various agencies, and attempting to determine estimates to fill in the gaps in that data. The full estimation process they used is more complicated than a simple scaling factor based upon population sizes. For a more detailed breakdown of the estimation process, see:
https://ucr.fbi.gov/crime-in-the-u.s/2019/crime-in-the-u.s.-2019/tables/table-1/table-1-data-declaration

So, if you're running queries trying to find the breakdown of crimes by weapon, you have to use the detail tables, since the summary table does not include that information. Given that the missing districts are basically random, the macro trends in the statistical distribution of weapon type should be mostly consistent with these missing districts, as can be seen with minor variance in calculated crime rates between the summary & detail tables (see below).

But, if you are running queries to determine total number of crimes on the national level, then you should use the summary table, since the aggregate totals of the detail tables do not include the entire country and will under-report the totals. Also, if using the detail tables for raw totals, the data may not be consistent year to year, due to the fluctuation in which districts did or did not report in any given year. For example, in New York's reported data, from 2005 to 2012, the year-to-year crime totals seem relatively consistent, then in 2013, their robbery & aggravated assault totals doubled, and then remained relatively consistent at this higher rate, from 2013 through 2019. However, if you look at New York's reported populations for these years, you will notice that the population also roughly doubled. The agency count meanders rather wildly year-to-year, so you can't judge by that, but the population makes it clear that the sudden change was one of increased reporting, rather than increased crime.

However, if you are querying for crime rates, you could use either the summary table, or calculate the rate yourself on the raw data. However, while the resulting crime rates are very close, they are not the same (Robbery: all within 4% \[most are within 3%\]; Aggravated Assault: all within 6% \[half are within 2%\]). Since official sources will probably use the summary data's crime rate numbers, and since the murder tables do not include a population column from which to derrive the rate, for consistency, you should probably use the summary table. But, do whatever you want. I'm not your dad.

See: `CompareSummaryCrimeRateToDetailData.sql` in the ExampleQueries folder for queries to demonstrate the crime rate variance.


## "..._RAW_DATA" Schema
The "fbi_violent_crime_stats_2005_2019_raw_data" schema is created as part of the ETL process, and includes the raw data that is read in from the hand-fixed CSV files. It is retained after the ETL, in case you wish to inspect the raw data, or implement your own ETL process.

Once the ETL process is complete, the final output schema "fbi_violent_crime_stats_2005_2019" (i.e. without the "_RAW_DATA" suffix) has no dependencies upon the "..._RAW_DATA" schema. If you have no use for it, then you can drop the "..._RAW_DATA" schema without causing any harm to the final output schema.

# Methodology
See the "InstructionsToReproduce.txt" file for a breakdown of the steps I used to transform & unify this data, in the form of step by step instructions to do it yourself.

However, the excel files, and the resulting automated CSV data, are horrible, and require a TON of manual cleanup. I tried to incorporate as much of that as possible into the automation, but much of it was still done by hand. I highly recommend that you only start from scratch if your goal is to verify the accuracy of the hand-fixed csv files. But, if your goal is to ingest the data into some other format, I highly recommend that you start with the hand-fixed csv files, or modify the output of the java code, which incorporates additional cleanup of its input.

This is my own manual conversion of the FBI spresheets into a MySQL Relational Database, which required both custom automation code & lots of manual corrections. I've done my best to verify the data, but there might be some errors in my ETL processing.

In the end:
* The state populations are consistent between the Robbery & Aggravated Assault Tables, for all states in all years, except for Colorado in 2019, where the discrepancy exists in the original FBI data.
* The state agency counts are consistent between the Robbery & Aggravated Assault Tables, for all states in all years, except for Colorado in 2019, where the discrepancy exists in the original FBI data.
* The original FBI Murder tables did not provide state population or agency count. I don't know why.
* The "TOTAL_MURDERS" column matches the sum of the "TOTAL_FIREARMS", "KNIVES_OR_CUTTING_INSTRUMENTS", "HANDS_FISTS_FEET_ETC", & "OTHER_WEAPONS" columns, for all states in all years.
* The "TOTAL_FIREARMS" column matches the sum of the "HANDGUNS", "RIFLES", "SHOTGUNS", & "FIREARMS_TYPE_UNKNOWN" columns, for all states in all years.
* The "TOTAL_ROBBERIES" column matches the sum of the "FIREARMS", "KNIVES_OR_CUTTING_INSTRUMENTS", "HANDS_FISTS_FEET_ETC", & "OTHER_WEAPONS" columns, for all states in all years.
* The "TOTAL_AGGRAVATED_ASSAULTS" column matches the sum of the "FIREARMS", "KNIVES_OR_CUTTING_INSTRUMENTS", "HANDS_FISTS_FEET_ETC", & "OTHER_WEAPONS" columns, for all states in all years.
* The "VIOLENT_CRIME" raw total column of the Violent Crime Summary table, matches the sum of the "MURDER_AND_NONNEGLIGENT_MANSLAUGHTER", "RAPE_LEGACY_DEFINITION", "ROBBERY", & "AGGRAVATED_ASSAULT" columns, for all years.
* All of the "RATE" columns in the Violent Crime Summary table, match the calculated "per 100,000" rate of their corresponding raw total column and the population column in the same table for the same year, for all years; including the columns not related to the "Big 3" stats of Murder, Robbery, & Aggravated Assault.



# Omitted Data

## Rape
While the FBI's definition of "Violent Crime" includes rape, the FBI's data does not include any information on the presence nor type of weapons used during rape or rape attempts. Since the purpose of this dataset is the break down of weapon types used in violent crime, there is no associated data for rape in the FBI reports, and thus rape is excluded from the more precise data, but the summary table still contains the yearly totals.

## Years 2000 - 2004
Data for years 2000 - 2004 is available from the FBI, but the data is in percentage distribution rather than raw totals, and thus is incompatible with the data from the future years. So, 2000 - 2004 were omitted from the detail tables, so there is not "by weapon" or "by state" data for these years.

However, the 2019___Table_1 summary table does contain summary data for years 2000 - 2004.


# Data Anomalies

## "Strong Arm", "Personal Weapons", & "Hands fists feet etc."
The columns "Strong Arm" & "Personal Weapons" (from the Robbery & Aggravated Assault tables, respectively) have been renamed to the standarized term "Hands fists feet etc." to match the terminology used in the Murder data. For some reason, the FBI uses a different term for this in each of the Murder, Robbery, & Aggravated Assault data. But, they all mean the same thing. So, I changed them all to match, to make it clear that they are all referring to the same thing.

See:
1. FBI Defines "Personal Weapons" as "hands, fists, feet, etc."
* https://ucr.fbi.gov/crime-in-the-u.s/2012/crime-in-the-u.s.-2012/offenses-known-to-law-enforcement/expanded-homicide/expanded_homicide_data_table_8_murder_victims_by_weapon_2008-2012.xls

* https://ucr.fbi.gov/crime-in-the-u.s/2012/crime-in-the-u.s.-2012/tables/aggravated_assault_table_aggravated_assault_types_of_weapons_used_percent_distributioin_by_region_2012.xls


2. FBI Defines "Strong-arm" as "Hands, Fists, Feet, Etc."
* [Page 52] https://www2.fbi.gov/ucr/handbook/ucrhandbook04.pdf

## 2016
For some reason, in 2016, the FBI produced a different set of data with fewer tables. The three tables that we need for this dataset were fully included, but their indexes were different. They correspond as follows:
* 2016 Table 12 => ALL_YEARS Table 20
* 2016 Table 13 => ALL_YEARS Table 21
* 2016 Table 14 => ALL_YEARS Table 22

## Colorado in 2019
There is a discrepancy in both the stated population & agency count between the Robbery & Aggravated Assault tables for Colorado in 2019. But both of these discrepancies exists in the original .xls files on the FBI website. The difference in agency count is off by one. So, it appears that an agency in Colorado with over 100,000 people, reported their Aggravated Assault data, but not their Robbery data, for that year.

This discrepancy was the reason that I didn't break out states into a central lookup table with the state's name & population.
