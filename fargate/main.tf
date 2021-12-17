resource "aws_ecs_cluster" "hackathon_cloud_2021_1_0_0" {
  name = "hackathon_cloud_2021_1_0_0"
}

resource "aws_ecs_service" "hackathon_cloud_2021_1_0_0" {
  name = "hackathon-cloud-2021-1-0-0"
  task_definition = aws_ecs_task_definition.simple_rest_service.arn
  cluster = aws_ecs_cluster.hackathon_cloud_2021_1_0_0.id
  launch_type = "FARGATE"

  network_configuration {
    assign_public_ip = false
    security_groups = [
      aws_security_group.egress_all.id,
      aws_security_group.ingress_api.id,
    ]
    subnets = [
      aws_subnet.private_1a.id,
      aws_subnet.private_1b.id
    ]
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.hackathon_cloud_2021_1_0_0.arn
    container_name = "simple-rest-service"
    container_port = "8080"
  }

  desired_count = 2

  deployment_maximum_percent = 200
  deployment_minimum_healthy_percent = 50

}

# We'll eventually want a place to put our logs.
resource "aws_cloudwatch_log_group" "hackathon_cloud_2021_1_0_0" {
  name = "/ecs/hackathon-cloud-2021-1-0-0"
}

# Here's our task definition, which defines the task that will be running to provide
# our service. The idea here is that if the service decides it needs more capacity,
# this task definition provides a perfect blueprint for building an identical container.
resource "aws_ecs_task_definition" "simple_rest_service" {
  family = "hackathon-cloud-2021-1-0-0"

  container_definitions = jsonencode(
  [
    {
      name: "simple-rest-service",
      image: "ghcr.io/easimon/simple-rest-service:latest",
      portMappings: [
        {
          containerPort: 8080
        }
      ],
      logConfiguration: {
        "logDriver": "awslogs",
        "options": {
          "awslogs-region": "eu-central-1",
          "awslogs-group": "/ecs/hackathon-cloud-2021-1-0-0",
          "awslogs-stream-prefix": "ecs"
        }
      },
      healthCheck: {
        "command": [
          "CMD-SHELL",
          "curl -f http://localhost:8080/health || exit 1"
        ]
      }
    }
  ]
  )

  execution_role_arn = aws_iam_role.task_execution_role.arn

  # These are the minimum values for Fargate containers.
  cpu = 256
  memory = 512
  requires_compatibilities = [
    "FARGATE"
  ]

  # This is required for Fargate containers
  network_mode = "awsvpc"
}

# This is the role under which ECS will execute our task. This role becomes more important
# as we add integrations with other AWS services later on.

# The assume_role_policy field works with the following aws_iam_policy_document to allow
# ECS tasks to assume this role we're creating.
resource "aws_iam_role" "task_execution_role" {
  name = "hackathon-cloud-2021-1-0-0-task-execution-role"
  assume_role_policy = data.aws_iam_policy_document.ecs_task_assume_role.json
}

data "aws_iam_policy_document" "ecs_task_assume_role" {
  statement {
    actions = [
      "sts:AssumeRole"]

    principals {
      type = "Service"
      identifiers = [
        "ecs-tasks.amazonaws.com"]
    }
  }
}

# Normally we'd prefer not to hardcode an ARN in our Terraform, but since this is
# an AWS-managed policy, it's okay.
data "aws_iam_policy" "ecs_task_execution_role" {
  arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# Attach the above policy to the execution role.
resource "aws_iam_role_policy_attachment" "task_execution_role" {
  role = aws_iam_role.task_execution_role.name
  policy_arn = data.aws_iam_policy.ecs_task_execution_role.arn
}

resource "aws_lb_target_group" "hackathon_cloud_2021_1_0_0" {
  name = "hackathon-cloud-2021-1-0-0"
  port = 8080
  protocol = "HTTP"
  target_type = "ip"
  vpc_id = aws_vpc.hackathon_cloud_2021_1_0_0.id

  health_check {
    enabled = true
    path = "/health"
  }

  depends_on = [
    aws_alb.hackathon_cloud_2021_1_0_0]
}

resource "aws_alb" "hackathon_cloud_2021_1_0_0" {
  name = "hackathon-cloud-2021-1-0-0-lb"
  internal = false
  load_balancer_type = "application"

  subnets = [
    aws_subnet.public_1a.id,
    aws_subnet.public_1b.id
  ]

  security_groups = [
    aws_security_group.http.id,
    aws_security_group.https.id,
    aws_security_group.egress_all.id,
  ]

  depends_on = [
    aws_internet_gateway.igw
  ]
}

resource "aws_alb_listener" "hackathon_cloud_2021_1_0_0_http" {
  load_balancer_arn = aws_alb.hackathon_cloud_2021_1_0_0.arn
  port = "80"
  protocol = "HTTP"

  default_action {
    type = "redirect"
    redirect {
      port = "443"
      protocol = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_acm_certificate" "hackathon_cloud_2021_1_0_0" {
  domain_name = "hackathon-cloud-fargate-2021.micro-hive.com"
  validation_method = "DNS"
}

output "alb_url" {
  value = "http://${aws_alb.hackathon_cloud_2021_1_0_0.dns_name}"
}

output "domain_validations" {
  value = aws_acm_certificate.hackathon_cloud_2021_1_0_0.domain_validation_options
}

# These comments are here so Terraform doesn't try to create the listener
# before we have a valid certificate.
resource "aws_alb_listener" "hackathon_cloud_2021_1_0_0_https" {
  load_balancer_arn = aws_alb.hackathon_cloud_2021_1_0_0.arn
  port = "443"
  protocol = "HTTPS"
  certificate_arn = aws_acm_certificate.hackathon_cloud_2021_1_0_0.arn


  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.hackathon_cloud_2021_1_0_0.arn
  }
}

resource "aws_appautoscaling_target" "ecs_target" {
  max_capacity = 4
  min_capacity = 1
  resource_id = "service/${aws_ecs_cluster.hackathon_cloud_2021_1_0_0.name}/${aws_ecs_service.hackathon_cloud_2021_1_0_0.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace = "ecs"
}

resource "aws_appautoscaling_policy" "ecs_policy" {
  name = "scaling-on-load"
  policy_type = "TargetTrackingScaling"
  resource_id = aws_appautoscaling_target.ecs_target.resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_target.scalable_dimension
  service_namespace = aws_appautoscaling_target.ecs_target.service_namespace

  target_tracking_scaling_policy_configuration {
    target_value = 20
    scale_in_cooldown = 60
    scale_out_cooldown = 60

    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }
  }

}
