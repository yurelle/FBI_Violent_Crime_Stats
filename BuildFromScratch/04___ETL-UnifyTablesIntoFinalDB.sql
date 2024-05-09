-- 
-- Database: fbi_violent_crime_stats_2005_2019
-- 
CREATE DATABASE fbi_violent_crime_stats_2005_2019;
USE fbi_violent_crime_stats_2005_2019;

START TRANSACTION;

-- ------------------------------------------------


-- 
-- Create Table MURDER
-- 
CREATE TABLE MURDER (
    ID INTEGER NOT NULL PRIMARY KEY AUTO_INCREMENT,
    YEAR INTEGER NOT NULL,
    STATE VARCHAR(50) NOT NULL,
    TOTAL_MURDERS INTEGER,
    TOTAL_FIREARMS INTEGER,
    HANDGUNS INTEGER,
    RIFLES INTEGER,
    SHOTGUNS INTEGER,
    FIREARMS_TYPE_UNKNOWN INTEGER,
    KNIVES_OR_CUTTING_INSTRUMENTS INTEGER,
    HANDS_FISTS_FEET_ETC INTEGER,
    OTHER_WEAPONS INTEGER
);

-- Create Indexes
CREATE INDEX MURDER_YEAR_INDEX  ON MURDER (YEAR);
CREATE INDEX MURDER_STATE_INDEX ON MURDER (STATE);


