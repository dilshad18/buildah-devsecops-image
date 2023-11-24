
# Update the base image and install necessary packages
FROM fedora:latest
RUN dnf -y install buildah fuse-overlayfs awscli git tar python-pip python gzip && \
    dnf clean all

# Install Trivy with a specific version (adjust the URL)
RUN rpm -ivh https://github.com/aquasecurity/trivy/releases/download/v0.18.3/trivy_0.18.3_Linux-64bit.rpm && pip3 install semgrep

# Set short-name-mode to permissive
RUN sed -i 's/short-name-mode="enforcing"/short-name-mode="permissive"/' /etc/containers/registries.conf

# Create necessary directories (if still required)
RUN mkdir -p /var/lib/shared/overlay-images /var/lib/shared/overlay-layers && \
    touch /var/lib/shared/overlay-images/images.lock /var/lib/shared/overlay-layers/layers.lock

ENV _BUILDAH_STARTED_IN_USERNS="" BUILDAH_ISOLATION=chroot

# Download and install gitleaks
WORKDIR /tmp
RUN curl -L -o gitleaks.tar.gz https://github.com/zricethezav/gitleaks/releases/download/v8.18.0/gitleaks_8.18.0_linux_x64.tar.gz && \
    tar -zxvf gitleaks.tar.gz && \
    mv gitleaks /usr/local/bin && \
    rm gitleaks.tar.gz

# Set the working directory to /
WORKDIR /
