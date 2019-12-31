FROM ubuntu:bionic-20191029

# docker build . -t nhibiki/dev:env
LABEL maintainer="NHibiki<i@yuuno.cc>"

# Deploy Entrypoint
RUN echo 'sleep infinity' > /hang.sh \
    && chmod a+x /hang.sh

# Setting up Entrypoint
ENTRYPOINT ["sh", "/hang.sh"]

# Install Systems Essentials
RUN apt-get update \
    && apt-get install -y git zsh curl vim screen htop wget openssh-server python3 python3-distutils python3-pip \
    && mkdir -p ~/.ssh \
    && pip3 install httpie \
    && apt clean \
    && rm -rf /var/lib/apt/lists/

# Install From Networks
RUN curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.35.0/install.sh | zsh \
    && chsh -s /bin/zsh \
    && curl -L git.io/antigen > ~/antigen.zsh \
    && zsh -c "source ~/.zshrc && nvm install v12.13.0"

# Config ZSH
RUN echo 'export NVM_DIR="$HOME/.nvm"\n\
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm\n\
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion\n\
\n\
export PATH="$PATH:/root/workspace/.PATH/bin"\n\
\n\
source ~/antigen.zsh\n\
antigen bundle git\n\
antigen bundle pip\n\
antigen bundle lein\n\
antigen bundle command-not-found\n\
antigen bundle zsh-users/zsh-syntax-highlighting\n\
antigen bundle zsh-users/zsh-autosuggestions\n\
antigen bundle zsh-users/zsh-completions\n\
antigen use oh-my-zsh\n\
antigen theme zhann\n\
antigen apply\n\
\n'\
> ~/.zshrc

RUN zsh -c "source ~/.zshrc && nvm install v12.13.0"