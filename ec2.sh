#!/bin/bash

set -e

aws_cli(){

# Check if 'aws' command is available
if command -v aws &> /dev/null; then
    echo "AWS CLI is installed."
else
    echo "AWS CLI is not installed. Please install it first." >&2
    exit 1
fi
}
#aws_cli


install_awscli() {
    echo "Installing AWS CLI v2 on Linux..."

    # Download and install AWS CLI v2
    curl -s "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
    sudo apt-get install -y unzip &> /dev/null
    unzip -q awscliv2.zip
    sudo ./aws/install

    # Verify installation
    aws --version

    # Clean up
    rm -rf awscliv2.zip ./aws
}

#install_awscli


aws_ec2(){

echo "installing ec2 with all details "

# Variables for AWS CLI command
AMI_ID="ami-04a81a99f5ec58529"  # Replace with your desired AMI ID
INSTANCE_TYPE="t2.micro"
KEY_NAME="ansible1"
SECURITY_GROUP_ID="sg-04837982f62123628"  # Replace with your security group ID
SUBNET_ID="subnet-06129f6a2a2cdf843"      # Replace with your subnet ID
TAG_KEY="my-first-ec2"
TAG_VALUE="MyEC2Instance-123"

# AWS CLI command to create EC2 instance
aws ec2 run-instances \
    --image-id "$AMI_ID" \
    --count 2 \
    --instance-type "$INSTANCE_TYPE" \
    --key-name "$KEY_NAME" \
    --security-group-ids "$SECURITY_GROUP_ID" \
    --subnet-id "$SUBNET_ID" \
    --tag-specifications "ResourceType=instance,Tags=[{Key=$TAG_KEY,Value=$TAG_VALUE}]" \
    --output text \
    --query 'Instances[0].InstanceId'

# Check if the instance creation was successful
if [ $? -eq 0 ]; then
    echo "EC2 instance creation initiated successfully."
else
    echo "Failed to create EC2 instance." >&2
    exit 1
fi
}

#aws_ec2




aws_terminate()
{
	aws ec2 terminate-instances --instance-ids "${INSTANCE_IDS[@]}"

