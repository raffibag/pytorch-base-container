# Lean base with CUDA 11.8 runtime and cuDNN
FROM nvidia/cuda:11.8.0-runtime-ubuntu22.04

# Prevent interactive prompts during install
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=UTC

# Install lightweight Python 3.10 and minimal system libs
RUN apt-get update && apt-get install -y \
    python3.10 \
    python3-pip \
    python3-distutils \
    libjpeg-dev \
    libpng-dev \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Set python3.10 as default
RUN update-alternatives --install /usr/bin/python python /usr/bin/python3.10 1

# Upgrade pip and install necessary Python tooling
RUN python -m pip install --upgrade pip setuptools wheel

# Install PyTorch + torchvision + xformers (CUDA 11.8 compatible)
RUN pip install --no-cache-dir \
    torch==2.1.2 \
    torchvision==0.16.2 \
    xformers==0.0.23.post1 \
    --extra-index-url https://download.pytorch.org/whl/cu118

# Set CUDA library path
ENV LD_LIBRARY_PATH=/usr/local/cuda/lib64:$LD_LIBRARY_PATH

# Create standard directories
RUN mkdir -p /opt/ml/code /opt/ml/cache

# Clean up Python cache and bytecode
RUN rm -rf /root/.cache /tmp/* /var/tmp/* \
    && find /usr/local -depth -type d -name __pycache__ -exec rm -rf {} + \
    && find /usr/local -name '*.pyc' -delete

# Set working directory
WORKDIR /opt/ml/code
