/*
Cleaning Data in SQL Queries
*/
SELECT *
FROM NashvilleHousing

--------------------------------------------------------------------------------------------------------------------------
-- Standardize Date Format
SELECT SaleDate, CONVERT(Date,SaleDate)
FROM NashvilleHousing
UPDATE NashvilleHousing
SET SaleDate = CONVERT(Date,SaleDate)

--------------------------------------------------------------------------------------------------------------------------
-- Populate Property Address data
SELECT *
FROM NashvilleHousing
-- Where PropertyAddress is null
ORDER BY ParcelID

SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress) --> ISNULL means if a.PropertyAddress is Null, then populate with b.PropertyAddress
FROM NashvilleHousing a
JOIN NashvilleHousing b 
	ON a.ParcelID = b.ParcelID
	AND a.UniqueID <> b.UniqueID
WHERE a.PropertyAddress IS NULL

UPDATE a -->must use alias otherwise will be error
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress) -- if a.PropertyAddress is NULL then populate with b.PropertyAddress
FROM NashvilleHousing a
JOIN NashvilleHousing b 
	ON a.ParcelID = b.ParcelID
	AND a.UniqueID <> b.UniqueID
WHERE a.PropertyAddress IS NULL

/*
UPDATE SET

syntax  
UPDATE table_name
SET column1 = value1, column2 = value2, ...
WHERE condition;

example
UPDATE Customers
SET ContactName = 'Alfred Schmidt', City= 'Frankfurt'
WHERE CustomerID = 1;
*/

--------------------------------------------------------------------------------------------------------------------------
-- Breaking out Address into Individual Columns (Address, City, State)
SELECT PropertyAddress
FROM NashvilleHousing
-- Where PropertyAddress is null
-- Order by ParcelID

--Property Address
SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress)-1) AS Address, -- Position 1, CHARINDEX -->searching for a specific value, -1 to get rid of comma 
SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress)+1, LEN(PropertyAddress)) AS CITY
FROM NashvilleHousing

ALTER TABLE NashvilleHousing 
Add PropertySplitAddress NVARCHAR(255)

UPDATE NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress)-1)

ALTER TABLE NashvilleHousing 
Add PropertySplitCity NVARCHAR(255)


UPDATE NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress)+1, LEN(PropertyAddress))

SELECT *
FROM NashvilleHousing

--Owner Address

SELECT OwnerAddress
FROM NashvilleHousing

SELECT	PARSENAME(REPLACE(OwnerAddress,',','.'),3) ,-- PARSENAME ONLY LOOKS FOR PERIOD, SO REPLACE COMMA WITH PERIOD. The 1 is looking at the first period and it starts backwards from right to left of the string
		PARSENAME(REPLACE(OwnerAddress,',','.'),2) ,
		PARSENAME(REPLACE(OwnerAddress,',','.'),1) 
FROM NashvilleHousing

--ALTER TABLE NashvilleHousing
ALTER TABLE NashvilleHousing
ADD OwnerSplitAddress NVARCHAR(255)

UPDATE NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress,',','.'),3)

ALTER TABLE NashvilleHousing
ADD OwnerSplitCity NVARCHAR(255)

UPDATE NashvilleHousing
SET OwnerSplitCity=PARSENAME(REPLACE(OwnerAddress,',','.'),2)

ALTER TABLE NashvilleHousing
ADD OwnerSplitState NVARCHAR(255)

UPDATE NashvilleHousing
SET OwnerSplitState=PARSENAME(REPLACE(OwnerAddress,',','.'),1) 


SELECT *
FROM NashvilleHousing

--------------------------------------------------------------------------------------------------------------------------
-- Change Y and N to Yes and No in "Sold as Vacant" field
SELECT DISTINCT(SoldAsVacant),COUNT(SoldAsVacant)
FROM NashvilleHousing
GROUP BY SoldAsVacant
ORDER BY 2

SELECT SoldAsVacant, 
CASE WHEN SoldAsVacant ='Y' THEN 'Yes'
	 WHEN SoldAsVacant ='N' THEN 'No'
	 ELSE SoldAsVacant
	 END
FROM NashvilleHousing

UPDATE NashvilleHousing
SET SoldAsVacant = CASE WHEN SoldAsVacant ='Y' THEN 'Yes'
	 WHEN SoldAsVacant ='N' THEN 'No'
	 ELSE SoldAsVacant
	 END
FROM NashvilleHousing


--------------------------------------------------------------------------------------------------------------------------
-- Remove Duplicates
WITH RowNumCTE AS(
SELECT *,
	ROW_NUMBER() OVER (		-- WANT TO FIND A "UNIQUE" COLUMN OTHER THAN THE UNIQUE ID TO ASSUME THE ROWS CONTAIN THE SAME DATA
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY UniqueID) row_num
FROM NashvilleHousing
--WHERE row_num > 1 -- This will not work will need CTE
)
DELETE--SELECT *      --IF DELETE, CANNOT HAVE ORDER BY
FROM RowNumCTE
WHERE row_num > 1
--ORDER BY PropertyAddress

SELECT *
FROM NashvilleHousing


--------------------------------------------------------------------------------------------------------------------------
-- Delete Unused Columns
ALTER TABLE NashvilleHousing
DROP COLUMN OwnerAddress,TaxDistrict, PropertyAddress

ALTER TABLE NashvilleHousing
DROP COLUMN SaleDate

--------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------