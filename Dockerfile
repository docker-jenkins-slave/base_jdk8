FROM ubuntu:16.04

MAINTAINER adam v0.1

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && \
    apt-get -y upgrade && \
    apt-get install -y wget git && \
    rm -rf /var/lib/apt/lists/*

# Add jenkins user with "jenkins" password
RUN adduser -disabled-password --gecos '' --quiet jenkins && \
    echo "jenkins:jenkins" | chpasswd

# Install a basic SSH server
RUN apt-get update && \
    apt-get install -y openssh-server && \
    sed -i 's|session    required     pam_loginuid.so|session    optional pam_loginuid.so|g' /etc/pam.d/sshd && \
    mkdir -p /var/run/sshd && \
    rm -rf /var/lib/apt/lists/*

# As of Android N:
# The master branch of Android in the Android Open Source Project (AOSP)
# requires Java 8. On Ubuntu, use OpenJDK.
RUN apt-get update && \
    apt-get install -y software-properties-common && \
    apt-get install -y openjdk-8-jdk && \
    rm -rf /var/lib/apt/lists/*

# Standard SSH port
EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]
