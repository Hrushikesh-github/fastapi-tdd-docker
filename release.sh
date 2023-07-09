#!/bin/bash

# SSH connection details
SSH_USER="ubuntu"
SSH_HOST="13.234.225.241"
SSH_PORT="22"
SSH_PRIVATE_KEY="${{ secrets.SSH_PRIVATE_KEY }}"  # Assuming the secret name is SSH_PRIVATE_KEY

# Docker container details
CONTAINER_NAME="fastapi-tdd"
IMAGE_NAME="714116641665.dkr.ecr.us-east-1.amazonaws.com/ml-libraries:latest"

# Local port for port forwarding
LOCAL_PORT="5013"

# Create the SSH private key file
echo "$SSH_PRIVATE_KEY" > ./ssh_private_key
chmod 600 ./ssh_private_key

# SSH command to delete existing Docker container
ssh -i ./ssh_private_key -p "${SSH_PORT}" "${SSH_USER}@${SSH_HOST}" "docker rm -f ${CONTAINER_NAME}"

# SSH command with port forwarding
ssh -i ./ssh_private_key -p "${SSH_PORT}" -L "${LOCAL_PORT}:localhost:${LOCAL_PORT}" "${SSH_USER}@${SSH_HOST}" << EOF
  aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 714116641665.dkr.ecr.us-east-1.amazonaws.com
  docker run --name "${CONTAINER_NAME}" -e PORT=8765 -e DATABASE_URL=sqlite://sqlite.db -p "${LOCAL_PORT}:8765" "${IMAGE_NAME}"
EOF

# Remove the temporary SSH private key file
rm ./ssh_private_key
