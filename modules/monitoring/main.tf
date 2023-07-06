resource "null_resource" "install_python_dependencies" {
  triggers = {
    file_change = filebase64sha256("${path.module}/layer/requirements.txt")
  }
  provisioner "local-exec" {
    working_dir = "${path.module}/layer"
    command     = "mkdir python && pip install -t python -r requirements.txt && rm -rf python/*dist-info __pycache__ && zip -rq9 python_dependecies.zip python && rm -rf python"
  }
}

data "archive_file" "zip_lambda" {
  type        = "zip"
  source_file = "${path.module}/lambda/ec2_lambda_handler.py"
  output_path = "${path.module}/lambda/ec2_lambda_handler.zip"
}

resource "aws_lambda_layer_version" "layer_dependencies" {
  filename   = "${path.module}/layer/python_dependecies.zip"
  layer_name = "python_dependecies"

  source_code_hash = filebase64sha256("${path.module}/layer/python_dependecies.zip")

  compatible_runtimes = ["python3.7"]

  depends_on = [
    null_resource.install_python_dependencies
  ]
}

resource "aws_lambda_function" "stop_ec2_lambda" {
  filename      = "${path.module}/lambda/ec2_lambda_handler.zip"
  function_name = "stopEC2Lambda"
  role          = var.stop_start_ec2_role_arn
  handler       = "ec2_lambda_handler.stop"

  source_code_hash = data.archive_file.zip_lambda.output_base64sha256

  runtime     = "python3.7"
  memory_size = "250"
  timeout     = "60"

  layers = [aws_lambda_layer_version.layer_dependencies.arn]

  environment {
    variables = {
      DISCORD_WEBHOOK_URL = var.discord_webhook_url
    }
  }
}

# resource "aws_cloudwatch_event_rule" "ec2_stop_rule" {
#   name                = "StopEC2Instances"
#   description         = "Stop EC2 nodes at 2:00 everyday"
#   schedule_expression = "cron(0 2 ? * * *)"
# }

# resource "aws_cloudwatch_event_target" "ec2_stop_rule_target" {
#   rule = aws_cloudwatch_event_rule.ec2_stop_rule.name
#   arn  = aws_lambda_function.stop_ec2_lambda.arn
# }

# resource "aws_lambda_permission" "allow_cloudwatch_stop" {
#   statement_id  = "AllowExecutionFromCloudWatch"
#   action        = "lambda:InvokeFunction"
#   function_name = aws_lambda_function.stop_ec2_lambda.function_name
#   principal     = "events.amazonaws.com"
# }

resource "aws_lambda_function" "start_ec2_lambda" {
  filename      = "${path.module}/lambda/ec2_lambda_handler.zip"
  function_name = "startEC2Lambda"
  role          = var.stop_start_ec2_role_arn
  handler       = "ec2_lambda_handler.start"

  source_code_hash = data.archive_file.zip_lambda.output_base64sha256

  runtime     = "python3.7"
  memory_size = "250"
  timeout     = "60"

  layers = [aws_lambda_layer_version.layer_dependencies.arn]

  environment {
    variables = {
      DISCORD_WEBHOOK_URL = var.discord_webhook_url
    }
  }
}

# resource "aws_cloudwatch_event_rule" "ec2_start_rule" {
#   name                = "StartEC2Instances"
#   description         = "Start EC2 nodes at 18:00 everyday"
#   schedule_expression = "cron(0 18 ? * * *)"
# }

# resource "aws_cloudwatch_event_target" "ec2_start_rule_target" {
#   rule = aws_cloudwatch_event_rule.ec2_start_rule.name
#   arn  = aws_lambda_function.start_ec2_lambda.arn
# }

# resource "aws_lambda_permission" "allow_cloudwatch_start" {
#   statement_id  = "AllowExecutionFromCloudWatch"
#   action        = "lambda:InvokeFunction"
#   function_name = aws_lambda_function.start_ec2_lambda.function_name
#   principal     = "events.amazonaws.com"
# }
