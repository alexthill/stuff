FROM ubuntu:jammy

RUN apt-get -y update \
    && apt-get -y install curl \
    && apt-get -y install wget \
    && apt-get -y install build-essential \
    && apt-get -y install libssl-dev

# install and configure rust
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs -o rustup
RUN chmod +x rustup && ./rustup -y && rm rustup
RUN echo "[build]" > /root/.cargo/config.toml && echo 'target-dir = "/root/target"' >> /root/.cargo/config.toml

# install valkan sdk
RUN wget -qO - https://packages.lunarg.com/lunarg-signing-key-pub.asc | apt-key add -
RUN wget -qO /etc/apt/sources.list.d/lunarg-vulkan-1.3.296-jammy.list https://packages.lunarg.com/vulkan/1.3.296/lunarg-vulkan-1.3.296-jammy.list
RUN apt-get -y update \
    && apt-get -y install vulkan-sdk

# install shuttle
#RUN curl -L --proto '=https' --tlsv1.2 -sSf https://raw.githubusercontent.com/cargo-bins/cargo-binstall/main/install-from-binstall-release.sh | bash
#RUN $HOME/.cargo/bin/cargo binstall cargo-shuttle

EXPOSE 8000/tcp

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
#CMD ["tail", "-f"]
