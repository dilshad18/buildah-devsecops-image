FROM fedora:latest
# Add metadata labels
LABEL maintainer="ahmad.mdilshad@gmail.com" \
      version="1.0" \
      description="Custom buildah image with Trivy"

RUN dnf -y install buildah fuse-overlayfs awscli --exclude container-selinux && \
    dnf clean all

# Install Trivy with a specific version (adjust the URL)
RUN rpm -ivh https://github.com/aquasecurity/trivy/releases/download/v0.18.3/trivy_0.18.3_Linux-64bit.rpm

# Set short-name-mode to permissive
RUN sed -i 's/short-name-mode="enforcing"/short-name-mode="permissive"/' /etc/containers/registries.conf

# Create necessary directories (if still required)
RUN mkdir -p /var/lib/shared/overlay-images /var/lib/shared/overlay-layers && \
    touch /var/lib/shared/overlay-images/images.lock /var/lib/shared/overlay-layers/layers.lock

ENV _BUILDAH_STARTED_IN_USERNS="" BUILDAH_ISOLATION=chroot
