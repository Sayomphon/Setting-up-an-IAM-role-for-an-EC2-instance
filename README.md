# Setting up an IAM role for an EC2 instance

In this task, you will log in as the Admin user and create an IAM role. The role allows Amazon Elastic Compute Cloud (Amazon EC2) to access both Amazon Simple Storage Service (Amazon S3) and Amazon DynamoDB. You will later assign this role to an EC2 instance that hosts the employee directory application.

## Setting by AWS Management Console
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

## Setting by terraform
### 1. Provider Block
```hcl
provider "aws" {
  region = "ap-southeast-1" # replace with your desired region
}
```
  - **Purpose**: This block specifies the cloud service provider, which in this case is AWS.
  - **region**: Defines the AWS region where the resources will be created. You can change this to any valid AWS region based on your requirements.
### 2. IAM Role Resource
```hcl
resource "aws_iam_role" "s3_dynamodb_role" {
  name = "S3DynamoDBFullAccessRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}
```
  - **resource "aws_iam_role"**: This creates a new IAM role in AWS.
  - **name**: Specifies the name of the IAM role, which is "S3DynamoDBFullAccessRole".
  - **assume_role_policy**:
    - This JSON policy defines who can assume this role.
    - **Version**: The policy language version; "2012-10-17" is the current version.
    - **Statement**: Contains permission statements.
      - **Action**: Specifies the action allowed, which is "sts:AssumeRole" in this case.
      - **Effect**: Indicates whether the statement allows or denies access, and here it allows access.
      - **Principal**: Specifies the service that can assume this role; "ec2.amazonaws.com" allows EC2 instances to use this role.
### 3. IAM Policy Attachments
These blocks attach the necessary permissions to the role created above:
  - **S3 Policy Attachment**
```hcl
resource "aws_iam_policy_attachment" "s3_attachment" {
  name       = "s3-attachment"
  roles      = [aws_iam_role.s3_dynamodb_role.name]
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}
```
  - **resource "aws_iam_policy_attachment"**: This resource links IAM policies to IAM roles.
  - **name**: Identifier for the policy attachment.
  - **roles**: Links the policy to the created IAM role.
  - **policy_arn**: The Amazon Resource Name (ARN) for the Amazon S3 Full Access policy. This allows the role to perform any action on S3.
