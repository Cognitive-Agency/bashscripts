# Use the NVIDIA PyTorch image as a base
FROM nvcr.io/nvidia/pytorch:23.06-py3

# Specify the maintainer or author of the Dockerfile
LABEL maintainer="tim@cognitiveagency.ai"

# Install git, wget, curl
RUN apt-get update -q && apt-get install -y -q git wget curl && rm -rf /var/lib/apt/lists/*

# Download and execute the script
RUN wget https://raw.githubusercontent.com/Cognitive-Agency/bashscripts/main/coginstall-docker.sh && \
    chmod +x coginstall-docker.sh && \
    ./coginstall-docker.sh && \
    rm coginstall-docker.sh

# Set Zsh as the default shell
ENV SHELL /usr/bin/zsh

# Copy your .zshrc file into the container
COPY .zshrc /root/.zshrc

# Set a working directory
WORKDIR /workspace

# Start Zsh when the container runs
CMD ["zsh"]

