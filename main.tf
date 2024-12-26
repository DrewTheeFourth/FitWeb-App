resource "aws_vpc" "fitweb" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = "Project-10"
  }
}

resource "aws_subnet" "fitweb_subnets" {
  count = length(var.public_subnet_cidr)
  vpc_id = aws_vpc.fitweb.id
  cidr_block = var.public_subnet_cidr[count.index]
  availability_zone = var.availability_zones[count.index]
  
  map_public_ip_on_launch = true

  tags = {
    Name = "PublicSubnet-${count.index + 1}"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.fitweb.id

  tags = {
    Name = "fitweb-igw"
  } 
}

resource "aws_security_group" "fitweb" {
  vpc_id = aws_vpc.fitweb.id

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "fitwebSG"
  }
}

resource "aws_route_table" "fitweb_rt" {
  vpc_id = aws_vpc.fitweb.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "FitwebRouteTable"
  }
}

resource "aws_route_table_association" "public_association" {
  count          = length(aws_subnet.fitweb_subnets)
  subnet_id      = aws_subnet.fitweb_subnets[count.index].id
  route_table_id = aws_route_table.fitweb_rt.id
}

resource "aws_ecs_cluster" "fitweb_ecs" {
  name = "fitweb-ecs-cluster"
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

resource "aws_iam_role_policy_attachment" "ecs_task_exec_attach" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}


resource "aws_ecs_task_definition" "fitweb_task" {
  family                   = "fitweb-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  cpu                      = "256"
  memory                   = "512"

  container_definitions = jsonencode([
    {
      name  = "fitweb-container"
      image = "nginx:latest"
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
        }
      ]
    }
  ])
}

resource "aws_ecs_service" "fitweb_service" {
  name            = "fitweb-service"
  cluster         = aws_ecs_cluster.fitweb_ecs.id
  task_definition = aws_ecs_task_definition.fitweb_task.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets = aws_subnet.fitweb_subnets[*].id
    security_groups = [aws_security_group.fitweb.id]
    assign_public_ip = true
  }
}
