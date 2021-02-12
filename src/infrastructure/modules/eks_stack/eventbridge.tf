resource "aws_cloudwatch_event_bus" "event-bus" {
  name = "${var.cluster_name}-event-bus"
}