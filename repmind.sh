#!/bin/bash
## $Id: repmind.sh,v 0.1 2010/11/14 3:19:20 efarias Exp efarias $
## vim:ts=4:sw=4:tw=200:nu:ai:nowrap:
##
## Creado por Eduardo A. Farías <eduardo.farias@tau-it.cl>
## Tau-iT Informática 2010
##
## Licencia GNU GPLv3

##
## bashinator basic variables
##

export __ScriptFile=${0##*/} # thisscript.sh
export __ScriptName=${__ScriptFile%.sh} # thisscript
export __ScriptPath=${0%/*}; __ScriptPath=${__ScriptPath%/} # /path/to/this/script
##export __ScriptPath="/home/othawan/Repmind"
export __ScriptHost=$(hostname) # host.example.com

##
## bashinator library and config
##

## system installation
export __BashinatorConfig="${__ScriptPath}/cfg/bashinator.cfg.sh"
export __BashinatorLibrary="${__ScriptPath}/lib/bashinator.lib.0.sh" # APIv0

if ! source "${__BashinatorConfig}"; then
    echo "!!! FATAL: failed to source bashinator config '${__BashinatorConfig}'" 1>&2
    exit 2
fi

if ! source "${__BashinatorLibrary}"; then
    echo "!!! FATAL: failed to source bashinator library '${__BashinatorLibrary}'" 1>&2
    exit 2
fi

##
## boot bashinator
##

__boot

##
## application library and config
##

## system installation
export ApplicationConfig="${__ScriptPath}/cfg/${__ScriptName}.cfg.sh"
export ApplicationLibrary="${__ScriptPath}/lib/${__ScriptName}.lib.sh"

## include required source files
__requireSource "${ApplicationConfig}"
__requireSource "${ApplicationLibrary}"

##
## dispatch the application with all command line arguments
##

__dispatch "${@}"
