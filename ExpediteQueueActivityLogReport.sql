WITH CTE AS(
SELECT 
PO.purchase_order_id, 
POLC.user_id, 
POLC.comment,  POLC.date as comment_date, 
POLC.time comment_time, generation_id,
PO.sql_last_modified,
--max(POLC.date) over (partition by PO.purchase_order_id) as max_comment_date,
--max(POLC.time) over (partition by PO.purchase_order_id) as max_comment_time,
ROW_NUMBER() OVER (		-- assigned row number to purchase order 
PARTITION BY PO.purchase_order_id,POLC.date
				--PO.last_update_date, 
				--PO.last_update_time 
				order by PO.purchase_order_id, POLC.time desc) row_num

from EDW_loebelectric_com_PROD.eclipse.purchase_order PO
join EDW_loebelectric_com_PROD.eclipse.purchase_order_log_comment POLC on PO.purchase_order_id = POLC.purchase_order_id

where POLC.user_id like 'CWILLI' 
--order by purchase_order_id
)
select *
from CTE
where row_num = 1
order by comment_date desc, comment_time desc
