/*=====================================================================
                    SALES SUMMARY ANALYSIS
                 OLIST BRAZIL E-COMMERCE
=====================================================================*/


------------------------------------------------------------
-- Sheet: Total Revenue
------------------------------------------------------------

SELECT
    ROUND(SUM(price),2) AS total_revenue
FROM order_items;



------------------------------------------------------------
-- Sheet: Total Orders
------------------------------------------------------------

SELECT
    COUNT(DISTINCT order_id) AS total_orders
FROM orders;



------------------------------------------------------------
-- Sheet: Average Order Value
------------------------------------------------------------

SELECT
    ROUND(
        SUM(price) /
        COUNT(DISTINCT order_id),
        2
    ) AS average_order_value
FROM order_items;



------------------------------------------------------------
-- Sheet: Monthly Sales Trend
------------------------------------------------------------

SELECT
    DATE_TRUNC('month',o.order_purchase_timestamp) AS month,
    ROUND(SUM(oi.price),2) AS revenue
FROM orders o
JOIN order_items oi
ON o.order_id=oi.order_id
GROUP BY month
ORDER BY month;



------------------------------------------------------------
-- Sheet: Monthly Order Volume
------------------------------------------------------------

SELECT
    DATE_TRUNC('month',order_purchase_timestamp) AS month,
    COUNT(order_id) AS total_orders
FROM orders
GROUP BY month
ORDER BY month;



------------------------------------------------------------
-- Sheet: Running Revenue
------------------------------------------------------------

WITH monthly_sales AS
(
SELECT
    DATE_TRUNC('month',o.order_purchase_timestamp) month,
    SUM(price) revenue
FROM orders o
JOIN order_items oi
ON o.order_id=oi.order_id
GROUP BY month
)

SELECT
    month,
    revenue,
    SUM(revenue) OVER(
        ORDER BY month
    ) cumulative_revenue
FROM monthly_sales;



------------------------------------------------------------
-- Sheet: Previous Month Revenue
------------------------------------------------------------

WITH monthly_sales AS
(
SELECT
    DATE_TRUNC('month',o.order_purchase_timestamp) month,
    SUM(price) revenue
FROM orders o
JOIN order_items oi
ON o.order_id=oi.order_id
GROUP BY month
)

SELECT
    *,
    LAG(revenue) OVER(
        ORDER BY month
    ) previous_month
FROM monthly_sales;



------------------------------------------------------------
-- Sheet: Revenue Difference
------------------------------------------------------------

WITH monthly_sales AS
(
SELECT
    DATE_TRUNC('month',o.order_purchase_timestamp) month,
    SUM(price) revenue
FROM orders o
JOIN order_items oi
ON o.order_id=oi.order_id
GROUP BY month
)

SELECT
    *,
    revenue-
    LAG(revenue) OVER(
        ORDER BY month
    ) revenue_difference
FROM monthly_sales;



------------------------------------------------------------
-- Sheet: Monthly Growth %
------------------------------------------------------------

WITH monthly_sales AS
(
SELECT
    DATE_TRUNC('month',o.order_purchase_timestamp) month,
    SUM(price) revenue
FROM orders o
JOIN order_items oi
ON o.order_id=oi.order_id
GROUP BY month
)

SELECT
    *,
    ROUND(
    (
    revenue-
    LAG(revenue) OVER(ORDER BY month)
    )
    /
    LAG(revenue) OVER(ORDER BY month)
    *100
    ,2) growth_percentage
FROM monthly_sales;



------------------------------------------------------------
-- Sheet: 3-Month Moving Average
------------------------------------------------------------

WITH monthly_sales AS
(
SELECT
    DATE_TRUNC('month',o.order_purchase_timestamp) month,
    SUM(price) revenue
FROM orders o
JOIN order_items oi
ON o.order_id=oi.order_id
GROUP BY month
)

