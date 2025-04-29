output "launch_template_id" {
  description = "The ID of your custom EC2 Launch Template"
  value       = aws_launch_template.custom.id
}

output "asg_names" {
  description = "Names of the 3 ASGs that were created"
  value       = aws_autoscaling_group.dor[*].name
}

output "tg_arn" {
  description = "ARN of the ALB Target Group"
  value       = data.aws_lb_target_group.app_tg.arn
}


