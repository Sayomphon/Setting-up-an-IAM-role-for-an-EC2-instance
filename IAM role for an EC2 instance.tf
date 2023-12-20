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