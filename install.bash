#!/bin/bash

# 
# let write = you => code()
# 

# Log Event
function log {
    local TYPE="$(echo ${1} | tr "[:lower:]" "[:upper:]")"
    local MESSAGE="${2}"

    if [[ "${MESSAGE}" == "" ]]
        then
        MESSAGE="${TYPE}"
        TYPE="LOG"
    fi

    echo "[${TYPE}]: ${MESSAGE}"
}


# Declare Variables
declare V=""  # Define Versio to download.
declare PV="" # Prepath to download version.
declare E=""  # URL Download.
declare I=""  # Temporal file download.
declare P=""  # Path to instalation.
declare R=""  # Name to folder instalation

# Define Version Download
if [[ "${BASHM_VERSION_TO_INSTALL}" == "" ]]
    then
    V="latest"
    PV=""
else
    V="${BASHM_VERSION_TO_INSTALL}"
    PV="/v${V}"
fi

E="https://api.github.com/repos/jonDotsoy/Bash-Manager/tarball${pV}"
I="/tmp/bashm-${V}.tar.gz"
P="$HOME"
R="bashm-${V}"

echo "
Configuration to install Bash-Manager
=====================================

Version              : ${V}
URL File             : ${E}
Files Temporal       : ${I}
Name Directory BashM : ${R}
Path Installation    : ${P}
"


# Check dependencies
declare errorDependences="false"

function checkDependencie {
    local elementFind="${1}"
    local isError="false"
    # echo "Checking ${elementFind}..."
    which "${elementFind}" &> /dev/null || isError="true"

    if [[ "${isError}" == "true" ]]
        then
        errorDependences="true"
        log warn "No found '${elementFind}' element."
    else
        log ok "Checked '${elementFind}' element."
    fi
}

log "Check dependencies..."
checkDependencie bash
checkDependencie curl
checkDependencie mkdir
checkDependencie tar
checkDependencie which
# which whichs &> /dev/null || (echo "" && errorDependences="true")


if [[ "${errorDependences}" == "true" ]]
    then
    log error "They have not been able to detect all dependencies."
else
    # # echo "mkdir -p ${P}"
    log "Create directory for installation..." && mkdir -p $P
    # # curl -L ${E} > $I

    # if [[ "$(cat $I)" == "Not Found" || "$(cat $I)" == "" ]]
    #     then
    #     echo
    #     echo "Error: No Found ${E}."

    # else

    #     # Get Directori content
    #     Q=$(tar -tzf ${I} | head -1 | sed -e 's/\/.*//')

    #     tar -xzvf $I -C $P

    #     # Rename Directory temp
    #     mv -f -n "$P/${Q}" "${P}/Bash-Manager-$V"

    #     U=${P}/.bashrc


    #     if [[ "${_BASHM_INITIALIZE_IN_BASHM}" == "" ]]
    #         then
    #         echo "# Bash-Manager Configuration" >> ${U}
    #         echo "export BASHM_VERSION=\"${V}\"" >> ${U}
    #         echo "export _BASHM_INITIALIZE_IN_BASHM=\"no\"" >> ${U}
    #         echo "export BASHM_PATH=\"${P}/Bash-Manager-\${BASHM_VERSION}\"" >> ${U}
    #         echo "source \${BASHM_PATH}/bashm.bash" >> ${U}
    #         echo "" >> ${U}

    #         export BASHM_VERSION="${V}"
    #         export _BASHM_INITIALIZE_IN_BASHM="no"
    #         export BASHM_PATH="${P}/Bash-Manager-\${BASHM_VERSION}"
    #         source ${BASHM_PATH}/bashm.sh

    #         bashm init
    #     fi

    #     echo
    #     echo "Successful Installation."

    # fi
fi
