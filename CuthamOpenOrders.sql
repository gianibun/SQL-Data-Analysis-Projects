/*Please provide ALL open orders for Eaton/Cutler hammer. Let’s have the following:
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

select *
from EDW_loebelectric_com_PROD.eclipse.open_purchase_order -- PO#, status code, promised date/receive date, writer

select *
from EDW_loebelectric_com_PROD.eclipse.purchase_order_line_generation -- product id, gen id, line id,

select *
from EDW_loebelectric_com_PROD.eclipse.product -- Price line, Uom, COGS, desc

select * 
from EDW_loebelectric_com_PROD.eclipse.purchase_order_log -- create date/order date 
order by purchase_order_id

--select *
--from EDW_loebelectric_com_PROD.eclipse.purchase_order_line

--select *
--from EDW_loebelectric_com_PROD.eclipse.purchase_order

--select * 
--from EDW_loebelectric_com_PROD.eclipse.purchase_order

--select *
--from EDW_loebelectric_com_PROD.eclipse.purchase_order_generation



-----------
select OPO.purchase_order_id, OPO.status_code, receive_date as promised_date, OPO.writer, POLG.product_id, stock_qty,receive_qty,price ,branch_cost_per_um, EP.description, ep.buy_line_id, POLG.generation_id, POLG.line_id, cogs_amount, total_amount
from EDW_loebelectric_com_PROD.eclipse.open_purchase_order OPO

left join EDW_loebelectric_com_PROD.eclipse.purchase_order_line_generation POLG
on OPO.purchase_order_id = POLG.purchase_order_id and OPO.generation_id = POLG.generation_id

left join EDW_loebelectric_com_PROD.eclipse.product EP 
on POLG.product_id = EP.product_id

where buy_line_id like 'CUTHAM' --AND POLG.purchase_order_id like 'P100097992'

--Merge with create date
--NULL create date = copied from another PO 
-- Final Query, run this query 

select OPO.purchase_order_id, OPO.status_code, receive_date as promised_date, POL.create_date, OPO.writer,ep.buy_line_id, POLG.product_id, EP.description, stock_qty,receive_qty,price ,branch_cost_per_um,  POLG.generation_id, POLG.line_id, cogs_amount, total_amount
from EDW_loebelectric_com_PROD.eclipse.open_purchase_order OPO

left join EDW_loebelectric_com_PROD.eclipse.purchase_order_line_generation POLG
on OPO.purchase_order_id = POLG.purchase_order_id and OPO.generation_id = POLG.generation_id

left join EDW_loebelectric_com_PROD.eclipse.product EP 
on POLG.product_id = EP.product_id

left join EDW_loebelectric_com_PROD.eclipse.purchase_order_log POL
on POL. purchase_order_id = OPO.purchase_order_id

where buy_line_id like 'CUTHAM' and status_code in ('O','V') --and POL.create_date < '8/1/21'--AND POLG.purchase_order_id like 'P100076598'
order by 1