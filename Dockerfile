# CUDA 11.8 + cuDNN runtime + Ubuntu 22.04 base
FROM nvidia/cuda:11.8.0-cudnn8-runtime-ubuntu22.04

# Prevent apt prompts and set timezone
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=UTC

# Install Python and essential runtime deps (no Conda)
RUN apt-get update && apt-get install -y --no-install-recommends \
    python3.10 \
    python3-pip \
    python3-distutils \
    libgomp1 \
    libgl1 \
    libglib2.0-0 \
    libjpeg-dev \
    libpng-dev \
    zlib1g \
    libstdc++6 \
    libgcc1 \
    curl \
    ca-certificates \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Set python3.10 as default
RUN update-alternatives --install /usr/bin/python python /usr/bin/python3.10 1

# Upgrade pip
RUN python -m pip install --upgrade pip setuptools wheel

# [Optional] Install PyTorch manually (or copy your torch stack install)
# You may pin to exact torch version + CUDA matching wheels
RUN pip install --no-cache-dir \
    torch==2.1.2 \
    torchvision==0.16.2 \
    xformers==0.0.23.post1 \
    --extra-index-url https://download.pytorch.org/whl/cu118

# Set LD_LIBRARY_PATH for CUDA
ENV LD_LIBRARY_PATH=/usr/local/cuda/lib64:$LD_LIBRARY_PATH

# Create default work directory
RUN mkdir -p /opt/ml/code /opt/ml/cache
WORKDIR /opt/ml/code

# Optional: clean up .pyc, __pycache__, and pip cache
RUN rm -rf /root/.cache /tmp/* /var/tmp/* && \
    find /usr/local -depth -type d -name __pycache__ -exec rm -rf {} + && \
    find /usr/local -name '*.pyc' -delete

# Use this as your lean but inference-ready base