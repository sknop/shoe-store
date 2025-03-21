output "cc_compute_pool_name" {
  value = confluent_flink_compute_pool.cc_flink_compute_pool.id
}

output "cc_hands_env" {
  description = "Confluent Cloud Environment ID"
  value       = confluent_environment.cc_handson_env.id
}

output "cc_kafka_cluster" {
  description = "CC Kafka Cluster ID"
  value       = confluent_kafka_cluster.cc_kafka_cluster.id
}

output "cc_kafka_cluster_bootsrap" {
  description = "CC Kafka Cluster ID"
  value       = confluent_kafka_cluster.cc_kafka_cluster.bootstrap_endpoint

}


output "datagen_products" {
  description = "CC Datagen Products Connector ID"
  value       = confluent_connector.datagen_products.id
}

output "datagen_customers" {
  description = "CC Datagen Customers Connector ID"
  value       = confluent_connector.datagen_customers.id
}
output "datagen_orders" {
  description = "CC Datagen Orders Connector ID"
  value       = confluent_connector.datagen_orders.id
}


output "SRKey" {
  description = "CC SR Key"
  value       = confluent_api_key.sr_cluster_key.id
}
output "SRSecret" {
  description = "CC SR Secret"
  value       = confluent_api_key.sr_cluster_key.secret
  sensitive = true
}

output "AppManagerKey" {
  description = "CC AppManager Key"
  value       = confluent_api_key.app_manager_kafka_cluster_key.id
}
output "AppManagerSecret" {
  description = "CC AppManager Secret"
  value       = confluent_api_key.app_manager_kafka_cluster_key.secret
  sensitive = true
}

output "ClientKey" {
  description = "CC clients Key"
  value       = confluent_api_key.clients_kafka_cluster_key.id
}
output "ClientSecret" {
  description = "CC Client Secret"
  value       = confluent_api_key.clients_kafka_cluster_key.secret
  sensitive = true
}

