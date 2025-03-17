-- noinspection SqlNoDataSourceInspectionForFile

CREATE TABLE shoe_order_customer_product(
            order_id INT,
            first_name STRING,
            last_name STRING,
            email STRING,
            brand STRING,
            `model` STRING,
            sale_price INT,
            rating DOUBLE
)
AS
SELECT
            so.order_id,
            sc.first_name,
            sc.last_name,
            sc.email,
            sp.brand,
            sp.`model`,
            sp.sale_price,
            sp.rating
 FROM shoe_orders so
        INNER JOIN shoe_customers_keyed sc
                   ON so.customer_id = sc.customer_id
        INNER JOIN shoe_products_keyed sp
                   ON so.product_id = sp.product_id;
