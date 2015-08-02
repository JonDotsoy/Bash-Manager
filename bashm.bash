#!/usr/bin/env bash
# Requeriments:
# - bash
# - curl

export _memory_call_bashm=()

# Log Event
function log {
    local TYPE="${1}"
    local MESSAGE="${2}"

    # Configure Colors
    local COLORERROR="\e[1;40;31m"
    local COLORINFO="\e[1;40;34m"
    local COLORWARN="\e[1;40;33m"
    local COLORLOG="\e[1;40;30m"
    local COLORSUCCESS="\e[1;40;32m"

    local TYPECOLOR="${COLORLOG}"
    local MESSAGECOLOR="\e[0m" # Reset Color
    # echo -e "\e[1;31;42m Yes it is awful \e[0m"

    # Empty message.
    if [[ "${MESSAGE}" == "" ]]
        then
        MESSAGE="${TYPE}"
        TYPE="LOG"
    fi

    TYPE="$(echo ${TYPE} | tr "[:lower:]" "[:upper:]")"

    if [[ "${TYPE}" == "LOG" ]]; then
    	TYPECOLOR="${COLORLOG}"
      TYPE="LOG"
    fi

    if [[ "${TYPE}" == "ERROR" ||  "${TYPE}" == "ERR" ]]; then
    	TYPECOLOR="${COLORERROR}"
      TYPE="ERROR"
    fi

    if [[ "${TYPE}" == "WARN" ||  "${TYPE}" == "WAR" || "${TYPE}" == "WARNNING" ]]; then
    	TYPECOLOR="${COLORWARN}"
      TYPE="WARN"
    fi

    if [[ "${TYPE}" == "INFO" || "${TYPE}" == "INF" || "${TYPE}" == "INFORMATION" ]]; then
      TYPECOLOR="${COLORINFO}"
      TYPE="INFO"
    fi

    if [[ "${TYPE}" == "SUCCESS" || "${TYPE}" == "OK" ]]; then
      TYPECOLOR="${COLORSUCCESS}"
      TYPE="OK"
    fi

    echo -e ${TYPECOLOR}'['${TYPE}']:'${MESSAGECOLOR}' '${MESSAGE}''
}


# Check if is call a element.
function _bashm_is_calling {
	local name_component_compare="$1"
	local forceIgnore="$2"

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
	local URL_TO_DOWNLOAD_PLUGINS_END=".bash"

	local action="$1" # get first parameter.

  if [[ "${action}" == "version" || "${action}" == "-v" ]]; then
    echo "BashM, Version 0.0.0 (GNU bash)"
    echo "Copyright (C) 2015, Jon Dotsoy <hi@jon.soy> (http://jon.soy/)."
	elif [[ "${action}" == "init" ]]
		then

		local STRING_LOCAL="#!/usr/bin/env bash\n# This calls for plugins.\n#\n# Example:\n#\tbashm call alias_ls\n#\n\nbashm call alias_ls\n"

		echo -e $STRING_LOCAL > ${BASHM_PATH}/config.bash

	elif [[ "${action}" == "install" || "${action}" == "i" ]]
		# bashm [install|i] <Plugin Name> [URL] [Force]
		# 
		# Plugin Name: Nombre del plugin a instalar.
		# URL:         Indica la url para descargar el complemento.
		# Forlce:      En caso de ya existir 'force' ignora el actual complemento. 
		# 
		# Ex: > bashm install alias_ls force
		#     > bashm i alias_ls http://api.google.cl/s force
		#     > bashm i alias_ls
		then
		# this create and install a plugin

		local name_Plugin="$2"
		local external_URL="$3"
		local forseInstall="$4"

		if [[ "${forseInstall}" == "" ]]; then
			if [[ "${external_URL}" == "force" ]]; then
				forseInstall="force"
				external_URL=""
			fi
		fi

		if [[ ! -f "${BASHM_PATH}/plugin/${name_Plugin}.bash" || "${forseInstall}" == "force" ]]; then
			# Generate URL to Download
			local URL="${URL_TO_DOWNLOAD_PLUGINS}${name_Plugin}${URL_TO_DOWNLOAD_PLUGINS_END}"

			if [[ ! "${external_URL}" == "" ]]
				then
				URL="${external_URL}"
			fi

			local CORRET_DOWNLOAD=false

			curl -L "${URL}" > ${BASHM_PATH}/plugin/${name_Plugin}.bash && CORRET_DOWNLOAD=true

			if [[ $CORRET_DOWNLOAD = true ]]
				then
				#statements
				echo "Download ${name_Plugin} ok."
				bashm import ${name_Plugin} 
			else
				echo "[BashM:$(date)] Error to Download \"${name_Plugin}\" Plugin."
				rm ${BASHM_PATH}/plugin/${name_Plugin}.bash
			fi
		else
			log warn "already it exists complement '${BASHM_PATH}/plugin/${name_Plugin}.bash'."
		fi

	elif [[ "${action}" == "import" ]]
		then
		local name_Plugin="$2"

		if _bashm_is_calling ${name_Plugin}
			then
			echo "bashm call ${name_Plugin}" >> ${BASHM_PATH}/config.bash
		fi

		bashm call ${name_Plugin} force

	elif [[ "${action}" == "call" ]]
		then
		# this call a plugin

		# Var second parameter
		local name_Plugin="$2"
		local forlceLoad="$3"

		if [[ -n "${name_Plugin}" ]]
			then

			# Check if is precall
			if _bashm_is_calling ${name_Plugin} || [[ "${forlceLoad}" == "force" ]]
				then
				_memory_call_bashm+=(${name_Plugin})
				source ${BASHM_PATH}/plugin/${name_Plugin}.bash &> /dev/null || echo "[BashM:$(date)] Error to load \"${name_Plugin}\" Plugin."
			else
				echo "[BashM:$(date)] Warning to load \"${name_Plugin}\" Plugin is already loaded."
			fi
		fi
    
	fi
}

source ${BASHM_PATH}/config.bash
