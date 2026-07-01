/*==============================================================
                    EXECUTIVE KPI DASHBOARD
                  OLIST BRAZIL E-COMMERCE
==============================================================*/


---------------------------------------------------------------
-- Sheet: Total Revenue
---------------------------------------------------------------

SELECT
    ROUND(SUM(price),2) AS total_revenue
FROM order_items;



---------------------------------------------------------------
-- Sheet: Total Orders
---------------------------------------------------------------

SELECT
    COUNT(DISTINCT order_id) AS total_orders
FROM orders;



---------------------------------------------------------------
-- Sheet: Total Customers
---------------------------------------------------------------

SELECT
    COUNT(DISTINCT customer_unique_id) AS total_customers
FROM customers;



---------------------------------------------------------------
-- Sheet: Total Sellers
---------------------------------------------------------------

SELECT
    COUNT(DISTINCT seller_id) AS total_sellers
FROM sellers;



---------------------------------------------------------------
-- Sheet: Total Products Sold
---------------------------------------------------------------

SELECT
    COUNT(product_id) AS total_products_sold
FROM order_items;



---------------------------------------------------------------
-- Sheet: Average Order Value (AOV)
---------------------------------------------------------------

SELECT
    ROUND(
        SUM(price) /
        COUNT(DISTINCT order_id),
        2
    ) AS average_order_value
FROM order_items;



---------------------------------------------------------------
-- Sheet: Monthly Revenue
---------------------------------------------------------------

SELECT
    DATE_TRUNC('month',o.order_purchase_timestamp) AS month,
    ROUND(SUM(oi.price),2) AS revenue
FROM orders o
JOIN order_items oi
ON o.order_id=oi.order_id
GROUP BY DATE_TRUNC('month',o.order_purchase_timestamp)
ORDER BY month;



---------------------------------------------------------------
-- Sheet: Running Revenue
---------------------------------------------------------------

SELECT
    month,
    revenue,
    SUM(revenue) OVER(
        ORDER BY month
    ) AS cumulative_revenue
FROM
(
SELECT
    DATE_TRUNC('month',o.order_purchase_timestamp) AS month,
    SUM(oi.price) AS revenue
FROM orders o
JOIN order_items oi
ON o.order_id=oi.order_id
GROUP BY DATE_TRUNC('month',o.order_purchase_timestamp)
)t;



---------------------------------------------------------------
-- Sheet: Previous Month Revenue
---------------------------------------------------------------

SELECT
    month,
    revenue,
    LAG(revenue) OVER(
        ORDER BY month
    ) AS previous_month_revenue
FROM
(
SELECT
    DATE_TRUNC('month',o.order_purchase_timestamp) AS month,
    SUM(oi.price) AS revenue
FROM orders o
JOIN order_items oi
ON o.order_id=oi.order_id
GROUP BY DATE_TRUNC('month',o.order_purchase_timestamp)
)t;



---------------------------------------------------------------
-- Sheet: Revenue Difference vs Previous Month
---------------------------------------------------------------

SELECT
    month,
    revenue,
    revenue-
    LAG(revenue) OVER(
        ORDER BY month
    ) AS revenue_difference
FROM
(
SELECT
    DATE_TRUNC('month',o.order_purchase_timestamp) AS month,
    SUM(oi.price) AS revenue
FROM orders o
JOIN order_items oi
ON o.order_id=oi.order_id
GROUP BY DATE_TRUNC('month',o.order_purchase_timestamp)
)t;



---------------------------------------------------------------
-- Sheet: Revenue Growth Percentage
---------------------------------------------------------------

SELECT
    month,
    revenue,
    ROUND(
        (
        revenue-
        LAG(revenue) OVER(ORDER BY month)
        )
        /
        LAG(revenue) OVER(ORDER BY month)
        *100,
        2
    ) AS growth_percentage
FROM
(
SELECT
    DATE_TRUNC('month',o.order_purchase_timestamp) AS month,
    SUM(oi.price) AS revenue
FROM orders o
JOIN order_items oi
ON o.order_id=oi.order_id
GROUP BY DATE_TRUNC('month',o.order_purchase_timestamp)
)t;



---------------------------------------------------------------
-- Sheet: Top 10 States by Revenue
---------------------------------------------------------------

SELECT
    c.customer_state,
    ROUND(SUM(oi.price),2) AS revenue
FROM customers c
JOIN orders o
ON c.customer_id=o.customer_id
JOIN order_items oi
ON o.order_id=oi.order_id
GROUP BY c.customer_state
ORDER BY revenue DESC
LIMIT 10;



---------------------------------------------------------------
-- Sheet: Top 10 Product Categories
---------------------------------------------------------------

SELECT
    p.product_category_name,
    ROUND(SUM(oi.price),2) AS revenue
FROM products p
JOIN order_items oi
ON p.product_id=oi.product_id
GROUP BY p.product_category_name
ORDER BY revenue DESC
LIMIT 10;



---------------------------------------------------------------
-- Sheet: Average Review Score
---------------------------------------------------------------

SELECT
    ROUND(
        AVG(review_score),
        2
    ) AS average_review_score
FROM order_reviews;



---------------------------------------------------------------
-- Sheet: Average Delivery Time
---------------------------------------------------------------

SELECT
    ROUND(
        AVG(
        order_delivered_customer_date-
        order_purchase_timestamp
        ),
        2
    ) AS avg_delivery_days
FROM orders
WHERE order_delivered_customer_date IS NOT NULL;



---------------------------------------------------------------
-- Sheet: Top 10 Customers by Revenue
---------------------------------------------------------------

SELECT
    c.customer_unique_id,
    ROUND(SUM(oi.price),2) AS lifetime_value
FROM customers c
JOIN orders o
ON c.customer_id=o.customer_id
JOIN order_items oi
ON o.order_id=oi.order_id
GROUP BY c.customer_unique_id
ORDER BY lifetime_value DESC
LIMIT 10;



---------------------------------------------------------------
-- Sheet: Top 10 Sellers by Revenue
---------------------------------------------------------------

SELECT
    seller_id,
    ROUND(SUM(price),2) AS revenue
FROM order_items
GROUP BY seller_id
ORDER BY revenue DESC
LIMIT 10;



---------------------------------------------------------------
-- Sheet: Best Selling Product
---------------------------------------------------------------

SELECT
    product_id,
    COUNT(*) AS units_sold
FROM order_items
GROUP BY product_id
ORDER BY units_sold DESC
LIMIT 1;



---------------------------------------------------------------
-- Sheet: Total Freight Cost
---------------------------------------------------------------

SELECT
    ROUND(
        SUM(freight_value),
        2
    ) AS total_freight
FROM order_items;



---------------------------------------------------------------
-- Sheet: Revenue Contribution by Category
---------------------------------------------------------------

SELECT
    p.product_category_name,
    ROUND(SUM(oi.price),2) revenue,
    ROUND(
        SUM(oi.price)*100/
        SUM(SUM(oi.price)) OVER(),
        2
    ) AS contribution_percentage
FROM products p
JOIN order_items oi
ON p.product_id=oi.product_id
GROUP BY p.product_category_name
ORDER BY contribution_percentage DESC;