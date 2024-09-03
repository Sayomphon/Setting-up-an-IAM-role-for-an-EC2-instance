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
  - Purpose: This block specifies the cloud service provider, which in this case is AWS.
  - region: Defines the AWS region where the resources will be created. You can change this to any valid AWS region based on your requirements.
