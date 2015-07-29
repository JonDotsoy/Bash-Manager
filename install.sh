# Define Version to Work
if [[ "${BASHM_VERSION_TO_INSTALL}" == "" ]]
	then
	V="0.6.2"
else
	V="${BASHM_VERSION_TO_INSTALL}"
fi

E="https://codeload.github.com/jonDotsoy/Bash-Manager/tar.gz/$V"
I="/tmp/bashm-$V.tar.gz"
P="$HOME"

echo -e "\nConfiguration to install BASHM\n==============================\n\nVersion            : ${V}\nURL File           : ${E}\nTemporal Files     : ${I}\nURL to Instalation : ${P}\n\n"

# echo "mkdir -p ${P}"
mkdir -p $P
curl ${E} > $I

if [[ "$(cat $I)" == "Not Found" ]]
	then
	echo
	echo "Error: No Found ${E}."

else

	tar -xzvf $I -C $P

	U=${HOME}/.bashrc

	echo
	echo "Initialize autostart in ${U} [Yes/no]:"
	read _BASHM_INITIALIZE_IN_BASHRC

	if [[ "${_BASHM_INITIALIZE_IN_BASHRC}" == "yes" || "${_BASHM_INITIALIZE_IN_BASHRC}" == "ye" || "${_BASHM_INITIALIZE_IN_BASHRC}" == "y" ]]
		then
		echo "# Bash-Manager Configuration" >> ${U}
		echo "export BASHM_VERSION=\"${V}\"" >> ${U}
		echo "export BASHM_PATH=\"${P}/Bash-Manager-\${BASHM_VERSION}\"" >> ${U}
		echo "source \${BASHM_PATH}/bashm.sh" >> ${U}
	fi

	echo
	echo "Successful Installation."

fi