SELECT
    *,
    ROUND(
    AVG(revenue) OVER(
        ORDER BY month
        ROWS BETWEEN 2 PRECEDING
        AND CURRENT ROW
    ),2)
    moving_average
FROM monthly_sales;



------------------------------------------------------------
-- Sheet: Highest Revenue Month
------------------------------------------------------------

SELECT
    DATE_TRUNC('month',o.order_purchase_timestamp) month,
    SUM(price) revenue
FROM orders o
JOIN order_items oi
ON o.order_id=oi.order_id
GROUP BY month
ORDER BY revenue DESC
LIMIT 1;



------------------------------------------------------------
-- Sheet: Lowest Revenue Month
------------------------------------------------------------

SELECT
    DATE_TRUNC('month',o.order_purchase_timestamp) month,
    SUM(price) revenue
FROM orders o
JOIN order_items oi
ON o.order_id=oi.order_id
GROUP BY month
ORDER BY revenue
LIMIT 1;



------------------------------------------------------------
-- Sheet: Top 10 Selling States
------------------------------------------------------------

SELECT
    c.customer_state,
    SUM(price) revenue
FROM customers c
JOIN orders o
ON c.customer_id=o.customer_id
JOIN order_items oi
ON oi.order_id=o.order_id
GROUP BY customer_state
ORDER BY revenue DESC
LIMIT 10;



------------------------------------------------------------
-- Sheet: Revenue Contribution by State
------------------------------------------------------------

SELECT
    customer_state,
    SUM(price) revenue,

    ROUND(
    SUM(price)*100/
    SUM(SUM(price)) OVER(),
    2
    ) contribution_percentage

FROM customers c
JOIN orders o
ON c.customer_id=o.customer_id
JOIN order_items oi
ON oi.order_id=o.order_id
GROUP BY customer_state
ORDER BY contribution_percentage DESC;



------------------------------------------------------------
-- Sheet: Revenue by Category
------------------------------------------------------------

SELECT
    product_category_name,
    SUM(price) revenue
FROM products p
JOIN order_items oi
ON p.product_id=oi.product_id
GROUP BY product_category_name
ORDER BY revenue DESC;



------------------------------------------------------------
-- Sheet: Revenue Contribution by Category
------------------------------------------------------------

SELECT
    product_category_name,
    SUM(price) revenue,

    ROUND(
    SUM(price)*100/
    SUM(SUM(price)) OVER(),
    2
    ) contribution_percentage

FROM products p
JOIN order_items oi
ON p.product_id=oi.product_id
GROUP BY product_category_name
ORDER BY contribution_percentage DESC;



------------------------------------------------------------
-- Sheet: Top 10 Products by Revenue
------------------------------------------------------------

SELECT
    product_id,
    SUM(price) revenue
FROM order_items
GROUP BY product_id
ORDER BY revenue DESC
LIMIT 10;



------------------------------------------------------------
-- Sheet: Top 10 Sellers by Revenue
------------------------------------------------------------

SELECT
    seller_id,
    SUM(price) revenue
FROM order_items
GROUP BY seller_id
ORDER BY revenue DESC
LIMIT 10;



------------------------------------------------------------
-- Sheet: Daily Sales Trend
------------------------------------------------------------

SELECT
    DATE(order_purchase_timestamp) sales_date,
    SUM(price) revenue
FROM orders o
JOIN order_items oi
ON o.order_id=oi.order_id
GROUP BY sales_date
ORDER BY sales_date;



------------------------------------------------------------
-- Sheet: Average Daily Revenue
------------------------------------------------------------

WITH daily_sales AS
(
SELECT
    DATE(order_purchase_timestamp) sales_date,
    SUM(price) revenue
FROM orders o
JOIN order_items oi
ON o.order_id=oi.order_id
GROUP BY sales_date
)

SELECT
    ROUND(AVG(revenue),2)
    AS average_daily_revenue
FROM daily_sales;