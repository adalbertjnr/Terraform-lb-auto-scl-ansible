resource "aws_autoscaling_group" "ec2_scaling_group" {
  # availability_zones = var.availability_zones
  name               = var.scaling_group
  max_size           = var.max_size
  min_size           = var.min_size
  vpc_zone_identifier = [aws_subnet.the_real_subnet[0].id]
  launch_template {
    id      = aws_launch_template.ec2_template.id
    version = "$Latest"
  }
  target_group_arns = [aws_lb_target_group.lb_tg.arn]
}

resource "aws_autoscaling_policy" "auto_sc_policy" {
  name = var.policy_name
  autoscaling_group_name = aws_autoscaling_group.ec2_scaling_group.name
  policy_type = "TargetTrackingScaling"
  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = 80.0
  }
}

resource "aws_launch_template" "ec2_template" {
  name          = var.auto_scaling_ec2_name
  image_id      = "ami-09cd747c78a9add63"
  instance_type = var.instance
  key_name      = aws_key_pair.ssh_key.id
  tags = {
    Name = var.instance_name
  }
  vpc_security_group_ids = [aws_security_group.security_group["${var.sg_name}"].id]
  user_data = filebase64("template.sh")
}

resource "aws_key_pair" "ssh_key" {
  key_name   = var.ssh_name
  public_key = file(var.ssh_key_path)
}

resource "aws_instance" "ec2_instance" {
  ami           = "ami-09cd747c78a9add63"
  instance_type = var.instance
  key_name      = aws_key_pair.ssh_key.id
  vpc_security_group_ids = [aws_security_group.security_group["${var.sg_name}"].id]
  subnet_id = aws_subnet.the_real_subnet[0].id
  tags = {
    Name = var.instance_name
  }

  provisioner "remote-exec" {
    inline = ["echo 'waiting the ssh connection'"]

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file(var.ssh_private_key_path)
      host        = aws_instance.ec2_instance.public_ip
    }
  }

  provisioner "local-exec" {
    command = "ansible-playbook -i ${aws_instance.ec2_instance.public_ip}, ../../infra/playbooks/${var.playbook}.yml -u ubuntu --private-key ~/.ssh/ansible"
  }
}