-- 
-- Insert Values into `MURDER`
-- 
INSERT INTO MURDER
        (STATE, TOTAL_MURDERS, TOTAL_FIREARMS, HANDGUNS, RIFLES, SHOTGUNS, FIREARMS_TYPE_UNKNOWN, KNIVES_OR_CUTTING_INSTRUMENTS, HANDS_FISTS_FEET_ETC, OTHER_WEAPONS, YEAR)
 SELECT *
   FROM (
                  SELECT STATE, TOTAL_MURDERS, TOTAL_FIREARMS, HANDGUNS, RIFLES, SHOTGUNS, FIREARMS_TYPE_UNKNOWN, KNIVES_OR_CUTTING_INSTRUMENTS, HANDS_FISTS_FEET_ETC, OTHER_WEAPONS, 2005 AS YEAR FROM fbi_violent_crime_stats_2005_2019_raw_data.`2005___TABLE_20`
        UNION ALL SELECT STATE, TOTAL_MURDERS, TOTAL_FIREARMS, HANDGUNS, RIFLES, SHOTGUNS, FIREARMS_TYPE_UNKNOWN, KNIVES_OR_CUTTING_INSTRUMENTS, HANDS_FISTS_FEET_ETC, OTHER_WEAPONS, 2006 AS YEAR FROM fbi_violent_crime_stats_2005_2019_raw_data.`2006___TABLE_20`
        UNION ALL SELECT STATE, TOTAL_MURDERS, TOTAL_FIREARMS, HANDGUNS, RIFLES, SHOTGUNS, FIREARMS_TYPE_UNKNOWN, KNIVES_OR_CUTTING_INSTRUMENTS, HANDS_FISTS_FEET_ETC, OTHER_WEAPONS, 2007 AS YEAR FROM fbi_violent_crime_stats_2005_2019_raw_data.`2007___TABLE_20`
        UNION ALL SELECT STATE, TOTAL_MURDERS, TOTAL_FIREARMS, HANDGUNS, RIFLES, SHOTGUNS, FIREARMS_TYPE_UNKNOWN, KNIVES_OR_CUTTING_INSTRUMENTS, HANDS_FISTS_FEET_ETC, OTHER_WEAPONS, 2008 AS YEAR FROM fbi_violent_crime_stats_2005_2019_raw_data.`2008___TABLE_20`
        UNION ALL SELECT STATE, TOTAL_MURDERS, TOTAL_FIREARMS, HANDGUNS, RIFLES, SHOTGUNS, FIREARMS_TYPE_UNKNOWN, KNIVES_OR_CUTTING_INSTRUMENTS, HANDS_FISTS_FEET_ETC, OTHER_WEAPONS, 2009 AS YEAR FROM fbi_violent_crime_stats_2005_2019_raw_data.`2009___TABLE_20`
        UNION ALL SELECT STATE, TOTAL_MURDERS, TOTAL_FIREARMS, HANDGUNS, RIFLES, SHOTGUNS, FIREARMS_TYPE_UNKNOWN, KNIVES_OR_CUTTING_INSTRUMENTS, HANDS_FISTS_FEET_ETC, OTHER_WEAPONS, 2010 AS YEAR FROM fbi_violent_crime_stats_2005_2019_raw_data.`2010___TABLE_20`
        UNION ALL SELECT STATE, TOTAL_MURDERS, TOTAL_FIREARMS, HANDGUNS, RIFLES, SHOTGUNS, FIREARMS_TYPE_UNKNOWN, KNIVES_OR_CUTTING_INSTRUMENTS, HANDS_FISTS_FEET_ETC, OTHER_WEAPONS, 2011 AS YEAR FROM fbi_violent_crime_stats_2005_2019_raw_data.`2011___TABLE_20`
        UNION ALL SELECT STATE, TOTAL_MURDERS, TOTAL_FIREARMS, HANDGUNS, RIFLES, SHOTGUNS, FIREARMS_TYPE_UNKNOWN, KNIVES_OR_CUTTING_INSTRUMENTS, HANDS_FISTS_FEET_ETC, OTHER_WEAPONS, 2012 AS YEAR FROM fbi_violent_crime_stats_2005_2019_raw_data.`2012___TABLE_20`
        UNION ALL SELECT STATE, TOTAL_MURDERS, TOTAL_FIREARMS, HANDGUNS, RIFLES, SHOTGUNS, FIREARMS_TYPE_UNKNOWN, KNIVES_OR_CUTTING_INSTRUMENTS, HANDS_FISTS_FEET_ETC, OTHER_WEAPONS, 2013 AS YEAR FROM fbi_violent_crime_stats_2005_2019_raw_data.`2013___TABLE_20`
        UNION ALL SELECT STATE, TOTAL_MURDERS, TOTAL_FIREARMS, HANDGUNS, RIFLES, SHOTGUNS, FIREARMS_TYPE_UNKNOWN, KNIVES_OR_CUTTING_INSTRUMENTS, HANDS_FISTS_FEET_ETC, OTHER_WEAPONS, 2014 AS YEAR FROM fbi_violent_crime_stats_2005_2019_raw_data.`2014___TABLE_20`
        UNION ALL SELECT STATE, TOTAL_MURDERS, TOTAL_FIREARMS, HANDGUNS, RIFLES, SHOTGUNS, FIREARMS_TYPE_UNKNOWN, KNIVES_OR_CUTTING_INSTRUMENTS, HANDS_FISTS_FEET_ETC, OTHER_WEAPONS, 2015 AS YEAR FROM fbi_violent_crime_stats_2005_2019_raw_data.`2015___TABLE_20`
        UNION ALL SELECT STATE, TOTAL_MURDERS, TOTAL_FIREARMS, HANDGUNS, RIFLES, SHOTGUNS, FIREARMS_TYPE_UNKNOWN, KNIVES_OR_CUTTING_INSTRUMENTS, HANDS_FISTS_FEET_ETC, OTHER_WEAPONS, 2016 AS YEAR FROM fbi_violent_crime_stats_2005_2019_raw_data.`2016___TABLE_12`
        UNION ALL SELECT STATE, TOTAL_MURDERS, TOTAL_FIREARMS, HANDGUNS, RIFLES, SHOTGUNS, FIREARMS_TYPE_UNKNOWN, KNIVES_OR_CUTTING_INSTRUMENTS, HANDS_FISTS_FEET_ETC, OTHER_WEAPONS, 2017 AS YEAR FROM fbi_violent_crime_stats_2005_2019_raw_data.`2017___TABLE_20`
        UNION ALL SELECT STATE, TOTAL_MURDERS, TOTAL_FIREARMS, HANDGUNS, RIFLES, SHOTGUNS, FIREARMS_TYPE_UNKNOWN, KNIVES_OR_CUTTING_INSTRUMENTS, HANDS_FISTS_FEET_ETC, OTHER_WEAPONS, 2018 AS YEAR FROM fbi_violent_crime_stats_2005_2019_raw_data.`2018___TABLE_20`
        UNION ALL SELECT STATE, TOTAL_MURDERS, TOTAL_FIREARMS, HANDGUNS, RIFLES, SHOTGUNS, FIREARMS_TYPE_UNKNOWN, KNIVES_OR_CUTTING_INSTRUMENTS, HANDS_FISTS_FEET_ETC, OTHER_WEAPONS, 2019 AS YEAR FROM fbi_violent_crime_stats_2005_2019_raw_data.`2019___TABLE_20`
     ) allYears;


