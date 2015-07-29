# Define Version to Work
if [[ "${BASHM_VERSION_TO_INSTALL}" == "" ]]
    then
    V="0.6.1"
else
    V="${BASHM_VERSION_TO_INSTALL}"
fi

E="https://api.github.com/repos/jonDotsoy/Bash-Manager/tarball/$V"
I="/tmp/bashm-$V.tar.gz"
P="$HOME"

echo -e "\nConfiguration to install BASHM\n==============================\n\nVersion            : ${V}\nURL File           : ${E}\nTemporal Files     : ${I}\nURL to Instalation : ${P}\n\n"

# echo "mkdir -p ${P}"
mkdir -p $P
curl -L ${E} > $I

if [[ "$(cat $I)" == "Not Found" || "$(cat $I)" == "" ]]
    then
    echo
    echo "Error: No Found ${E}."

else

    # Get Directori content
    Q=$(tar -tzf ${I} | head -1 | sed -e 's/\/.*//')

    tar -xzvf $I -C $P

    # Rename Directory temp
    mv "$P/${Q}" "${P}/Bash-Manager-$V"

    U=${P}/.bashrc


    if [[ "${_BASHM_INITIALIZE_IN_BASHM}" == "" ]]
        then
        echo "# Bash-Manager Configuration" >> ${U}
        echo "export BASHM_VERSION=\"${V}\"" >> ${U}
        echo "export _BASHM_INITIALIZE_IN_BASHM=\"no\"" >> ${U}
        echo "export BASHM_PATH=\"${P}/Bash-Manager-\${BASHM_VERSION}\"" >> ${U}
        echo "source \${BASHM_PATH}/bashm.sh" >> ${U}
        echo "" >> ${U}
    fi

    echo
    echo "Successful Installation."

fi
