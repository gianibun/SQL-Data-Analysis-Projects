--Below query was created on 10/20/21 newly synced item will be counted starting 10/21/21
--Run at 8AM everday

--INSERTING UNSYNCED NEW ITEMS CREATED INTO ProductSyncedTable
INSERT INTO DBO.UnsyncedProductTable
SELECT EP.product_id,EP.description,EP.product_status_id,EP.pdw_item_id,EP.create_date,EP.create_user --, create_time
  FROM EDW_loebelectric_com_PROD.eclipse.product EP
  WHERE EP.product_id NOT IN (SELECT product_id FROM dbo.UnsyncedProductTable) AND EP.pdw_item_id is NULL and EP.product_status_id in (1,2)
  --WHERE EP.pdw_item_id NOT IN (SELECT pdw_item_id FROM ProductSyncedTable) 


--TO PULL ITEM THAT WERE SYNCED
WITh CTE AS (
	SELECT EP.product_id,EP.description,EP.product_status_id,EP.pdw_item_id,EP.create_date,EP.create_user
	FROM EDW_loebelectric_com_PROD.eclipse.product EP
	WHERE pdw_item_id is not null)
SELECT *
from CTE
WHERE product_id IN (SELECT product_id FROM dbo.UnsyncedProductTable)

--UnsycedProductTable
select *
from dbo.UnsyncedProductTable
where product_status_id = '1'

--WILL NOT COUNT MERGE PRODUCT
