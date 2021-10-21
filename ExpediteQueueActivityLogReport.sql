/*
My boss requested a record of how many purchase orders our expeditor update on daily basis.
He wants to see one entry per PO with the most recent log activity. 
Since there are multiple activities within one purchase order, the result would pull multiple entries for each purchase order. 
Initially, I tried to use the MAX function on the activity log date and time to get the most recent entry. 
However, I discovered that there were still multiple entries because there are multiple updates that have the same activity log date and time within the same PO. 
This led me to try assigning row numbers by the PO number for each of its entries select the entry with the assigned row number 1. 
*/

WITH CTE AS(
SELECT 
PO.purchase_order_id, 
POLC.user_id, 
POLC.comment,  POLC.date as comment_date, 
POLC.time comment_time, generation_id,
PO.sql_last_modified,
--max(POLC.date) over (partition by PO.purchase_order_id) as max_comment_date,
--max(POLC.time) over (partition by PO.purchase_order_id) as max_comment_time,
ROW_NUMBER() OVER (		-- assigned row number to purchase order from the most recent starting at no 1
PARTITION BY PO.purchase_order_id,POLC.date 
				order by PO.purchase_order_id, POLC.time desc) row_num

from PROD.clipse.purchase_order PO
join PROD.clipse.purchase_order_log_comment POLC on PO.purchase_order_id = POLC.purchase_order_id

where POLC.user_id like 'CWILLI' 
--order by purchase_order_id
)
select *
from CTE
where row_num = 1
order by comment_date desc, comment_time desc
