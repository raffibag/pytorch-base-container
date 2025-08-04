# Base image for both training and inference containers
FROM pytorch/pytorch:2.1.2-cuda11.8-cudnn8-devel

# Set timezone to avoid interactive prompts
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=UTC

# Common system dependencies
RUN apt-get update && apt-get install -y \
    git \
    wget \
    curl \
    build-essential \
    libjpeg-dev \
    libpng-dev \
    && rm -rf /var/lib/apt/lists/*

# Upgrade pip and install wheel
RUN python -m pip install --upgrade pip setuptools wheel

# Install PyTorch with CUDA 11.8 support
RUN pip install --force-reinstall --no-cache-dir torch==2.1.2 torchvision==0.16.2 \
    --extra-index-url https://download.pytorch.org/whl/cu118

# Install xformers with CUDA 11.8 support
RUN pip install xformers --extra-index-url https://download.pytorch.org/whl/cu118

# Set common environment variables
ENV LD_LIBRARY_PATH=/usr/local/cuda/lib64:$LD_LIBRARY_PATH

# Create common directories
RUN mkdir -p /opt/ml/code /opt/ml/cache

WORKDIR /opt/ml/code