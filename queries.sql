--1 Top ten cities having the most sellers
SELECT 
    seller_city,
    COUNT(seller_id) AS no_sellers
FROM sellers
GROUP BY seller_city
ORDER BY no_sellers DESC
LIMIT 10;
--2 Ten states having the most customers
SELECT 
    customer_state,
    COUNT(customer_unique_id) AS no_customers
FROM customers
GROUP BY customer_state 
ORDER BY no_customers DESC
LIMIT 10;
--3 Top ten categories having highest product counts
SELECT 
    product_category_name_translation.product_category_name_englisth,
    COUNT(product_id) AS no_products
FROM products LEFT JOIN product_category_name_translation USING(product_category_name)
GROUP BY product_category_name_translation.product_category_name_englisth
ORDER BY no_products DESC
LIMIT 10;
--4 delivery rate
WITH cte AS ( 
    SELECT 
        order_status,
        COUNT(order_status) AS status_count
    FROM orders
    GROUP BY order_status
)
SELECT 
    order_status,
    status_count,
    ROUND(status_count / SUM(status_count) OVER() * 100, 2)  AS status_rate
FROM cte
ORDER BY status_count DESC;
--5 Average review score per product category
SELECT p.product_category_name, AVG(r.review_score) AS avg_score
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
JOIN order_reviews r ON oi.order_id = r.order_id
GROUP BY p.product_category_name
ORDER BY avg_score DESC;
--6 Payment method distribution
SELECT payment_type, COUNT(*) AS total
FROM order_payments
GROUP BY payment_type
ORDER BY total DESC;
-- Total revenue by year ????
SELECT 
    EXTRACT(YEAR FROM o.order_purchase_timestamp) AS y,
    SUM(oi.price) AS total_revenue
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY y
ORDER BY y;
--8 Sellers with the highest average review score
SELECT 
    s.seller_id, 
    AVG(r.review_score) AS avg_review
FROM sellers s
JOIN order_items oi ON s.seller_id = oi.seller_id
JOIN order_reviews r ON oi.order_id = r.order_id
GROUP BY s.seller_id
HAVING COUNT(r.review_id) > 20
ORDER BY avg_review DESC
LIMIT 5;
--9 Number of orders per state
SELECT c.customer_state, COUNT(o.order_id) AS total_orders
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_state
ORDER BY total_orders DESC;
--10 Common delivery time during the day
SELECT 
    DATE_PART('hour', order_delivered_customer_date) AS delivery_hour,
    COUNT(order_id)
FROM orders
GROUP BY delivery_hour
ORDER BY delivery_hour;