provider "aws" {
  region = "us-east-1"
}

resource "aws_ecs_cluster" "my-cluster" {
  name = "my-cluster"
}

resource "aws_ecs_task_definition" "demo-task-def" {
  family = "demo-task-def"
  container_definitions = jsonencode([
    {
      name  = "my-app"
      image = "182183907325.dkr.ecr.us-east-1.amazonaws.com/my-repo/my-express-app:latest"
      portMappings = [
        {
          containerPort = 3000
          hostPort      = 3000
          protocol      = "tcp"
        }
      ]
    }
  ])
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  network_mode             = "awsvpc"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
}

resource "aws_iam_role" "ecs_task_execution_role" {
  name = "ecsTaskExecutionRole"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_policy_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
  role       = aws_iam_role.ecs_task_execution_role.name
}

resource "aws_ecs_service" "assessment-svc" {
  name            = "assessment-svc"
  cluster         = aws_ecs_cluster.my-cluster.id
  task_definition = aws_ecs_task_definition.demo-task-def.arn
  desired_count   = 1

  deployment_controller {
    type = "ECS"
  }

  load_balancer {
    target_group_arn = "arn:aws:elasticloadbalancing:us-east-1:182183907325:targetgroup/assessment-tg/32cc6b0601d0f8cd"
    container_name   = "my-app"
    container_port   = 3000
  }

  network_configuration {
    security_groups = ["sg-05064f0bf251ce9f8"]
    subnets         = ["subnet-0db72f817ecab42bd", "subnet-0ee400178514b6333"]
  }
}
