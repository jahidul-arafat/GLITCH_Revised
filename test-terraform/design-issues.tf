resource "aws_instance" "very_long_resource_name_that_should_trigger_long_resource_smell_detection_in_glitch_analysis" {
  ami           = "ami-12345678"
  instance_type = "t2.micro"

  # Long statement with complex expression
  user_data = length(var.environment) > 0 && var.environment == "production" && var.enable_monitoring == true && var.instance_count >= 3 && contains(var.allowed_regions, "us-east-1") ? base64encode("production setup") : base64encode("development setup")

  tags = {
    Name        = "web-server"
    Environment = var.environment
    Project     = var.project_name
    Owner       = var.owner
    CostCenter  = var.cost_center
    Application = var.application
    Team        = var.team_name
    Version     = var.app_version
  }
}

# Duplicate resource
resource "aws_security_group" "web" {
  name        = "web-sg"
  description = "Web security group"
}

# Duplicate resource (exact same)
resource "aws_security_group" "web" {
  name        = "web-sg"
  description = "Web security group"
}

# Too many variables
variable "var1" { default = "value1" }
variable "var2" { default = "value2" }
variable "var3" { default = "value3" }
variable "var4" { default = "value4" }
variable "var5" { default = "value5" }
variable "var6" { default = "value6" }
variable "var7" { default = "value7" }
variable "var8" { default = "value8" }
variable "var9" { default = "value9" }
variable "var10" { default = "value10" }