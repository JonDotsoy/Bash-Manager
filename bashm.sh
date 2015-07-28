# Requeriments:
# - bash
# - curl 
# - grep	

memorycall=()

function bashm {
	# 
	# Config Plugin
	# 
	local URL_TO_DOWNLOAD_PLUGINS="https://cdn.rawgit.com/jonDotsoy/Bash-Manager/master/down_plugins/"
	local URL_TO_DOWNLOAD_PLUGINS_END=".sh"

	local action="$1" # get first parameter.

	if [[ "${action}" == "init" ]]
		then
		
		local STRING_LOCAL="# This calls for plugins.\n#\n# Example:\n#\tbashm call alias_ls\n#\n\nbashm call alias_ls\n"

		echo -e $STRING_LOCAL > ~/bashm/config.sh

	elif [[ "${action}" == "install" ]]
		then
		# this create and install a plugin

		local name_Plugin="$2"

		# Generate URL to Download
		local URL="${URL_TO_DOWNLOAD_PLUGINS}${name_Plugin}${URL_TO_DOWNLOAD_PLUGINS_END}"

		local CORRET_DOWNLOAD=false

		curl ${URL} > ~/bashm/plugin/${name_Plugin}.sh && CORRET_DOWNLOAD=true

		if [[ $CORRET_DOWNLOAD = true ]]
			then
			#statements
			echo "Download ${name_Plugin} ok."
			bashm import ${name_Plugin} 
		else
			echo "[Bash Plus:$(date)] Error to Download \"${name_Plugin}\" Plugin."
			rm ~/bashm/plugin/${name_Plugin}.sh
		fi
	elif [[ "${action}" == "import" ]]
		then
		local name_Plugin="$2"

		echo "bashm call ${name_Plugin}" >> ~/bashm/config.sh
	elif [[ "${action}" == "call" ]]
		then
		# this call a plugin

		# Var second parameter
		local name_Plugin="$2"
		if [[ -n "${name_Plugin}" ]]
			then
			memorycall+=(	)
			source ~/bashm/plugin/${name_Plugin}.sh &> /dev/null || echo "[Bash Plus:$(date)] Error to load \"${name_Plugin}\" Plugin."
		fi
	fi
}

source ~/bashm/config.sh