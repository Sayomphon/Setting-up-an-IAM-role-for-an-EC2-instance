# Setting-up-an-IAM-role-for-an-EC2-instance

In this task, you will log in as the Admin user and create an IAM role. The role allows Amazon Elastic Compute Cloud (Amazon EC2) to access both Amazon Simple Storage Service (Amazon S3) and Amazon DynamoDB. You will later assign this role to an EC2 instance that hosts the employee directory application.

# Setting by AWS API
1. Now that you are logged in as the Admin user, use the Services search bar to search for IAM again, and open the service by choosing IAM.
2. In the navigation pane, choose Roles.
3. Choose Create role.
4. In the Select trusted entity page, configure the following settings.
  -Trusted entity type: AWS service
  -Use case: EC2
5. Choose Next.
6. In the permissions filter box, search for amazons3full, and select AmazonS3FullAccess.
7. In the filter box, search for amazondynamodb, and select AmazonDynamoDBFullAccess.
8. Choose Next.
9. For Role name, paste S3DynamoDBFullAccessRole and choose Create role.

Note: We don’t recommend that you use full-access policies in a production environment. In this exercise, you use these policies as a proof of concept to get your exercise environment up and running quickly. After you create your S3 bucket and DynamoDB table, you can modify this IAM role so that it has more specific and restrictive permissions. You will learn more about this topic later.

# Setting by terraform

provider "aws" {
  region = "ap-southeast-1" # replace with your desired region
}
resource "aws_iam_role" "ec2_s3_dynamodb_role" {
  name = "S3DynamoDBFullAccessRole"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
  tags = {
    Environment = "Production"
  }
}
data "aws_iam_policy" "s3_full_access" {
  arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}
data "aws_iam_policy" "dynamodb_full_access" {
  arn = "arn:aws:iam::aws:policy/AmazonDynamoDBFullAccess"
}
resource "aws_iam_role_policy_attachment" "s3_full_access" {
  policy_arn = data.aws_iam_policy.s3_full_access.arn
  role       = aws_iam_role.ec2_s3_dynamodb_role.name
}
resource "aws_iam_role_policy_attachment" "dynamodb_full_access" {
  policy_arn = data.aws_iam_policy.dynamodb_full_access.arn
  role       = aws_iam_role.ec2_s3_dynamodb_role.name
}
