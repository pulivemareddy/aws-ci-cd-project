#!/bin/bash
set -e

REGION=eu-north-1
ACCOUNT_ID=124355642518
REPO=aws-ci-cd-project

sudo systemctl start docker
sudo systemctl enable docker

aws ecr get-login-password --region $REGION \
| docker login --username AWS --password-stdin $ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com

docker stop flask-app || true
docker rm flask-app || true

docker pull $ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com/$REPO:latest

docker run -d -p 80:5000 --name flask-app \
$ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com/$REPO:latest
