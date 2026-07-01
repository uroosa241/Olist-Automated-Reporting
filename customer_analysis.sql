-- Sheet: Total Customers
----------------------------------------------------------
SELECT
    COUNT(DISTINCT customer_unique_id) AS total_customers
FROM customers;

-- Sheet: Cumulative Customer Acquisition
----------------------------------------------------------
WITH first_purchase AS
(
    SELECT
        c.customer_unique_id,
        MIN(o.order_purchase_timestamp) AS first_purchase
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    GROUP BY c.customer_unique_id
)

SELECT
    DATE_TRUNC('month', first_purchase) AS month,
    COUNT(*) AS new_customers,
    SUM(COUNT(*)) OVER (
        ORDER BY DATE_TRUNC('month', first_purchase)
    ) AS cumulative_customers
FROM first_purchase
GROUP BY DATE_TRUNC('month', first_purchase)
ORDER BY month;

-- Sheet: Customer Lifetime Value (CLV)
----------------------------------------------------------
SELECT
    c.customer_unique_id,
    ROUND(SUM(oi.price), 2) AS customer_lifetime_value
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
JOIN order_items oi
    ON o.order_id = oi.order_id
GROUP BY c.customer_unique_id
ORDER BY customer_lifetime_value DESC;

-- Sheet: Rank Customers by CLV
----------------------------------------------------------
SELECT
    customer_unique_id,
    customer_lifetime_value,
    DENSE_RANK() OVER(ORDER BY customer_lifetime_value DESC) AS customer_rank
FROM
(
    SELECT
        c.customer_unique_id,
        SUM(oi.price) AS customer_lifetime_value
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    JOIN order_items oi
        ON o.order_id = oi.order_id
    GROUP BY c.customer_unique_id
) t;

-- Sheet: Top 10 Customers
----------------------------------------------------------
SELECT
    c.customer_unique_id,
    SUM(price) AS revenue
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
JOIN order_items oi
    ON oi.order_id = o.order_id
GROUP BY c.customer_unique_id
ORDER BY revenue DESC
LIMIT 10;

-- Sheet: Repeat Customers
----------------------------------------------------------
SELECT
    customer_unique_id,
    COUNT(order_id) AS total_orders
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
GROUP BY customer_unique_id
HAVING COUNT(order_id) > 1
ORDER BY total_orders DESC;

-- Sheet: Average Orders Per Customer
----------------------------------------------------------
SELECT
    ROUND(AVG(total_orders), 2) AS avg_orders_per_customer
FROM
(
    SELECT
        customer_unique_id,
        COUNT(order_id) AS total_orders
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    GROUP BY customer_unique_id
) t;

-- Sheet: First Purchase
----------------------------------------------------------
SELECT *
FROM
(
    SELECT
        customer_unique_id,
        order_id,
        order_purchase_timestamp,
        ROW_NUMBER() OVER(PARTITION BY customer_unique_id ORDER BY order_purchase_timestamp) AS rn
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
) t
WHERE rn = 1;

-- Sheet: Most Recent Purchase
----------------------------------------------------------
SELECT *
FROM
(
    SELECT
        customer_unique_id,
        order_id,
        order_purchase_timestamp,
        ROW_NUMBER() OVER(PARTITION BY customer_unique_id ORDER BY order_purchase_timestamp DESC) AS rn
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
) t
WHERE rn = 1;

-- Sheet: Customer Purchase Frequency
----------------------------------------------------------
SELECT
    customer_unique_id,
    COUNT(order_id) AS total_orders
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
GROUP BY customer_unique_id
ORDER BY total_orders DESC;

-- Sheet: Customer Revenue Contribution
----------------------------------------------------------
SELECT
    customer_unique_id,
    SUM(price) AS revenue,
    ROUND(
        SUM(price) * 100.0 / SUM(SUM(price)) OVER(),
        2
    ) AS contribution_percentage
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
JOIN order_items oi
    ON oi.order_id = o.order_id
GROUP BY customer_unique_id
ORDER BY contribution_percentage DESC;

-- Sheet: Customer Spending Quartiles
----------------------------------------------------------
SELECT
    customer_unique_id,
    total_spending,
    NTILE(4) OVER(ORDER BY total_spending DESC) AS customer_segment
FROM
(
    SELECT
        customer_unique_id,
        SUM(price) AS total_spending
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    JOIN order_items oi
        ON oi.order_id = o.order_id
    GROUP BY customer_unique_id
) t;

-- Sheet: Customer Percent Rank
----------------------------------------------------------
SELECT
    customer_unique_id,
    total_spending,
    PERCENT_RANK() OVER(ORDER BY total_spending) AS percent_rank
FROM
(
    SELECT
        customer_unique_id,
        SUM(price) AS total_spending
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    JOIN order_items oi
        ON oi.order_id = o.order_id
    GROUP BY customer_unique_id
) t;

-- Sheet: Average Customer Spend
----------------------------------------------------------
SELECT
    ROUND(AVG(total_spending), 2) AS avg_customer_spend
FROM
(
    SELECT
        customer_unique_id,
        SUM(price) AS total_spending
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    JOIN order_items oi
        ON oi.order_id = o.order_id
    GROUP BY customer_unique_id
) t;

-- Sheet: Customers by State
----------------------------------------------------------
SELECT
    customer_state,
    COUNT(DISTINCT customer_unique_id) AS customers
FROM customers
GROUP BY customer_state
ORDER BY customers DESC;

-- Sheet: Revenue by Customer State
----------------------------------------------------------
SELECT
    customer_state,
    SUM(price) AS revenue
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
JOIN order_items oi
    ON oi.order_id = o.order_id
GROUP BY customer_state
ORDER BY revenue DESC;

-- Sheet: Monthly Active Customers
----------------------------------------------------------
SELECT
    DATE_TRUNC('month', order_purchase_timestamp) AS month,
    COUNT(DISTINCT customer_unique_id) AS active_customers
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
GROUP BY DATE_TRUNC('month', order_purchase_timestamp)
ORDER BY month;

-- Sheet: Running Customer Revenue
----------------------------------------------------------
WITH monthly_revenue AS
(
    SELECT
        DATE_TRUNC('month', order_purchase_timestamp) AS month,
        SUM(price) AS revenue
    FROM orders o
    JOIN order_items oi
        ON o.order_id = oi.order_id
    GROUP BY DATE_TRUNC('month', order_purchase_timestamp)
)

SELECT
    month,
    revenue,
    SUM(revenue) OVER (ORDER BY month) AS running_revenue
FROM monthly_revenue;

-- Sheet: Top 5 Customers Per State
----------------------------------------------------------
SELECT *
FROM
(
    SELECT
        customer_state,
        customer_unique_id,
        SUM(price) AS revenue,
        DENSE_RANK() OVER(PARTITION BY customer_state ORDER BY SUM(price) DESC) AS rnk
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    JOIN order_items oi
        ON oi.order_id = o.order_id
    GROUP BY customer_state, customer_unique_id
) t
WHERE rnk <= 5;