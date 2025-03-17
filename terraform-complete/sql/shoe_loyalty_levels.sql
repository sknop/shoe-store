-- noinspection SqlNoDataSourceInspectionForFile

CREATE TABLE shoe_loyalty_levels(
        email STRING,
        total BIGINT,
        rewards_level STRING,
        PRIMARY KEY (email) NOT ENFORCED
) WITH (
        'changelog.mode' = 'upsert',
        'kafka.cleanup-policy' = 'compact'
)
AS
SELECT
    COALESCE(email, 'noemail@example.com') AS email,
    SUM(sale_price) AS total,
    CASE
        WHEN SUM(sale_price) > 80000000 THEN 'GOLD'
        WHEN SUM(sale_price) > 7000000 THEN 'SILVER'
        WHEN SUM(sale_price) > 600000 THEN 'BRONZE'
        ELSE 'CLIMBING'
        END AS rewards_level
FROM shoe_order_customer_product
GROUP BY email;