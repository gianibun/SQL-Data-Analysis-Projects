/*
My boss wants to get all of our wire inventory location information for later data analysis
*/
SELECT EP.eclipse_id, EP.description, EP.buy_line_id, EP.price_line_id, EP.product_gl_type ,PIL.location,
       PIL.location_type, PIL.location_status, PIL.location_lot_id, PIL.location_qty, pil.branch_id
FROM EDW_loebelectric_com_PROD.eclipse.product EP
  INNER JOIN PROD.clipse.product_inventory_location PIL
  ON EP.eclipse_id = PIL.product_id
WHERE price_line_id IN ('BCU', 'MCABLE', 'BWLUM')



