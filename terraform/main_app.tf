resource "aws_ecr_repository" "repo" {
  name                 = "tf-automation-repo"
  image_tag_mutability = "MUTABLE"
  image_scanning_configuration {
    scan_on_push = true
  }
}

#resource "aws_ecs_task_definition" "app-td" {
#  family                   = "app-td"
#  container_definitions    = <<EOF
#  [
#    {
#      "name": "app",
#      "image": "${aws_ecr_repository.repo.repository_url}:${var.image_tag}",
#      "essential": true,
#      "portMappings": [
#        {
#          "containerPort" : 80,
#          "hostPort" : 80
#        }
#      ],
#      "memory": 512,
#      "cpu": 256
#    }
#  ]
#  EOF
#  requires_compatibilities = ["FARGATE"]
#  network_mode             = "awsvpc"
#  memory                   = 512
#  cpu                      = 256
#  execution_role_arn       = aws_iam_role.ecsTaskExecutionRole.arn
#}
#
#resource "aws_iam_role" "ecsTaskExecutionRole" {
#  name               = "ecsTaskExecutionRole-tf"
#  assume_role_policy = data.aws_iam_policy_document.aws_iam_policy_document.json
#}
#
#data "aws_iam_policy_document" "aws_iam_policy_document" {
#  statement {
#    actions = ["sts:AssumeRole"]
#    principals {
#      type        = "Service"
#      identifiers = ["ecs-tasks.amazonaws.com"]
#    }
#  }
#}
#
#resource "aws_ecs_cluster" "app-ecs" {
#  name = "app-cluster"
#}
#
#resource "aws_ecs_service" "app-ecs-service" {
#  name            = "app-ecs-service"
#  launch_type     = "FARGATE"
#  desired_count   = 1
#  cluster         = aws_ecs_cluster.app-ecs.id
#  task_definition = aws_ecs_task_definition.app-td.arn
#
#  network_configuration {
#    subnets = module.vpc.public_subnets
#    security_groups  = ["${aws_security_group.lb-sg.id}"]
#    assign_public_ip = true
#  }
#
#  load_balancer {
#    target_group_arn = aws_lb_target_group.app-tg.arn
#    container_port   = 80
#    container_name   = "app"
#  }
#}
#
#resource "aws_iam_role_policy_attachment" "attach" {
#  role       = aws_iam_role.ecsTaskExecutionRole.name
#  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
#}
//////////////////////////////////////////////////////////////////////
#resource "aws_appautoscaling_target" "ecs-target" {
#  max_capacity       = 5
#  min_capacity       = 1
#  resource_id        = "service/${aws_ecs_cluster.app-ecs.id}/${aws_ecs_service.app-ecs-service.name}"
#  scalable_dimension = "ecs:service:DesiredCount"
#  service_namespace = "ecs"
#}
#
#resource "aws_appautoscaling_policy" "ecs-policy" {
#  name               = "ecs-autoscaling-policy"
#  policy_type        = "TargetTrackingScaling"
#  resource_id        = aws_appautoscaling_target.ecs-target.resource_id
#  scalable_dimension = aws_appautoscaling_target.ecs-target.scalable_dimension
#  service_namespace = aws_appautoscaling_target.ecs-target.service_namespace
#
#  target_tracking_scaling_policy_configuration {
#    predefined_metric_specification {
#      predefined_metric_type = "ECSServiceAverageCPUUtilization"
#    }
#    target_value = 50
#  }
#}
#
#resource "aws_appautoscaling_policy_attachment" "ecs-attach" {
#  policy_arn = aws_appautoscaling_policy.ecs-policy.arn
#  target_arn = aws_appautoscaling_target.ecs-target.arn
#}