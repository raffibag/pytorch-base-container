# Base Container for AI/ML Training and Inference

This is the shared base container for both Kohya training and Stable Diffusion inference containers.

## Base Image
- `pytorch/pytorch:2.1.2-cuda11.8-cudnn8-devel`

## Common Components
- PyTorch 2.1.2 with CUDA 11.8 support
- Common system libraries (git, wget, curl, build tools, image libraries)
- Python environment setup (pip, setuptools, wheel)
- xformers with CUDA 11.8 support
- Standard ML directories (/opt/ml/code, /opt/ml/cache)

## Building
```bash
docker build -t ml-base:latest .
```

## Usage
This image is intended to be used as a base for other containers:

```dockerfile
FROM ml-base:latest
# Add your specific components here
```