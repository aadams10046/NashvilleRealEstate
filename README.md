# Data Analyst Portfolio
## Nashville Real Estate Project
This is an ongoing project currently for cleaning and evaluating Nashville Housing Market Data as collected [here](https://github.com/aadams10046/NashvilleRealEstate/blob/main/Nashville%20Housing%20Data%20for%20Data%20Cleaning.csv). Data visualizations in Tableau available [here](https://public.tableau.com/app/profile/alexander.adams3449).

## Technical Skills Utilized
* SQL (specifically SQLite) for cleaning and aggregating a large dataset

## Process
Using the dataset [here](https://github.com/aadams10046/NashvilleRealEstate/blob/main/Nashville%20Housing%20Data%20for%20Data%20Cleaning.csv) I created a table in DB Browser for SQLite based on the dataset. Then, I used SQLite to insert addresses into null address spaces where the uniqueID was different but the parcelID was the same (i.e. information in the dataset showed the address of some other null addres in the dataset). Next, I split or combined a variety of column values in the dataset to more easily perform aggregate functions on them later on. After that I performed a variety of aggregate functions on the dataset to create a number of tables useful for data visualizations or reference by real estate professionals/home builders/home buyers in Nashville during this time period.

## Full SQL Code with comments [here](https://github.com/aadams10046/NashvilleRealEstate/blob/main/Cleaner.sql)

