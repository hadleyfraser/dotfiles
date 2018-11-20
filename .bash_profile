# General Commands
alias _bash="vi ~/.bash_profile"
alias _bashrc="vi ~/.bashrc"
alias _source="source ~/.bash_profile"
alias ll="ls -li -a";
alias code='code-insiders .';
alias nwl="cisco_login origin ${ORIGIN_USER}; vpn_login"

# Git Commands
alias gs='git status';
alias gf='git fetch';
alias gb='git branch';
alias gbr='git branch -r';
alias gba='git branch -avv';
alias gitcane='git commit --amend --no-edit'

# NPM Commands
alias dev='yarn dev';
alias start='yarn start';
alias build='yarn build';
alias test='yarn test';
alias testfunc='yarn test:func';
alias testfuncnoclean='yarn test:func:noclean';
alias testmocha='yarn test:mocha';
alias lint='yarn lint';

# Setup other script commands
source ~/.bashrc
