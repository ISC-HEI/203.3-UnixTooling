# Dockerfile EngInCS, week 5, UNIX tooling
FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Europe/Zurich
ENV LANG=C.UTF-8
ENV LC_ALL=C.UTF-8

RUN apt-get update && apt-get install -y \
    bash \
    coreutils \
    grep \
    sed \
    gawk \
    findutils \
    procps \
    psmisc \
    wget \
    curl \
    less \
    vim \
    nano \
    man-db \
    manpages \
    manpages-posix \
    git \
    tree \
    file \
    time \
    bc \
    net-tools \
    iputils-ping \
    dnsutils \
    gzip \
    bzip2 \
    xz-utils \
    zip \
    unzip \
    build-essential \
    jq \
    python3 \
    python3-pip \
    ripgrep \
    fd-find \
    cron \
    sudo \
    locales \
    tzdata \
    bat \ 
    exa \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*


# Create a non-root user for students
RUN useradd -m -s /bin/bash -u 1000 student && \
    echo "student:student" | chpasswd && \
    usermod -aG sudo student && \
    echo "student ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Set up working directory structure
RUN mkdir -p /home/student/EngInCS/data && \
    chown -R student:student /home/student/EngInCS


# Copy exercises data
COPY data/ /home/student/EngInCS/data/

# Set ownership of all copied files
RUN chown -R student:student /home/student/EngInCS

# Remove default Ubuntu sudo message
RUN rm -f /etc/update-motd.d/* && \
    rm -f /var/run/motd.dynamic

# Create entrypoint script to fix work directory permissions
RUN echo '#!/bin/bash' > /entrypoint.sh && \
    echo '# Fix work directory permissions if needed' >> /entrypoint.sh && \
    echo 'if [ -d /home/student/EngInCS/work ] && [ ! -w /home/student/EngInCS/work ]; then' >> /entrypoint.sh && \
    echo '    sudo chown -R student:student /home/student/EngInCS/work' >> /entrypoint.sh && \
    echo '    sudo chmod -R u+w /home/student/EngInCS/work' >> /entrypoint.sh && \
    echo 'fi' >> /entrypoint.sh && \
    echo 'exec /bin/bash' >> /entrypoint.sh && \
    chmod +x /entrypoint.sh

# Create simple MOTD
RUN echo 'Welcome to ISC 203.3 - UNIX Tooling for Data Engineers' > /etc/motd && \
    echo '' >> /etc/motd && \
    echo 'Course repository: https://github.com/ISC-HEI/203.3-UnixTooling' >> /etc/motd && \
    echo 'Working directory: ~/EngInCS' >> /etc/motd && \
    echo 'Persistent data: ~/EngInCS/work (saved between sessions)' >> /etc/motd && \
    echo '' >> /etc/motd && \
    echo 'Type "ls" to see your files' >> /etc/motd && \
    echo 'Exercise data is available in ~/EngInCS/data' >> /etc/motd && \
    echo '' >> /etc/motd

# Create bashrc configuration
RUN echo '# Basic bash configuration' > /home/student/.bashrc && \
    echo 'export PATH="/usr/local/bin:$PATH"' >> /home/student/.bashrc && \
    echo 'export EDITOR=vim' >> /home/student/.bashrc && \
    echo 'export VISUAL=vim' >> /home/student/.bashrc && \
    echo '' >> /home/student/.bashrc && \
    echo '# Useful aliases' >> /home/student/.bashrc && \
    echo "alias ll='ls -lah'" >> /home/student/.bashrc && \
    echo "alias la='ls -A'" >> /home/student/.bashrc && \
    echo '' >> /home/student/.bashrc && \
    echo '# Colorful prompt' >> /home/student/.bashrc && \
    echo "PS1='\\[\\033[01;32m\\]\\u@unix-tooling\\[\\033[00m\\]:\\[\\033[01;34m\\]\\w\\[\\033[00m\\]\\$ '" >> /home/student/.bashrc && \
    echo '' >> /home/student/.bashrc && \
    echo '# Display MOTD' >> /home/student/.bashrc && \
    echo 'cat /etc/motd' >> /home/student/.bashrc

# Create a directory for persistent work
RUN mkdir -p /home/student/EngInCS/work && \
    chown -R student:student /home/student/EngInCS/work

# Switch to student user
USER student
WORKDIR /home/student/EngInCS

# Set entrypoint to fix permissions and start bash
ENTRYPOINT ["/entrypoint.sh"]
