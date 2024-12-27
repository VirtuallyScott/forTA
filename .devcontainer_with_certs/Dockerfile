# Use Ubuntu base image for amd64 architecture
# LinuxBrew is not available for ARM (MacOS on M Silicon)
FROM --platform=linux/amd64 ubuntu:latest

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=UTC
RUN echo 'Acquire::https::Verify-Peer "false";' >> /etc/apt/apt.conf.d/99-ignore-ssl

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
    sudo && \ 
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Copy the Zscaler certificate into the container
COPY zscaler.crt /usr/local/share/ca-certificates/zscaler.crt
RUN update-ca-certificates

ENV NODE_EXTRA_CA_CERTS=/usr/local/share/ca-certificates/zscaler.crt

# Configure Python to use the certificate
# Configure curl to use the certificate
# Configure wget to use the certificate
RUN mkdir -p /etc/pip && echo "[global]\ncert = /usr/local/share/ca-certificates/zscaler.crt" > /etc/pip/pip.conf && \
    echo "cacert=/usr/local/share/ca-certificates/zscaler.crt" >> /etc/curlrc && \
    echo "ca_certificate=/usr/local/share/ca-certificates/zscaler.crt" >> /etc/wgetrc
    
# Create a group and user with specific GID and UID
RUN groupadd -g $GID $USER && \
    useradd -m -s /bin/bash -u $UID -g $GID $USER && \
    echo "$USER ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Switch to the vscode user
USER $USER
WORKDIR /home/$USER

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
