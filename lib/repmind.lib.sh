## $Id: repmind.lib.sh,v 0.1 2010/11/14 3:19:20 efarias Exp efarias $$
## vim:ts=4:sw=4:tw=200:nu:ai:nowrap:

##
## REQUISITOS
## =================
## - MDBTools v0.6pre1
## - mkdir
## - ls
## - gawk
## - sed
## - md5sum
##

##
## application initialization function
## (command line argument parsing and validation etc.)
##
#set -x

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
	while getopts ':eb:q' opt; do
		case "${opt}" in
			## option e
			e)
				declare -i A=1
				;;
			## option b
			b)
				B="${OPTARG}"
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

##
## application main function
##

function __main() {

	## -- BEGIN YOUR OWN APPLICATION MAIN CODE HERE --
        verificarMd5
        st=$?
        echo $st
        if [[ $st = '1' ]] ; then
            exportarTablas
            sqlParse $SQLDIR_NEW/valuesTmp.sql
            sqlImport
        else
            exit
        fi

        
	## -- END YOUR OWN APPLICATION MAIN CODE HERE --

}

function verificarMd5() {
    md5sum $db > $db_ASC
    echo $db_ASC
    echo $db_MD5
    echo ${db_MD5#'$db'}
    s=${db_MD5#$db}
        if [[ $s == ": FAILED" ]]; then
            echo $s
            echo "El Archivo $DB_NAME ha cambiado"
            return 1
        else
            echo 'Nada'
            return 0
        fi

}
##
## application worker functions
##


function exportarTablas() {
        
        # ----- head -----
        #
        # DESCRIPTION:
        #   Función para exportar cada tabla de la base de
        #   datos configurada en $DB_NAME
        #
        # ARGUMENTS:
	#
        # GLOBAL VARIABLES USED:
        #   $SQLDIR_ACT
        #   $db

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
		mdb-export -SHI mysql $db $i >> $SQLDIR_ACT/values.sql
	done

        diff $SQLDIR_OLD/values.sql $SQLDIR_ACT/values.sql > $SQLDIR_NEW/valuesTmp.sql

}

function sqlParse() {

        # ----- head -----
        #
        # DESCRIPTION:
        #
        #   Función que verifica la construcción correcta del archivo
        #   SQL, luego de la exportación y comparación de archivos
        #   antoguos y actuales.
        #
        # ARGUMENTS:
	#
        # GLOBAL VARIABLES USED:
        #
        #

        ## -- code --
        # Verifica si existe el archivo valuesTmp.sql
        if [[ ! -e "${SQLDIR_NEW/valuesTmp.sql}" ]] ; then

            echo "ERROR: No existe archivo valuesTmp.sql"
            exit

        fi

        ## Crea consulta SQL para eliminar registros en MySQL que han sido
        ## eliminados en la base de datos access
        awk '/</{print $0}' $1 | sed -e 's/< INSERT INTO/DELETE FROM/g; s/ (/ WHERE (/g; s/VALUES WHERE/=/g '> $SQLDIR_NEW/values_delete.sql
        ## Crea consulta SQL para insertar los nuevos registros de la base de datos
        ## access.
        awk '/>/{print $0}' $1 | sed -e 's/> //g' > $SQLDIR_NEW/values_insert.sql
}

function sqlImport() {

        # ----- head -----
        #
        # DESCRIPTION:
        #
        #   Función que importa las consultas contenidas en los archivos SQL
        #   a la base de
        #
        # ARGUMENTS:
	#
        # GLOBAL VARIABLES USED:
        #   $MySQL_HOSTNAME
        #   $MySQL_DB

        ## -- code --
mysql -h $MySQL_HOSTNAME -u repmin --password=repmin -D $MySQL_DB -vvv < /home/repmind/values_new/values_insert.sql
mysql -h $MySQL_HOSTNAME -u repmin --password=repmin -D $MySQL_DB -vvv < /home/repmind/values_new/values_delete.sql
exit
}



