-- Use this table to 
-- compute order_binary for the 30 day window after the test_start_date
-- for the test named item_test_2

SELECT 
  test_binary.test_assignment,
  COUNT(DISTINCT test_binary.item_id) AS items_id,
  SUM(test_binary.orders_bin_30d) AS orders_binary_30d
FROM
  (
  SELECT 
    assignments.item_id,
    assignments.test_assignment,
    MAX(CASE
            WHEN (
              (DATE(orders.created_at) - DATE(assignments.test_start_date)) <= 30 AND
              (DATE(orders.created_at) - DATE(assignments.test_start_date) > 0)
            )
            THEN 1 ELSE 0
        END) AS orders_bin_30d
  FROM dsv1069.final_assignments AS assignments
  LEFT JOIN dsv1069.orders AS orders
    ON assignments.item_id=orders.item_id
  WHERE 
    assignments.test_number='item_test_2'
  GROUP BY 
    assignments.item_id,
    assignments.test_assignment
  ) test_binary
  GROUP BY 
    test_binary.test_assignment
