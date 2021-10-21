/*
My boss requested the following:
Please provide ALL open orders for Cutham. Let’s have the following:
•	PO #		
•	Writer
x	Internal notes
•	Item ID
•	Description
•	Qty
•	Cost
•	Extended Cost
•	Uom
•	Order Date
•	Ship date (promise date)
*/

--Merge 4 different tables to get all of the above data

select OPO.purchase_order_id, OPO.status_code, receive_date as promised_date, POL.create_date, OPO.writer,ep.buy_line_id, POLG.product_id, EP.description, stock_qty,receive_qty,price ,branch_cost_per_um,  POLG.generation_id, POLG.line_id, cogs_amount, total_amount
from PROD.clipse.open_purchase_order OPO

left join PROD.clipse.purchase_order_line_generation POLG
on OPO.purchase_order_id = POLG.purchase_order_id and OPO.generation_id = POLG.generation_id

left join PROD.clipse.product EP 
on POLG.product_id = EP.product_id

left join PROD.clipse.purchase_order_log POL
on POL. purchase_order_id = OPO.purchase_order_id

where buy_line_id like 'CUTHAM' and status_code in ('O','V') 
order by 1
