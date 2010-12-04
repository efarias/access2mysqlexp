#!/bin/bash
## $Id: repmind.lib.sh v 1.0 11/26/10 21:24:37 HSP efarias Exp $
## vim:ts=2:sw=2:tw=200:nu:ai:nowrap:

#===============================================================================
#
#          File:  repmind.lib.sh
# 
#         Usage:  ./repmind.lib.sh 
# 
#   Description:  Librearías de funciones para la aplicación
#				  				repmind
# 
#       Options:  ---
#  Requirements:  -MDBTools v0.6pre1
#									-mkdir
#									-ls
#									-gawk
#									-sed
#									-md5sum
#          Bugs:  ---
#         Notes:  ---
#        Author:  Eduardo A. Farías R. (efarias), eduardo.farias@tau-it.cl
#       Company:  Tau-iT Informática
#       Created:  11/26/10 21:24:37 HSP
#      Revision:  1.0
#===============================================================================

#set -x																			# Debug mode
#set -o nounset                              # Treat unset variables as an error

#-------------------------------------------------------------------------------
#
# application initialization function
# (command line argument parsing and validation etc.)
# 
#-------------------------------------------------------------------------------

function __init() {
        echo "Celite Reportes de Minas "$'\n'"Tau-iT Informática"
        echo "Base de datos: "$DB_NAME

        ## Reviza si existen los directorios de trabajo
        declare -a DIRS=(${BASEDIR} ${SQLDIR_ACT} ${SQLDIR_OLD} ${SQLDIR_NEW})
        for i in "${DIRS[@]}"; do
            echo $i
            if [[ ! -d "${i}" ]]; then
                mkdir $i
            fi
        done
        
	## parse command line options
	while getopts ':eb:ixq' opt; do
		case "${opt}" in
			## option e
			e)
				declare -i A=1
				;;
			## option b
			b)
				B="${OPTARG}"
				;;
			i)
				llenarTodos
				;;
			x)
				set -x
				;;
			## quiet operation
			q)
				declare -i __MsgQuiet=1
				;;
			## option without a required argument
			:)
				__die 2 "option -${OPTARG} requires an argument" # TODO FIXME: switch to __msg err
				;;
			## unknown option
			\?)
				__die 2 "unknown option -${OPTARG}" # TODO FIXME: switch to __msg err
				;;
			## this should never happen
			*)
				__die 2 "there's an error in the matrix!" # TODO FIXME: switch to __msg err
				;;
		esac
		__msg debug "command line argument: -${opt}${OPTARG:+ '${OPTARG}'}"
	done
	## check if command line options were given at all
	if [[ ${OPTIND} == 1 ]]; then
		__die 2 "no command line option specified" # TODO FIXME: switch to __msg err
	fi
	## shift off options + arguments
	let OPTIND--; shift ${OPTIND}; unset OPTIND
	args="${@}"
	set --

	return 0 # success

	## -- END YOUR OWN APPLICATION INITIALIZATION CODE HERE --

}


#-------------------------------------------------------------------------------
#  Application main function
#-------------------------------------------------------------------------------


function __main() 
{

#===  FUNCTION  ================================================================
#
#	            Name:  __main
#
#      Description:  Comienzo de la aplicación
#
#       Parameters:  
#
#        Variables:  st, 
#
# Global Variables:	 SQLDIR_NEW
#
#          Returns:  
#
#===============================================================================

        verificarMd5
        st=$?
        if [[ $st = '1' ]] ; then
            exportarTablas
            sqlParse $SQLDIR_NEW/valuesTmp.sql
            sqlImport
        else
            exit
        fi

				exit

}	# ----------  end of function __main  ----------


#-------------------------------------------------------------------------------
#  application worker functions
#-------------------------------------------------------------------------------


