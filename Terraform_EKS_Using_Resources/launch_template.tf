resource "aws_launch_template" "eks_node_launch_template" {
  name_prefix   = "eks-node-launch-template-"
  image_id      = data.aws_ami.eks_worker_ami.id
  instance_type = "t3.medium"
  block_device_mappings {
    device_name = "/dev/sdf"

    ebs {
      volume_size = 20
    }
  }

  user_data = data.cloudinit_config.eks_node_userdata.rendered

  vpc_security_group_ids = [
    aws_security_group.eks_node_security_group.id
  ]

  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 1
    instance_metadata_tags      = "enabled"
  }

  monitoring {
    enabled = true
  }

  tag_specifications {
    resource_type = "instance"

    tags = {
      Environment = var.environment
      Name        = "superstore-eks-node"
    }
  }
}