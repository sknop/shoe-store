# --------------------------------------------------------
# Flink API Keys
# --------------------------------------------------------
resource "confluent_api_key" "env-manager-flink-api-key" {
  display_name = "env-manager-flink-api-${confluent_environment.cc_handson_env.display_name}-key-${random_id.id.hex}"
  description  = "Flink API Key that is owned by 'env-manager' service account"
  owner {
    id          = confluent_service_account.app_manager.id
    api_version = confluent_service_account.app_manager.api_version
    kind        = confluent_service_account.app_manager.kind
  }

  managed_resource {
    id          = data.confluent_flink_region.cc_flink_compute_pool_region.id
    api_version = data.confluent_flink_region.cc_flink_compute_pool_region.api_version
    kind        = data.confluent_flink_region.cc_flink_compute_pool_region.kind

    environment {
      id = confluent_environment.cc_handson_env.id
    }
  }

  lifecycle {
    prevent_destroy = false
  }
}

data "confluent_flink_region" "cc_flink_compute_pool_region" {
  cloud = confluent_flink_compute_pool.cc_flink_compute_pool.cloud
  region = confluent_flink_compute_pool.cc_flink_compute_pool.region
}

# --------------------------------------------------------
# Flink SQL: CREATE TABLE shoe_customers_keyed
# --------------------------------------------------------
resource "confluent_flink_statement" "create_shoe_customers_keyed" {
  depends_on = [
    confluent_environment.cc_handson_env,
    confluent_kafka_cluster.cc_kafka_cluster,
    confluent_connector.datagen_products,
    confluent_connector.datagen_customers,
    confluent_connector.datagen_orders,
    confluent_flink_compute_pool.cc_flink_compute_pool
  ]
  compute_pool {
    id = confluent_flink_compute_pool.cc_flink_compute_pool.id
  }
  principal {
    id = confluent_service_account.app_manager.id
  }
  statement  = file("sql/shoe_customers_keyed.sql")
  properties = {
    "sql.current-catalog"  = confluent_environment.cc_handson_env.display_name
    "sql.current-database" = confluent_kafka_cluster.cc_kafka_cluster.display_name
  }
  rest_endpoint   =  data.confluent_flink_region.cc_flink_compute_pool_region.rest_endpoint

  credentials {
    key    = confluent_api_key.env-manager-flink-api-key.id
    secret = confluent_api_key.env-manager-flink-api-key.secret
  }

  lifecycle {
    prevent_destroy = false
  }
}

# --------------------------------------------------------
# Flink SQL: CREATE TABLE shoe_products_keyed
# --------------------------------------------------------
resource "confluent_flink_statement" "create_shoe_products_keyed" {
  depends_on = [
    confluent_environment.cc_handson_env,
    confluent_kafka_cluster.cc_kafka_cluster,
    confluent_connector.datagen_products,
    confluent_connector.datagen_customers,
    confluent_connector.datagen_orders,
    confluent_flink_compute_pool.cc_flink_compute_pool
  ]    
  compute_pool {
    id = confluent_flink_compute_pool.cc_flink_compute_pool.id
  }
  principal {
    id = confluent_service_account.app_manager.id
  }
  statement  = file("sql/shoe_products_keyed.sql")
  properties = {
    "sql.current-catalog"  = confluent_environment.cc_handson_env.display_name
    "sql.current-database" = confluent_kafka_cluster.cc_kafka_cluster.display_name
  }
  rest_endpoint   =  data.confluent_flink_region.cc_flink_compute_pool_region.rest_endpoint

  credentials {
    key    = confluent_api_key.env-manager-flink-api-key.id
    secret = confluent_api_key.env-manager-flink-api-key.secret
  }

  lifecycle {
    prevent_destroy = false
  }
}

