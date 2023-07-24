# Use the NVIDIA PyTorch image as a base
FROM nvcr.io/nvidia/pytorch:23.06-py3

# Specify the maintainer or author of the Dockerfile
LABEL maintainer="tim@cognitiveagency.ai"

# Install Zsh and other required packages
RUN apt-get update \
    && apt-get install -y zsh

# Set Zsh as the default shell
ENV SHELL /usr/bin/zsh

# Copy your .zshrc file into the container
COPY .zshrc /root/.zshrc

# Start Zsh when the container runs
CMD ["zsh"]

# Set a working directory
WORKDIR /workspace

# This command will run when the container starts (it's just an example and can be changed/removed)
CMD ["bash"]
