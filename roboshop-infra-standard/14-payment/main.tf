module "payment" {
    source = "../../roboshop-template-app"
    project_name = var.project_name
    environment = var.environment
    common_tags = var.common_tags

    #for target_group
    port        = var.port
    protocol    = var.protocol
    vpc_id      = data.aws_ssm_parameter.vpc_id.value
    # health_check = var.health_check

    #for launch template
    image_id = data.aws_ami.ami_id.id
    vpc_security_group_ids ="sg-0229582489f90de0b"
    user_data = filebase64("${path.module}/payments.sh")
    launch_template_tags = var.launch_template_tags

    #for auto-scalling groups
    vpc_zone_identifier = split(",",data.aws_ssm_parameter.private_subnet_ids.value)
    tags = var.auto_scalling_tags

    #providing listener rule details for https listener
    lb_listener_arn = data.aws_ssm_parameter.app-alb_listener_arn.value
    rule_priority = 50
    host_header = "payment.app.mydomainproject.tech"   
    #  #providing listener rule details for http listener
    # lb_listener_arn = data.aws_ssm_parameter.web-alb_listener_arn_http.value
    # rule_priority = 2
    # host_header = "mydomainproject.tech"

}