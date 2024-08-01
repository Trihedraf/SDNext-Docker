FROM debian:stable
RUN apt-get update && apt-get install -y \
    git \
    python3 \
    python3-venv \
    libpython3-dev \
    libgl1 \
    libglib2.0-0 \
    build-essential \
    && rm -rf /var/lib/apt/lists/*
WORKDIR /app
EXPOSE 7860
ARG USERNAME=user
ARG USER_UID=1000
ARG USER_GID=$USER_UID
RUN groupadd --gid $USER_GID $USERNAME \
    && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME
USER $USERNAME
ENTRYPOINT [ -e "/app/webui.sh" ] \
    && git pull \
    && ./webui.sh --listen --allow-code --insecure --use-xformers \
    || git clone https://github.com/vladmandic/automatic . \
    && ./webui.sh --listen --allow-code --insecure --use-xformers