-- 
-- Correct Data Inconsistency
-- 
-- Standardize to "U.S. Virgin Islands"
UPDATE MURDER
   SET STATE = 'U.S. Virgin Islands'
 WHERE STATE = 'Virgin Islands';


-- ------------------------------------------------


-- 
-- Create Table `ROBBERY`
-- 
-- "Strong Arm" renamed to standarized term "Hands fists feet etc." to match
-- terminology used in Murder data. For some reason, the FBI uses a different term
-- for this in each of the Murder, Robbery, & Aggravated Assault data. But, they
-- all mean the same thing.
-- 
-- See:
-- FBI Defines "Personal Weapons" as "hands, fists, feet, etc."
-- https://ucr.fbi.gov/crime-in-the-u.s/2012/crime-in-the-u.s.-2012/offenses-known-to-law-enforcement/expanded-homicide/expanded_homicide_data_table_8_murder_victims_by_weapon_2008-2012.xls
-- https://ucr.fbi.gov/crime-in-the-u.s/2012/crime-in-the-u.s.-2012/tables/aggravated_assault_table_aggravated_assault_types_of_weapons_used_percent_distributioin_by_region_2012.xls
-- 
-- FBI Defines "Strong-arm" as "Hands, Fists, Feet, Etc."
-- [Page 52] https://www2.fbi.gov/ucr/handbook/ucrhandbook04.pdf
-- 
CREATE TABLE ROBBERY (
    ID INTEGER NOT NULL PRIMARY KEY AUTO_INCREMENT,
    YEAR INTEGER NOT NULL,
    STATE VARCHAR(50) NOT NULL,
    TOTAL_ROBBERIES INTEGER,
    FIREARMS INTEGER,
    KNIVES_OR_CUTTING_INSTRUMENTS INTEGER,
    HANDS_FISTS_FEET_ETC INTEGER,
    OTHER_WEAPONS INTEGER,
    AGENCY_COUNT INTEGER,
    POPULATION INTEGER
);

-- Create Indexes
CREATE INDEX ROBBERY_YEAR_INDEX  ON ROBBERY (YEAR);
CREATE INDEX ROBBERY_STATE_INDEX ON ROBBERY (STATE);


