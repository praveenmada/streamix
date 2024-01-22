/**
 * Namespace for kafka
*/
variable "namespace" {
  type    = string
  default = "kafka"
}

/**
 * Kafka Zookeeper url
*/
variable "kafka_zookeeper_connect" {
  type    = string
}