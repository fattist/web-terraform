[
  {
    "cpu": ${cpu},
    "memory": ${memory},
    "memoryReservation": 1024,
    "essential": true,
    "hostname": "platform",
    "image": "902832525235.dkr.ecr.us-west-2.amazonaws.com/platform:0df6201",
    "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
        "awslogs-group": "${cloudwatch_group_name}",
        "awslogs-region": "${region}",
        "awslogs-stream-prefix": "${environment}"
      }
    },
    "mountPoints": [{
      "sourceVolume": "platform-data",
      "containerPath": "/data"
    },{
      "sourceVolume": "platform-data",
      "containerPath": "/var/log/platform"
    }],
    "name": "platform",
    "portMappings": [{
      "hostPort": 3000,
      "containerPort": 3000
    }],
    "volumes": [{
      "name": "platform-data",
      "host": {
        "sourcePath": "/mnt/ebs"
      }
    }]
  }
]