-- 
-- Insert Values into `ROBBERY`
-- 
INSERT INTO ROBBERY
        (STATE, TOTAL_ROBBERIES, FIREARMS, KNIVES_OR_CUTTING_INSTRUMENTS, HANDS_FISTS_FEET_ETC, OTHER_WEAPONS, AGENCY_COUNT, POPULATION, YEAR)
 SELECT *
   FROM (
                  SELECT STATE, TOTAL_ROBBERIES, FIREARMS, KNIVES_OR_CUTTING_INSTRUMENTS, STRONG_ARM, OTHER_WEAPONS, AGENCY_COUNT, POPULATION, 2005 AS YEAR FROM fbi_violent_crime_stats_2005_2019_raw_data.`2005___TABLE_21`
        UNION ALL SELECT STATE, TOTAL_ROBBERIES, FIREARMS, KNIVES_OR_CUTTING_INSTRUMENTS, STRONG_ARM, OTHER_WEAPONS, AGENCY_COUNT, POPULATION, 2006 AS YEAR FROM fbi_violent_crime_stats_2005_2019_raw_data.`2006___TABLE_21`
        UNION ALL SELECT STATE, TOTAL_ROBBERIES, FIREARMS, KNIVES_OR_CUTTING_INSTRUMENTS, STRONG_ARM, OTHER_WEAPONS, AGENCY_COUNT, POPULATION, 2007 AS YEAR FROM fbi_violent_crime_stats_2005_2019_raw_data.`2007___TABLE_21`
        UNION ALL SELECT STATE, TOTAL_ROBBERIES, FIREARMS, KNIVES_OR_CUTTING_INSTRUMENTS, STRONG_ARM, OTHER_WEAPONS, AGENCY_COUNT, POPULATION, 2008 AS YEAR FROM fbi_violent_crime_stats_2005_2019_raw_data.`2008___TABLE_21`
        UNION ALL SELECT STATE, TOTAL_ROBBERIES, FIREARMS, KNIVES_OR_CUTTING_INSTRUMENTS, STRONG_ARM, OTHER_WEAPONS, AGENCY_COUNT, POPULATION, 2009 AS YEAR FROM fbi_violent_crime_stats_2005_2019_raw_data.`2009___TABLE_21`
        UNION ALL SELECT STATE, TOTAL_ROBBERIES, FIREARMS, KNIVES_OR_CUTTING_INSTRUMENTS, STRONG_ARM, OTHER_WEAPONS, AGENCY_COUNT, POPULATION, 2010 AS YEAR FROM fbi_violent_crime_stats_2005_2019_raw_data.`2010___TABLE_21`
        UNION ALL SELECT STATE, TOTAL_ROBBERIES, FIREARMS, KNIVES_OR_CUTTING_INSTRUMENTS, STRONG_ARM, OTHER_WEAPONS, AGENCY_COUNT, POPULATION, 2011 AS YEAR FROM fbi_violent_crime_stats_2005_2019_raw_data.`2011___TABLE_21`
        UNION ALL SELECT STATE, TOTAL_ROBBERIES, FIREARMS, KNIVES_OR_CUTTING_INSTRUMENTS, STRONG_ARM, OTHER_WEAPONS, AGENCY_COUNT, POPULATION, 2012 AS YEAR FROM fbi_violent_crime_stats_2005_2019_raw_data.`2012___TABLE_21`
        UNION ALL SELECT STATE, TOTAL_ROBBERIES, FIREARMS, KNIVES_OR_CUTTING_INSTRUMENTS, STRONG_ARM, OTHER_WEAPONS, AGENCY_COUNT, POPULATION, 2013 AS YEAR FROM fbi_violent_crime_stats_2005_2019_raw_data.`2013___TABLE_21`
        UNION ALL SELECT STATE, TOTAL_ROBBERIES, FIREARMS, KNIVES_OR_CUTTING_INSTRUMENTS, STRONG_ARM, OTHER_WEAPONS, AGENCY_COUNT, POPULATION, 2014 AS YEAR FROM fbi_violent_crime_stats_2005_2019_raw_data.`2014___TABLE_21`
        UNION ALL SELECT STATE, TOTAL_ROBBERIES, FIREARMS, KNIVES_OR_CUTTING_INSTRUMENTS, STRONG_ARM, OTHER_WEAPONS, AGENCY_COUNT, POPULATION, 2015 AS YEAR FROM fbi_violent_crime_stats_2005_2019_raw_data.`2015___TABLE_21`
        UNION ALL SELECT STATE, TOTAL_ROBBERIES, FIREARMS, KNIVES_OR_CUTTING_INSTRUMENTS, STRONG_ARM, OTHER_WEAPONS, AGENCY_COUNT, POPULATION, 2016 AS YEAR FROM fbi_violent_crime_stats_2005_2019_raw_data.`2016___TABLE_13`
        UNION ALL SELECT STATE, TOTAL_ROBBERIES, FIREARMS, KNIVES_OR_CUTTING_INSTRUMENTS, STRONG_ARM, OTHER_WEAPONS, AGENCY_COUNT, POPULATION, 2017 AS YEAR FROM fbi_violent_crime_stats_2005_2019_raw_data.`2017___TABLE_21`
        UNION ALL SELECT STATE, TOTAL_ROBBERIES, FIREARMS, KNIVES_OR_CUTTING_INSTRUMENTS, STRONG_ARM, OTHER_WEAPONS, AGENCY_COUNT, POPULATION, 2018 AS YEAR FROM fbi_violent_crime_stats_2005_2019_raw_data.`2018___TABLE_21`
        UNION ALL SELECT STATE, TOTAL_ROBBERIES, FIREARMS, KNIVES_OR_CUTTING_INSTRUMENTS, STRONG_ARM, OTHER_WEAPONS, AGENCY_COUNT, POPULATION, 2019 AS YEAR FROM fbi_violent_crime_stats_2005_2019_raw_data.`2019___TABLE_21`
     ) allYears;


