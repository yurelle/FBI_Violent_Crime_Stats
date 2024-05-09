# Instructions To Reproduce This Data
The original excel files, downloaded from the FBI website are provided in the "BuildFromScratch/orig_excel_from_FBI" folder. The filenames have been standardized to allow easy consumption by the automation code.

These steps require a MySQL database. The easiest way to get one set up is to install XAMPP (it's free & open-source), which automates the install, and provides a easy-to-use control panel to manage the various services & to open an instance of PHP My Admin, which you can use to interact with the MySQL database, and execute queries.

## Steps:
If you want to build all the way from scratch and start with the original .xls fils from the FBI, then start at step 1. Otherwise, I have provided a pre-built CREATE_RAW_DB.sql, so if you wish, you can skip straight to step 3, and use the provided checkpoint.

1. Execute powershell script "XLS-to-CSV.ps1" from the folder directly containing the folder "orig_excel_from_FBI" ("BuildFromScratch" by default) to convert all of the XLS files into CSV.

2. Hand clean all of the CSV files, one-by-one. Find & remove all of the superscript numbers which got converted to regular numbers in the CSV export, and have thus corrupted the data values. Remove all the extra cells at the end of each row, caused by random cells in the XLS files that contain nothing but spaces, scattered around the spredsheet. Remove excess empty rows at the end of the files, caused by the same thing. Make sure that all rows have the same number of cells after you trim the trailing ones; the last data value on a row should not have a comma after it. Ensure that all the footer notes have double quotes (") around them (i.e. their first data cell of the row); the Converter uses them to detect the end of the data. And other stuff that I've forgotten. This really was a nightmare. But whenever possible, I incorporated fixes into the automated code, so maybe it won't be as horrible for you as it was for me.

3. Run "Converter.java", to read the CSV files, and generate "CREATE_RAW_DB.sql". Rename java file "02___Converter.java" back to match it's class name "Converter.java". Then compile & run it. This code uses nothing but the standard JDK library, so you should be able to run it from any v11+ JRE. It also opens a browse dialog for you to choose the CSV file directory, so you should be able to run it from anywhere, if you wish to compile it somewhere else, to not contaminate the repo directory. It will save the generated "CREATE_RAW_DB.sql" file in the specified CSV folder. It will also abort if it detects that the output file is already present.

4. Execute the contents of "CREATE_RAW_DB.sql" against the MySQL database. This will build the raw data schema which contains a separate table for each CSV file, and populates them with their corresponding CSV data.

5. Execute the contents of "ETL-UnifyTablesIntoFinalDB.sql" against the database. This will create the official output database, and perform the final transformations to convert the raw data into the structure & format of the output database. It also performs a few minor data corrections, such as the 2016 table index, the "Personal Weapons"/"Strong-Arm" naming variance, and standardizing the name of the "U.S. Virgin Islands" from 2 different variants; See README.md for more details.

6. Execute the contents of "RawDataValidationTests.sql" against the MySQL database. This will perform some simple data verification tests. These queries are designed so that they will return empty result sets if they pass; i.e. they only return rows which violate the data check. There are 2 expected failures of these tests: Both are for Colorado in 2019. See the README.md for more details.


## How to Execute PowerShell Script
To open powershell, you can open windows explorer to the directory containing the files, make sure no files are selected, then hold shift, and right click on the empty space inside the folder area, and select "Open PowerShell Window here". Or, open the start menu and search for PowerShell, and open it there, but PowerShell will default to your user directory, and you will have to navigate to your folder location via "cd" commands.

Apparently running scripts is disabled by the default windows security policy. So, to run this script, you have to manually bypass this restriction. To do so temporarily, use the following command. This will not save any permanent changes to the security policy. It allows the specified script to execute once.

Navigate to the folder containing the excel files, and run:

`powershell -ExecutionPolicy Bypass -File .\01___XLS-to-CSV.ps1`


## Excel Trusted Sources
By default, excell only trusts its own install folders as trusted sources of documents, so the scripts call to open these files will fail. You will need to manually add the directory containing the spredsheets to excel's trusted locations, or move the files into an existing trusted location.

Steps to add a new trusted location in Excel:
1. File > Options
2. Trust Center > Trust Center Settings
3. Trusted Locations > Add New Location

You can remove it from the same menu, after the script has finished excuting.


## Blocked File
If the script still doesn't work, you may also have to unblock the files. Right click on one of the excel files that didn't work, and go to properties, and look for the following message at the bottom of the properties window: "This file came from another computer and might be blocked to help protect this computer.", with a checkbox next to it, labeled "Unblock". You can go one-by-one and unblock the files through this properties menu, or you can do it with a powershell command.

Navigate to the folder containing the excel files, and run:

`dir | Unblock-File`
