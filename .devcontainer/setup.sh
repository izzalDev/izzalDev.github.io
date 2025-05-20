#!/bin/bash
echo "Setting up environment..."

apt-get update
apt-get install -y curl git openssh-server

echo "Environment setup complete"
