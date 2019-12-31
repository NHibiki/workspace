FROM gitpod/workspace-full:latest

USER root
# Install custom tools, runtime, etc.
ADD .PATH /home/gitpod/.PATH

RUN apt-get update && apt-get install -y git sshfs vim screen htop wget zsh curl openssh-server python3 python3-distutils \
    && curl https://bootstrap.pypa.io/get-pip.py | python3 \
    && pip3 install httpie \
    && apt clean \
    && rm -rf /var/lib/apt/lists/ \
    && rm -rf /var/cache/apt/* \
    && rm -rf /tmp/* \
    && chsh -s /bin/zsh gitpod \
    && mkdir -p /home/gitpod/.ssh \
    && cd /home/gitpod \
    && curl -OL https://raw.githubusercontent.com/creationix/nvm/v0.35.0/install.sh \
    && curl -OL git.io/antigen \
    && mv antigen antigen.zsh \
    && curl -OL https://gist.githubusercontent.com/NHibiki/c93f2171c30759376a07539c29c17387/raw/fcdd7d98c664045706625d22c6971667b68ed8cb/.zshrc \
    && chown -R gitpod:gitpod /home/gitpod

USER gitpod
# Apply user-specific settings

RUN echo "Install NVM" \
    && /bin/zsh -c "source ~/.zshrc && nvm install v12.13.0" \
    && echo "Install Complete"

# Give back control
USER root
