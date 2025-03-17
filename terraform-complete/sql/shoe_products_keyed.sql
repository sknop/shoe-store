-- noinspection SqlNoDataSourceInspectionForFile

CREATE TABLE shoe_products_keyed(
        product_id STRING,
        brand STRING,
        `model` STRING,
        sale_price INT,
        rating DOUBLE,
        PRIMARY KEY (product_id) NOT ENFORCED
) WITH (
        'changelog.mode' = 'upsert',
        'kafka.cleanup-policy' = 'compact'
)
AS
SELECT id `product_id`, brand, `name` `model`, sale_price, rating FROM shoe_products;