-- ------------------------------------------------


-- 
-- Create Table `AGGRAVATED_ASSAULT`
-- 
-- "Personal Weapons" renamed to standarized term "Hands fists feet etc." to match
-- terminology used in Murder data. For some reason, the FBI uses a different term
-- for this in each of the Murder, Robbery, & Aggravated Assault data. But, they
-- all mean the same thing.
-- 
-- See:
-- FBI Defines "Personal Weapons" as "hands, fists, feet, etc."
-- https://ucr.fbi.gov/crime-in-the-u.s/2012/crime-in-the-u.s.-2012/offenses-known-to-law-enforcement/expanded-homicide/expanded_homicide_data_table_8_murder_victims_by_weapon_2008-2012.xls
-- https://ucr.fbi.gov/crime-in-the-u.s/2012/crime-in-the-u.s.-2012/tables/aggravated_assault_table_aggravated_assault_types_of_weapons_used_percent_distributioin_by_region_2012.xls
-- 
-- FBI Defines "Strong-arm" as "Hands, Fists, Feet, Etc."
-- [Page 52] https://www2.fbi.gov/ucr/handbook/ucrhandbook04.pdf
-- 
CREATE TABLE AGGRAVATED_ASSAULT (
    id INTEGER NOT NULL PRIMARY KEY AUTO_INCREMENT,
    YEAR INTEGER NOT NULL,
    STATE VARCHAR(50) NOT NULL,
    TOTAL_AGGRAVATED_ASSAULTS INTEGER,
    FIREARMS INTEGER,
    KNIVES_OR_CUTTING_INSTRUMENTS INTEGER,
    HANDS_FISTS_FEET_ETC INTEGER,
    OTHER_WEAPONS INTEGER,
    AGENCY_COUNT INTEGER,
    POPULATION INTEGER
);

-- Create Indexes
CREATE INDEX AGGRAVATED_ASSAULT_YEAR_INDEX  ON AGGRAVATED_ASSAULT (YEAR);
CREATE INDEX AGGRAVATED_ASSAULT_STATE_INDEX ON AGGRAVATED_ASSAULT (STATE);


