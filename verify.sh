#!/bin/bash

echo ""
echo "Installed Versions"
echo "------------------"

echo -n "Homebrew: "
brew --version | head -1

echo -n "Git: "
git --version

echo -n "GitHub CLI: "
gh --version | head -1

echo -n "Python: "
python3 --version

echo -n "AWS CLI: "
aws --version

echo -n "Terraform: "
terraform version | head -1

echo -n "kubectl: "
kubectl version --client

echo -n "Docker: "
docker --version

echo -n "Node: "
node --version

echo -n "npm: "
npm --version