# --------------------------------------------------------
# Flink SQL: CREATE TABLE shoe_order_customer_product
# --------------------------------------------------------
resource "confluent_flink_statement" "create_shoe_order_customer_product" {
  depends_on = [
    confluent_environment.cc_handson_env,
    confluent_kafka_cluster.cc_kafka_cluster,
    confluent_connector.datagen_products,
    confluent_connector.datagen_customers,
    confluent_connector.datagen_orders,
    confluent_flink_compute_pool.cc_flink_compute_pool,
    confluent_flink_statement.create_shoe_products_keyed,
    confluent_flink_statement.create_shoe_customers_keyed
  ]
  compute_pool {
    id = confluent_flink_compute_pool.cc_flink_compute_pool.id
  }
  principal {
    id = confluent_service_account.app_manager.id
  }
  statement  = file("sql/shoe_order_customer_product.sql")
  properties = {
    "sql.current-catalog"  = confluent_environment.cc_handson_env.display_name
    "sql.current-database" = confluent_kafka_cluster.cc_kafka_cluster.display_name
  }
  rest_endpoint   =  data.confluent_flink_region.cc_flink_compute_pool_region.rest_endpoint
  credentials {
    key    = confluent_api_key.env-manager-flink-api-key.id
    secret = confluent_api_key.env-manager-flink-api-key.secret
  }

  lifecycle {
    prevent_destroy = false
  }
}

# --------------------------------------------------------
# Flink SQL: CREATE TABLE shoe_loyalty_levels
# --------------------------------------------------------
resource "confluent_flink_statement" "create_shoe_loyalty_levels" {
  depends_on = [
    confluent_flink_statement.create_shoe_order_customer_product
  ]    
  compute_pool {
    id = confluent_flink_compute_pool.cc_flink_compute_pool.id
  }
  principal {
    id = confluent_service_account.app_manager.id
  }
  statement  = file("sql/shoe_loyalty_levels.sql")
  properties = {
    "sql.current-catalog"  = confluent_environment.cc_handson_env.display_name
    "sql.current-database" = confluent_kafka_cluster.cc_kafka_cluster.display_name
  }
  rest_endpoint   =  data.confluent_flink_region.cc_flink_compute_pool_region.rest_endpoint
  credentials {
    key    = confluent_api_key.env-manager-flink-api-key.id
    secret = confluent_api_key.env-manager-flink-api-key.secret
  }

  lifecycle {
    prevent_destroy = false
  }
}

# --------------------------------------------------------
# Flink SQL: CREATE TABLE shoe_promotions
# --------------------------------------------------------
resource "confluent_flink_statement" "create_shoe_promotions" {
  depends_on = [
    confluent_flink_statement.create_shoe_order_customer_product,
    confluent_flink_statement.create_shoe_loyalty_levels
  ]    
  compute_pool {
    id = confluent_flink_compute_pool.cc_flink_compute_pool.id
  }
  principal {
    id = confluent_service_account.app_manager.id
  }
  statement  = file("sql/create_shoe_promotions.sql")
  properties = {
    "sql.current-catalog"  = confluent_environment.cc_handson_env.display_name
    "sql.current-database" = confluent_kafka_cluster.cc_kafka_cluster.display_name
  }
  rest_endpoint   =  data.confluent_flink_region.cc_flink_compute_pool_region.rest_endpoint
  credentials {
    key    = confluent_api_key.env-manager-flink-api-key.id
    secret = confluent_api_key.env-manager-flink-api-key.secret
  }

  lifecycle {
    prevent_destroy = false
  }
}

# --------------------------------------------------------
# Flink SQL: Insert into shoe_promotions
# --------------------------------------------------------
resource "confluent_flink_statement" "insert_shoe_promotion" {
  depends_on = [
    confluent_flink_statement.create_shoe_promotions
  ]    
  compute_pool {
    id = confluent_flink_compute_pool.cc_flink_compute_pool.id
  }
  principal {
    id = confluent_service_account.app_manager.id
  }
  statement  = file("sql/insert_shoe_promotions.sql")
  properties = {
    "sql.current-catalog"  = confluent_environment.cc_handson_env.display_name
    "sql.current-database" = confluent_kafka_cluster.cc_kafka_cluster.display_name
  }
  rest_endpoint   =  data.confluent_flink_region.cc_flink_compute_pool_region.rest_endpoint

  credentials {
    key    = confluent_api_key.env-manager-flink-api-key.id
    secret = confluent_api_key.env-manager-flink-api-key.secret
  }

  lifecycle {
    prevent_destroy = false
  }
}