-- 
-- Insert Values into `AGGRAVATED_ASSAULT`
-- 
INSERT INTO AGGRAVATED_ASSAULT
        (STATE, TOTAL_AGGRAVATED_ASSAULTS, FIREARMS, KNIVES_OR_CUTTING_INSTRUMENTS, HANDS_FISTS_FEET_ETC, OTHER_WEAPONS, AGENCY_COUNT, POPULATION, YEAR)
 SELECT *
   FROM (
                  SELECT STATE, TOTAL_AGGRAVATED_ASSAULTS, FIREARMS, KNIVES_OR_CUTTING_INSTRUMENTS, PERSONAL_WEAPONS, OTHER_WEAPONS, AGENCY_COUNT, POPULATION, 2005 AS YEAR FROM fbi_violent_crime_stats_2005_2019_raw_data.`2005___TABLE_22`
        UNION ALL SELECT STATE, TOTAL_AGGRAVATED_ASSAULTS, FIREARMS, KNIVES_OR_CUTTING_INSTRUMENTS, PERSONAL_WEAPONS, OTHER_WEAPONS, AGENCY_COUNT, POPULATION, 2006 AS YEAR FROM fbi_violent_crime_stats_2005_2019_raw_data.`2006___TABLE_22`
        UNION ALL SELECT STATE, TOTAL_AGGRAVATED_ASSAULTS, FIREARMS, KNIVES_OR_CUTTING_INSTRUMENTS, PERSONAL_WEAPONS, OTHER_WEAPONS, AGENCY_COUNT, POPULATION, 2007 AS YEAR FROM fbi_violent_crime_stats_2005_2019_raw_data.`2007___TABLE_22`
        UNION ALL SELECT STATE, TOTAL_AGGRAVATED_ASSAULTS, FIREARMS, KNIVES_OR_CUTTING_INSTRUMENTS, PERSONAL_WEAPONS, OTHER_WEAPONS, AGENCY_COUNT, POPULATION, 2008 AS YEAR FROM fbi_violent_crime_stats_2005_2019_raw_data.`2008___TABLE_22`
        UNION ALL SELECT STATE, TOTAL_AGGRAVATED_ASSAULTS, FIREARMS, KNIVES_OR_CUTTING_INSTRUMENTS, PERSONAL_WEAPONS, OTHER_WEAPONS, AGENCY_COUNT, POPULATION, 2009 AS YEAR FROM fbi_violent_crime_stats_2005_2019_raw_data.`2009___TABLE_22`
        UNION ALL SELECT STATE, TOTAL_AGGRAVATED_ASSAULTS, FIREARMS, KNIVES_OR_CUTTING_INSTRUMENTS, PERSONAL_WEAPONS, OTHER_WEAPONS, AGENCY_COUNT, POPULATION, 2010 AS YEAR FROM fbi_violent_crime_stats_2005_2019_raw_data.`2010___TABLE_22`
        UNION ALL SELECT STATE, TOTAL_AGGRAVATED_ASSAULTS, FIREARMS, KNIVES_OR_CUTTING_INSTRUMENTS, PERSONAL_WEAPONS, OTHER_WEAPONS, AGENCY_COUNT, POPULATION, 2011 AS YEAR FROM fbi_violent_crime_stats_2005_2019_raw_data.`2011___TABLE_22`
        UNION ALL SELECT STATE, TOTAL_AGGRAVATED_ASSAULTS, FIREARMS, KNIVES_OR_CUTTING_INSTRUMENTS, PERSONAL_WEAPONS, OTHER_WEAPONS, AGENCY_COUNT, POPULATION, 2012 AS YEAR FROM fbi_violent_crime_stats_2005_2019_raw_data.`2012___TABLE_22`
        UNION ALL SELECT STATE, TOTAL_AGGRAVATED_ASSAULTS, FIREARMS, KNIVES_OR_CUTTING_INSTRUMENTS, PERSONAL_WEAPONS, OTHER_WEAPONS, AGENCY_COUNT, POPULATION, 2013 AS YEAR FROM fbi_violent_crime_stats_2005_2019_raw_data.`2013___TABLE_22`
        UNION ALL SELECT STATE, TOTAL_AGGRAVATED_ASSAULTS, FIREARMS, KNIVES_OR_CUTTING_INSTRUMENTS, PERSONAL_WEAPONS, OTHER_WEAPONS, AGENCY_COUNT, POPULATION, 2014 AS YEAR FROM fbi_violent_crime_stats_2005_2019_raw_data.`2014___TABLE_22`
        UNION ALL SELECT STATE, TOTAL_AGGRAVATED_ASSAULTS, FIREARMS, KNIVES_OR_CUTTING_INSTRUMENTS, PERSONAL_WEAPONS, OTHER_WEAPONS, AGENCY_COUNT, POPULATION, 2015 AS YEAR FROM fbi_violent_crime_stats_2005_2019_raw_data.`2015___TABLE_22`
        UNION ALL SELECT STATE, TOTAL_AGGRAVATED_ASSAULTS, FIREARMS, KNIVES_OR_CUTTING_INSTRUMENTS, PERSONAL_WEAPONS, OTHER_WEAPONS, AGENCY_COUNT, POPULATION, 2016 AS YEAR FROM fbi_violent_crime_stats_2005_2019_raw_data.`2016___TABLE_14`
        UNION ALL SELECT STATE, TOTAL_AGGRAVATED_ASSAULTS, FIREARMS, KNIVES_OR_CUTTING_INSTRUMENTS, PERSONAL_WEAPONS, OTHER_WEAPONS, AGENCY_COUNT, POPULATION, 2017 AS YEAR FROM fbi_violent_crime_stats_2005_2019_raw_data.`2017___TABLE_22`
        UNION ALL SELECT STATE, TOTAL_AGGRAVATED_ASSAULTS, FIREARMS, KNIVES_OR_CUTTING_INSTRUMENTS, PERSONAL_WEAPONS, OTHER_WEAPONS, AGENCY_COUNT, POPULATION, 2018 AS YEAR FROM fbi_violent_crime_stats_2005_2019_raw_data.`2018___TABLE_22`
        UNION ALL SELECT STATE, TOTAL_AGGRAVATED_ASSAULTS, FIREARMS, KNIVES_OR_CUTTING_INSTRUMENTS, PERSONAL_WEAPONS, OTHER_WEAPONS, AGENCY_COUNT, POPULATION, 2019 AS YEAR FROM fbi_violent_crime_stats_2005_2019_raw_data.`2019___TABLE_22`
     ) allYears;


