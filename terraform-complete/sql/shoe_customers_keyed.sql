-- noinspection SqlNoDataSourceInspectionForFile

CREATE TABLE shoe_customers_keyed (
        customer_id STRING,
        first_name STRING,
        last_name STRING,
        email STRING,
        PRIMARY KEY (customer_id) NOT ENFORCED
) WITH (
        'changelog.mode' = 'upsert',
        'kafka.cleanup-policy' = 'compact'
)
AS
SELECT id `customer_id`, first_name, last_name, email from `shoe_customers`;
