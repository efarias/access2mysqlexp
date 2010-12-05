#!/bin/bash
## $Id: repmind.sh,v 0.1 2010/11/14 3:19:20 efarias Exp efarias $
## vim:ts=2:sw=2:tw=200:nu:ai:nowrap:

#===============================================================================
#
#          File:  access2mysqlexp.sh
# 
#         Usage:  ./access2mysqlexp.sh [exiq]
# 
#   Description:  Herramienta de exportación de registros en base de datos
#				  Access, hacia MySQL.
# 
#       Options:  i - Vuelca la base de datos completa en MySQL
#				  x - Modo Debug 
#				  q - Modo silencioso
#  Requirements:  MDBTools v0.6pre1
#				  
#          Bugs:  ---
#         Notes:  Utilizando framework Bashinator v0.5
#        Author:  Eduardo A. Farías R. (efarias), eduardo.farias@tau-it.cl
#       Company:  Tau-iT Informática
#       Created:  2010/11/14 3:19:20 HSP
#      Revision:  v0.3
#===============================================================================

#set -x					 					 # Debug mode
#set -o nounset                              # Treat unset variables as an error

## Licencia GNU GPLv3


#-------------------------------------------------------------------------------
#  Bashinator basic variables
#-------------------------------------------------------------------------------
 

export __ScriptFile=${0##*/} # thisscript.sh
export __ScriptName=${__ScriptFile%.sh} # thisscript
export __ScriptPath=${0%/*}; __ScriptPath=${__ScriptPath%/} # /path/to/this/script
export __ScriptHost=$(localhost) 


#-------------------------------------------------------------------------------
#  bashinator library and config
#-------------------------------------------------------------------------------

# system installation


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



#-------------------------------------------------------------------------------
#  boot bashinator
#-------------------------------------------------------------------------------

__boot


#-------------------------------------------------------------------------------
#  application library and config
#-------------------------------------------------------------------------------

# system installation


export ApplicationConfig="${__ScriptPath}/cfg/${__ScriptName}.cfg.sh"
export ApplicationLibrary="${__ScriptPath}/lib/${__ScriptName}.lib.sh"

# include required source files
__requireSource "${ApplicationConfig}"
__requireSource "${ApplicationLibrary}"

#-------------------------------------------------------------------------------
#  dispatch the application with all command line arguments
#-------------------------------------------------------------------------------

__dispatch "${@}"
