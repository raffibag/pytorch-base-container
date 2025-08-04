#!/bin/bash
set -e

echo "Building ML base container..."

# Build the base image
docker build -t ml-base:latest .

echo "Base container built successfully as ml-base:latest"