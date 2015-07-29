# Requeriments:
# - bash
# - curl 
# - grep	

export _memory_call_bashm=()

# Check if is call a element.
function _bashm_is_calling {
	local name_component_compare="$1"

	for i in ${_memory_call_bashm[@]}
	do
		# echo "inspect ${i}"
		if [[ "${i}" == "${name_component_compare}" ]]
			then
			# echo "is found ${i}"
			return 1	
		fi
	done

	return 0
}

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

		echo -e $STRING_LOCAL > ${BASHM_PATH}/config.sh

	elif [[ "${action}" == "install" || "${action}" == "i" ]]
		then
		# this create and install a plugin

		local name_Plugin="$2"
		local external_URL="$3"

		# Generate URL to Download
		local URL="${URL_TO_DOWNLOAD_PLUGINS}${name_Plugin}${URL_TO_DOWNLOAD_PLUGINS_END}"

		if [[ ! "${external_URL}" == "" ]]
			then
			URL="${external_URL}"
		fi

		local CORRET_DOWNLOAD=false

		curl ${URL} > ${BASHM_PATH}/plugin/${name_Plugin}.sh && CORRET_DOWNLOAD=true

		if [[ $CORRET_DOWNLOAD = true ]]
			then
			#statements
			echo "Download ${name_Plugin} ok."
			bashm import ${name_Plugin} 
		else
			echo "[BashM:$(date)] Error to Download \"${name_Plugin}\" Plugin."
			rm ${BASHM_PATH}/plugin/${name_Plugin}.sh
		fi
	elif [[ "${action}" == "import" ]]
		then
		local name_Plugin="$2"

		echo "bashm call ${name_Plugin}" >> ${BASHM_PATH}/config.sh
		bashm call ${name_Plugin}
	elif [[ "${action}" == "call" ]]
		then
		# this call a plugin

		# Var second parameter
		local name_Plugin="$2"
		if [[ -n "${name_Plugin}" ]]
			then

			# Check if is precall
			if _bashm_is_calling ${name_Plugin}
				then
				_memory_call_bashm+=(${name_Plugin})
				source ${BASHM_PATH}/plugin/${name_Plugin}.sh &> /dev/null || echo "[BashM:$(date)] Error to load \"${name_Plugin}\" Plugin."
			else
				echo "[BashM:$(date)] Warning to load \"${name_Plugin}\" Plugin is already loaded."
			fi
		fi
	fi
}

source ${BASHM_PATH}/config.sh
