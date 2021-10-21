/*
My boss requested a record of products that I was able to synced with our Product Data Warehouse 
Background:
We have approx 300,000 products that are not synced (not all of them can be synced)
We have new products created by people in our company everyday, some of the products are already synced and some are not
One of my responsibility is to sync those unsynced item
All the product that were synced will have an assigned pdw_item_id number and the ones that are not will be NULL

The logic behind below code is to compare the product that were previously unsynced (pdw_item_id is NULL) to now synced (pdw_item_id with an assigned number)
I created a table called ProductUnsyncedTable that stores all of the product that are not synced (pdw_item_id is NULL) 
When I pull the list of synced product from our most up to date records from our real-time database, and if the product existed in ProductUnsyncedTable, 
this means the product are synced manually by me. 

Below query has been tested and proven accurate
*/

--Below query was created on 10/20/21 newly synced item will be counted starting 10/21/21
--Run at 8AM everday

--INSERTING UNSYNCED NEW ITEMS CREATED INTO ProductUnsyncedTable
INSERT INTO DBO.UnsyncedProductTable
SELECT EP.product_id,EP.description,EP.product_status_id,EP.pdw_item_id,EP.create_date,EP.create_user 
  FROM PROD.clipse.product EP
  WHERE EP.product_id NOT IN (SELECT product_id FROM dbo.UnsyncedProductTable) AND EP.pdw_item_id is NULL and EP.product_status_id in (1,2) 


--TO PULL ITEM THAT WERE SYNCED
WITh CTE AS (
	SELECT EP.product_id,EP.description,EP.product_status_id,EP.pdw_item_id,EP.create_date,EP.create_user
	FROM PROD.clipse.product EP
	WHERE pdw_item_id is not null)
SELECT *
from CTE
WHERE product_id IN (SELECT product_id FROM dbo.UnsyncedProductTable)