function verificarMd5() 
{

#===  FUNCTION  ================================================================
#
#	            Name:  verificarMd5
#
#      Description:  Función que verifica la suma MD5 de la base de datos
#										 Access.
#
#       Parameters:
#
#        Variables:  
#
# Global Variables:	 -$db 
#										 -$db_ASC
#										 -$db_MD5
#
#          Returns:  1 si archivo ha cambiado, de lo contrario 0
#
#===============================================================================

	md5sum $db > $db_ASC
    s=${db_MD5#$db}

	if [[ $s == ": FAILED" ]]; then
		return 1
	else
		return 0
	fi

} # ----------  end of function verificarMd5  ----------



function exportarTablas ()
{

	#===  FUNCTION  ================================================================
	#          NAME:  exportarTablas
	#   DESCRIPTION:  Función para exportar cada tabla de la base de
	#									datos configurada en $DB_NAME
	#    PARAMETERS: 
	#		GLOBAL VARS:	$SQLDIR_ACT
	#									$db
	#       RETURNS:  
	#===============================================================================
	
        echo $db
        echo "Exportando Registros desde "$DB_NAME

        ## Reviza si ya existe el archivo values.sql y lo mueve a SQLDIR_OLD
        if [[ -e "${SQLDIR_ACT}/values.sql" ]]; then
            f="${SQLDIR_ACT}/values.sql ${SQLDIR_OLD}"
            mv $f
        fi

        ## Crea un nuevo archivo values.sql con los registros
				for i in $( mdb-tables -1 $db); do
					echo $i
					if [[ $i != 'PESOEXEDIDO' ]] ; then
						mdb-export -SHI mysql -D '%F %T' $db $i >> $SQLDIR_ACT/values.sql
					fi
				done

        diff $SQLDIR_OLD/values.sql $SQLDIR_ACT/values.sql > $SQLDIR_NEW/valuesTmp.sql

}	# ----------  end of function exportarTablas  ----------

       

function llenarTodos ()
{
	#===  FUNCTION  ================================================================
	#
	#	            Name:  llenarTodos
	#
	#      Description:  Rellena con todos los registros
	#
	#       Parameters:
	#
	#        Variables:
	#
	# Global Variables:	
	#
	#          Returns:  
	#
	#===============================================================================

        echo $db
        echo "Exportando Registros desde "$DB_NAME

        ## Reviza si ya existe el archivo values.sql y lo mueve a SQLDIR_OLD
        if [[ -e "${SQLDIR_NEW}/values_new.sql" ]]; then
            rm  $SQLDIR_NEW/values_new.sql
						touch $SQLDIR_NEW/values_new.sql
					else
						touch $SQLDIR_NEW/values_new.sql
				fi

        ## Crea un nuevo archivo values.sql con los registros
				for i in $( mdb-tables -1 $db); do
					echo $i
					if [[ $i != 'PESOEXEDIDO' ]] ; then
						mdb-export -SHI mysql -D '%F %T' $db $i >> $SQLDIR_NEW/values_new.sql
					fi
				done

mysql -h $MySQL_HOSTNAME -u repmin --password=repmin -D $MySQL_DB -vvv < /home/repmind/values_new/values_new.sql

exit

}	# ----------  end of function llenarTodos  ----------

function sqlParse() {


#===  FUNCTION  ================================================================
#          NAME:  sqlParse
#   DESCRIPTION:  Función que verifica la construcción correcta del archivo
#									SQL, luego de la exportación y comparación de archivos
#									antiguos y actuales.
#    PARAMETERS:  
#       RETURNS:  
#===============================================================================

        # Verifica si existe el archivo valuesTmp.sql
        if [[ ! -e "${SQLDIR_NEW/valuesTmp.sql}" ]] ; then

            echo "ERROR: No existe archivo valuesTmp.sql"
            exit

        fi

        ## Crea consulta SQL para eliminar registros en MySQL que han sido
        ## eliminados en la base de datos access
        awk '/</{print $0}' $1 | 
				sed -e 's/< INSERT INTO/DELETE FROM/g; s/ (/ WHERE (/g; s/VALUES WHERE/=/g '> $SQLDIR_NEW/values_delete.sql
        
				## Crea consulta SQL para insertar los nuevos registros de la base de datos
        ## access.
        awk '/>/{print $0}' $1 | 
				sed -e 's/> //g' > $SQLDIR_NEW/values_insert.sql

} # ----------  end of function sqlParse  ----------


function sqlImport() {


#===  FUNCTION  ================================================================
#          NAME:  sqlImport
#   DESCRIPTION:  Función que introduce las consultas contenidas en los
#									archivos SQL generados.
#    PARAMETERS:  
#		GLOBAL VARS:	$MySQL_HOSTNAME
#									$MySQL_DB
#       RETURNS:  
#===============================================================================

mysql -h $MySQL_HOSTNAME -u repmin --password=repmin -D $MySQL_DB -vvv < /home/repmind/values_new/values_delete.sql

mysql -h $MySQL_HOSTNAME -u repmin --password=repmin -D $MySQL_DB -vvv < /home/repmind/values_new/values_insert.sql
exit
} # ----------  end of function sqlImport  ----------




