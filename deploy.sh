#!/bin/bash
set -e

# Update system
sudo dnf update -y

# Install Docker if not installed
if ! command -v docker &> /dev/null
then
  sudo dnf install docker -y
fi

# Enable & start Docker
sudo systemctl enable docker
sudo systemctl start docker

# Add ec2-user to docker group
sudo usermod -aG docker ec2-user

# Pull latest image
REGION=eu-north-1
ACCOUNT_ID=124355642518
REPO=aws-ci-cd-project

aws ecr get-login-password --region $REGION | \
docker login --username AWS --password-stdin \
$ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com

docker pull $ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com/$REPO:latest

# Stop old container if exists
docker stop flask-app || true
docker rm flask-app || true

# Run container
docker run -d -p 80:5000 --name flask-app \
$ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com/$REPO:latest
