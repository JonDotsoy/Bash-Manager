# =============================== Theme to Bash ================================

# get current git branch name
function git_branch {
    export gitbranch=[$(git rev-parse --abbrev-ref HEAD 2>/dev/null)${gitstatus}]
    if [ "$?" -ne 0 ]
      then gitbranch=
    fi
    if [[ "${gitbranch}" == "[]" ]]
      then gitbranch=
    fi
}
 
# set usercolor based on whether we are running with Admin privs
function user_color {
    id | grep "Admin" > /dev/null
    RETVAL=$?
    if [[ $RETVAL == 0 ]]; then
        usercolor="[0;35m";
    else
        usercolor="[0;32m";
    fi
}
 
# set TTYNAME
function ttyname() { export TTYNAME=$@; }
 
# Set prompt and window title
inputcolor='[0;37m'
cwdcolor='[1;32m'
gitcolor='[1;31m'
colorstatusgit='[2;33m'
user_color
 
# Setup for window title
export TTYNAME=$$
function settitle() {
  p=$(pwd);
  let l=${#p}-25
  if [ "$l" -gt "0" ]; then
    p=..${p:${l}}
  fi
  t="$TTYNAME $p"
  echo -ne "\e]2;$t\a\e]1;$t\a";
}

function existsastatus() {
    p=$(git status -s 2>/dev/null);
    if [[ "$p" == "" ]]; then
        export gitstatus="";
    else
        export gitstatus=" ✔";
    fi
}

function getPWD(){
  if [[ `pwd` == "/" ]]; then
    export PWDSHOW="(/)"
  else
    _PWDSHOW="${PWD##*/}"
    # export cwdcolor='[1;32m'
    export PWDSHOW="(${_PWDSHOW})"
  fi
  export PWDSHOW="`hostname`:${PWDSHOW}"
}


PROMPT_COMMAND='getPWD;existsastatus;settitle;git_branch;history -a;'
# export PS1='\[\e${usercolor}\][\u]\[\e${gitcolor}\]${gitbranch}\[\e${cwdcolor}\][$PWD]${gitstatus}\[\e${inputcolor}\] $ '
export PS1='\[\e${inputcolor}\]\[\e${cwdcolor}\]${PWDSHOW}\[\e${colorstatusgit}\]${gitbranch}\[\e${inputcolor}\]\n> '
# »