FROM debian:bookworm-slim

# Install base dependencies
RUN apt-get update && \
    apt-get install -y \
    # Emulator
    qemu-system-x86 qemu-kvm \
    # Homebrew dependencies
    build-essential procps curl git \
    # Build tools
    nasm dosfstools mtools \
    # Clean up apt cache
    && rm -rf /var/lib/apt/lists/*

# Set environment variables for non-interactive installs
ENV DEBIAN_FRONTEND=noninteractive
ENV NONINTERACTIVE=1

ENV HOMEBREW_MAKE_JOBS=4

# Install Homebrew
RUN /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Set Homebrew environment variables globally
ENV PATH="/home/linuxbrew/.linuxbrew/bin:/home/linuxbrew/.linuxbrew/sbin:$PATH"
RUN echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> /etc/profile

# Install the cross compiler through brew
RUN brew install x86_64-elf-gcc
# RUN brew install i386-elf-gdb - REVIEW ME, get a 64 bit version of GDB, check if it can work well with 32 bit code

WORKDIR /GBL

CMD [ "bash" ]
