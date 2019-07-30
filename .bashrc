# Checks out the passed feature branch ticket number
function gc() {
    # if there is no parameter then return
    if (( $# != 1 ))
    then
        echo "Ticket number or develop|master required required as first parameter."
        echo "Usage: gc xxx"
        return
    fi

    if [[ $1 =~ ^(develop|master)$ ]]
    then
        branch=$1;
    else
        get_branch $1;
    fi

    git checkout $branch;
    git pull;
}

# Merges the passed feature branch ticket number into the current branch
function gm() {
    # if there is no parameter then return
    if (( $# != 1 ))
    then
        echo "Ticket number is required required as first parameter."
        echo "Usage: gm xxx"
        return
    fi

    get_branch $1
    git merge $branch;
}

# Commits the current changes with the specified message
function gcm() {
    # if there is no parameter then return
    if (( $# == 0 ))
    then
        echo "Commit message required"
        echo "Usage: gcm 'PBS-XXX Commit message'"
        return
    fi

    git add .;
    git commit -m "$1" $2;
}

# searches for the passed feature branch ticket number
function get_branch(){
    # initialize the branches variable
    branches=()

    # pull all git branches into the branches variable
    eval "$(git for-each-ref --shell --format='branches+=(%(refname))' refs/heads/)";

    # remove the refs/heads/ from the branch names
    branches=("${branches[@]/refs\/heads\//}")

    # loop through all of the branches and find the passed branch ticket and check it out
    for branch in ${branches[@]}
    do
        # if we have found the branch check it out and exit the function
        if [[ $branch = $1 || $branch =~ ^((PBS|SAT)-)?$1.*$ ]]
        then
            branch=$branch;
            return
        fi
    done

    # feature wasn't found so let them know
    echo "No feature, bugfixes or release branches found for ticket $1";
    kill -INT $$;
}

integrationBranch() {
  integrationBranch=$1
  baseBranch=$2
  mergeBranch=$3
  if [ -z "$1" ] || [ -z "$2" ] || [ -z "$3" ]; then
    echo "Some parameters missing"
    echo "Usage: integrationBranch integration-branch base-branch merge-branch"
  else
    gc master
    gb -D "$integrationBranch"
    gc "$baseBranch"
    git pull
    git checkout -b "$integrationBranch"
    git merge "$mergeBranch" --no-edit
    git push --set-upstream origin "$integrationBranch" -f
    gc "$mergeBranch"
  fi
}

gitlog() {
  count=5
  if (( $# == 1 ))
  then
    count=$1
  fi
  git log --oneline -$count
}

delete_password() {
  security delete-generic-password -s company -a $USER
}

set_password() {
  security add-generic-password -s company -a $USER -w
}

get_password() {
  echo $(security find-generic-password -s company -a $USER -w)
}

cisco_login() {
  echo "Logging in..."

  RESULT=$(curl -s --max-time 2 'http://1.1.1.1/login.html' -H 'Content-Type: application/x-www-form-urlencoded' --data "username=$USER&password=$(urlencode $(get_password))")

  if [[ $RESULT = *"Login Successful"* ]]; then
    echo "Login Successful!"
  elif [[ $RESULT = *"Login Error"* ]]; then
    echo "Bad username or password"
    echo $RESULT
  elif [[ $RESULT = *"Web Authentication Failure"* ]]; then
    echo "You're already logged in :)"
  else
    echo "Hmm... you got an unexpected error"
    echo $RESULT
  fi
}

vpn_login() {
  open "https://productivity.orgn.io/"
}

urlencode() {
    # urlencode <string>
    old_lc_collate=$LC_COLLATE
    LC_COLLATE=C
    
    local length="${#1}"
    for (( i = 0; i < length; i++ )); do
        local c="${1:i:1}"
        case $c in
            [a-zA-Z0-9.~_-]) printf "$c" ;;
            *) printf '%%%02X' "'$c" ;;
        esac
    done
    
    LC_COLLATE=$old_lc_collate
}


checkport() {
  lsof -nP -i4TCP:$1 | grep LISTEN
}

# Kill process on port
killport() {
    lsof -n -i4TCP:$1 | grep LISTEN | awk '{ print $2 }' | xargs kill
}

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
