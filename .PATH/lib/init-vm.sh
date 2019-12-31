#!/bin/bash

# Install NVM
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.35.0/install.sh | zsh

curl -L git.io/antigen > ~/antigen.zsh
chsh -s /bin/zsh
echo 'export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
' >> ~/.zshrc

myDir=$(dirname $(dirname $PWD/$BASH_SOURCE))

echo "export PATH=\"\$PATH:$myDir/bin\"" >> ~/.zshrc

echo '
source ~/antigen.zsh
antigen bundle git
antigen bundle pip
antigen bundle lein
antigen bundle command-not-found
antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle zsh-users/zsh-autosuggestions
antigen bundle zsh-users/zsh-completions
antigen use oh-my-zsh
antigen theme zhann
antigen apply
' >> ~/.zshrc