-- ------------------------------------------------


-- 
-- Create Table `SUMMARY`
-- 
CREATE TABLE SUMMARY (
    ID INTEGER NOT NULL PRIMARY KEY AUTO_INCREMENT,
    YEAR VARCHAR(50) NOT NULL,
    POPULATION INTEGER,
    VIOLENT_CRIME INTEGER,
    VIOLENT_CRIME_RATE DOUBLE,
    MURDER_AND_NONNEGLIGENT_MANSLAUGHTER INTEGER,
    MURDER_AND_NONNEGLIGENT_MANSLAUGHTER_RATE DOUBLE,
    RAPE_REVISED_DEFINITION INTEGER,
    RAPE_REVISED_DEFINITION_RATE DOUBLE,
    RAPE_LEGACY_DEFINITION INTEGER,
    RAPE_LEGACY_DEFINITION_RATE DOUBLE,
    ROBBERY INTEGER,
    ROBBERY_RATE DOUBLE,
    AGGRAVATED_ASSAULT INTEGER,
    AGGRAVATED_ASSAULT_RATE DOUBLE,
    PROPERTY_CRIME INTEGER,
    PROPERTY_CRIME_RATE DOUBLE,
    BURGLARY INTEGER,
    BURGLARY_RATE DOUBLE,
    LARCENY_THEFT INTEGER,
    LARCENY_THEFT_RATE DOUBLE,
    MOTOR_VEHICLE_THEFT INTEGER,
    MOTOR_VEHICLE_THEFT_RATE DOUBLE
);

-- Create Indexes
CREATE INDEX SUMMARY_YEAR_INDEX ON SUMMARY (YEAR);


-- 
-- Insert Values into `SUMMARY`
-- 
INSERT INTO SUMMARY(
    ID,
    YEAR,
    POPULATION,
    VIOLENT_CRIME,
    VIOLENT_CRIME_RATE,
    MURDER_AND_NONNEGLIGENT_MANSLAUGHTER,
    MURDER_AND_NONNEGLIGENT_MANSLAUGHTER_RATE,
    RAPE_REVISED_DEFINITION,
    RAPE_REVISED_DEFINITION_RATE,
    RAPE_LEGACY_DEFINITION,
    RAPE_LEGACY_DEFINITION_RATE,
    ROBBERY,
    ROBBERY_RATE,
    AGGRAVATED_ASSAULT,
    AGGRAVATED_ASSAULT_RATE,
    PROPERTY_CRIME,
    PROPERTY_CRIME_RATE,
    BURGLARY,
    BURGLARY_RATE,
    LARCENY_THEFT,
    LARCENY_THEFT_RATE,
    MOTOR_VEHICLE_THEFT,
    MOTOR_VEHICLE_THEFT_RATE
)
 SELECT ID,
     YEAR,
     POPULATION,
     VIOLENT_CRIME,
     VIOLENT_CRIME_RATE,
     MURDER_AND_NONNEGLIGENT_MANSLAUGHTER,
     MURDER_AND_NONNEGLIGENT_MANSLAUGHTER_RATE,
     RAPE_REVISED_DEFINITION,
     RAPE_REVISED_DEFINITION_RATE,
     RAPE_LEGACY_DEFINITION,
     RAPE_LEGACY_DEFINITION_RATE,
     ROBBERY,
     ROBBERY_RATE,
     AGGRAVATED_ASSAULT,
     AGGRAVATED_ASSAULT_RATE,
     PROPERTY_CRIME,
     PROPERTY_CRIME_RATE,
     BURGLARY,
     BURGLARY_RATE,
     LARCENY_THEFT,
     LARCENY_THEFT_RATE,
     MOTOR_VEHICLE_THEFT,
     MOTOR_VEHICLE_THEFT_RATE
FROM fbi_violent_crime_stats_2005_2019_raw_data.`2019___TABLE_1`;











-- ------------------------------------------------


COMMIT;


