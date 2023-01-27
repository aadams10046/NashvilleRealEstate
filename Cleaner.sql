/*
Before you read this code, it is important to understand all of this was written in SQLite, so the commands may be different than you may expect from other verions of SQL.
Some specific examples of this disconnect are the use of IFNULL instead of ISNULL or INSTR instead of CHARINDEX in my SQLite queries vs. SQL Server queries.
Also, it is important to look at the formatting of the .csv file being used to populate the data in this database before reading the code, as much of the work done here is to clean up the messiness of that formatting.
*/

--Populate Property Addresses where NULL: ParcelID is unique to the property, null addresses with the same ParcelID as Non-Null addresses should be updated to the same, non-Null address
SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, IFNULL(a.PropertyAddress, b.PropertyAddress) 
FROM Housing_Data a
JOIN Housing_Data b 
	ON a.ParcelID = b.ParcelID AND a.UniqueID <> b.UniqueID
WHERE a.PropertyAddress IS NULL;

UPDATE Housing_Data
SET PropertyAddress = IFNULL(a.PropertyAddress, b.PropertyAddress)
FROM Housing_Data a
JOIN Housing_Data b ON a.ParcelID = b.ParcelID AND a.UniqueID <> b.UniqueID
WHERE a.PropertyAddress IS NULL;

SELECT * FROM Housing_Data WHERE PropertyAddress IS NULL;

--Split Property Address into two columns: address and city and join to original table
SELECT PropertyAddress, OwnerAddress FROM Housing_Data;

SELECT SUBSTRING(PropertyAddress, 1, INSTR(PropertyAddress, ',')-1) AS address,
SUBSTRING(PropertyAddress, INSTR(PropertyAddress, ',')+1, LENGTH(PropertyAddress)) AS city,
PropertyAddress
FROM Housing_Data;

ALTER TABLE Housing_Data
ADD PropertyAddressOnly text;

UPDATE Housing_Data
SET PropertyAddressOnly = SUBSTRING(PropertyAddress, 1, INSTR(PropertyAddress, ',')-1);

ALTER TABLE Housing_Data
ADD PropertyAddressOnlyCity text;

UPDATE Housing_Data
SET PropertyAddressOnlyCity = SUBSTRING(PropertyAddress, INSTR(PropertyAddress, ',')+1, LENGTH(PropertyAddress)) ;

SELECT SUBSTRING(OwnerAddress, 1, INSTR(OwnerAddress, ',')-1) AS address,
SUBSTRING(OwnerAddress, INSTR(OwnerAddress, ',')+1, LENGTH(PropertyAddress)) AS city,
OwnerAddress
FROM Housing_Data;

ALTER TABLE Housing_Data
ADD OwnerAddressOnly text;

UPDATE Housing_Data
SET OwnerAddressOnly = SUBSTRING(OwnerAddress, 1, INSTR(OwnerAddress, ',')-1);

ALTER TABLE Housing_Data
ADD OwnerAddressOnlyCity text;

UPDATE Housing_Data
SET OwnerAddressOnlyCity = SUBSTRING(OwnerAddress, INSTR(OwnerAddress, ',')+1, LENGTH(PropertyAddress));

SELECT PropertyAddress, PropertyAddressOnly, PropertyAddressOnlyCity, OwnerAddress, OwnerAddressOnly, OwnerAddressOnlyCity FROM Housing_Data;

--Split Date of sale into separate columns for date and year and join to original table
SELECT  SaleDate,
SUBSTRING(SaleDate, 1, INSTR(SaleDate, ',')-1) AS SaleDateDate,
SUBSTRING(SaleDate, INSTR(SaleDate, ',')+1, LENGTH(SaleDate)) As SaleDateYear
FROM Housing_Data;

ALTER TABLE Housing_Data
ADD SaleDateDate text;

UPDATE Housing_Data
SET SaleDateDate = SUBSTRING(SaleDate, 1, INSTR(SaleDate, ',')-1);

ALTER TABLE Housing_Data
ADD SaleDateYear text;

UPDATE Housing_Data
SET SaleDateYear = SUBSTRING(SaleDate, INSTR(SaleDate, ',')+1, LENGTH(SaleDate)) ;

SELECT SaleDate, SaleDateYear, SaleDateDate FROM Housing_Data;

--Combine FullBath and HalfBath in TotalBaths and Join to original table
SELECT FullBath, 
HalfBath,
(CAST(HalfBath AS Real) * 0.5 + CAST(FullBath AS Real)) AS BathCount
FROM Housing_Data;

ALTER TABLE Housing_Data
ADD BathCount real;

UPDATE Housing_Data
SET BathCount = CAST(HalfBath AS Real) * 0.5 + CAST(FullBath AS Real);

SELECT * FROM Housing_Data;

--Find Average Price of each landuse type by land use type by year of sale and by city by Year of sale
SELECT LandUse, SaleDateYear, AVG(SalePrice)
FROM Housing_Data
GROUP BY 1, 2
ORDER BY 1;

SELECT LandUse, AVG(SalePrice)
FROM Housing_Data
GROUP BY 1
ORDER BY 2;

--Find average land value per acre in Nasvhille
SELECT PropertyAddressOnlyCity, 
ROUND(AVG(LandValue)/Acreage, 2) AS PricePerAcre
FROM Housing_Data
GROUP BY 1
ORDER BY 2;

--Find average building value per bedroom and bathroom count, then finding the average added value of a bedroom and a bathroom in the Nashville market
SELECT Bedrooms,
CASE
	WHEN  Bedrooms <> 0 THEN ROUND(AVG(BuildingValue)/Bedrooms,2)
	ELSE 0
END AS PricePerBed
FROM Housing_Data
WHERE Bedrooms NOT NULL
GROUP BY 1
ORDER BY 1;

SELECT BathCount,
CASE
	WHEN BathCount <> 0 THEN ROUND(AVG(BuildingValue)/BathCount, 2) 
	ELSE 0
END AS PricePerBath
FROM Housing_Data
WHERE BathCount NOT NULL
GROUP BY 1
ORDER BY 1;