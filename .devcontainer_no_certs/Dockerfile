# Use Ubuntu base image for amd64 architecture
# LinuxBrew is not available for ARM (MacOS on M Silicon)
FROM --platform=linux/amd64 ubuntu:latest

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=UTC

# Set environment variables for non-interactive apt operations
ENV USER=vscode
ENV UID=1001
ENV GID=1001

# Update and upgrade system packages, then install prerequisites for Linuxbrew
RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y \
    build-essential \
    ca-certificates \
    curl \
    file \
    git \
    locales \
    procps \ 
    sudo

# Create a group and user with specific GID and UID
RUN groupadd -g $GID $USER && \
    useradd -m -s /bin/bash -u $UID -g $GID $USER && \
    echo "$USER ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Switch to the vscode user
USER $USER

# Install Linuxbrew for the vscode user
RUN /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" && \
    echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> ~/.bashrc && \
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

# Set PATH for Linuxbrew
ENV PATH="/home/linuxbrew/.linuxbrew/bin:/home/linuxbrew/.linuxbrew/sbin:$PATH"

# Linuxbrew Packages Installation
RUN brew install checkov gitversion git-flow git-lfs jq opentofu pre-commit snyk-cli terragrunt tflint trivy yamllint yq

# Set default shell environment
CMD ["/bin/bash"]
