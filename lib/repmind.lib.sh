## $Id: repmind.lib.sh,v 0.1 2010/11/14 3:19:20 efarias Exp efarias $$
## vim:ts=4:sw=4:tw=200:nu:ai:nowrap:

##
## REQUISITOS
## =================
## - MDBTools
## - mkdir
## - ls
##

##
## application initialization function
## (command line argument parsing and validation etc.)
##

function __init() {
        echo "Celite Reportes de Minas -- Tau-iT Informática"
        echo "Base de datos: "$DB_NAME
	## parse command line options
	while getopts ':eb:q' opt; do
		case "${opt}" in
			## option e
			e)
                                echo "Exportando Registros desde "$DB_NAME
                                #exportar_tablas
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
        echo $db_ASC
        echo $db_MD5
        if [$db_MD5 = 1]; then
            echo "Fallo"
        fi
	echo $db
	## -- END YOUR OWN APPLICATION MAIN CODE HERE --

}

##
## application worker functions
##

function exportar_tablas() {
        # Función para exportar cada tabla de la base de
	# datos configurada en DB_ORI

	for i in $( mdb-tables -1 $db); do
		echo $i
		mdb-export -SHI mysql $db $i >> $SQLDIR_ACT/values.sql
	done

}

##function fooFunction() {
##	barFunction barArgs
##}

##function barFunction() {
##	bazFunction bazArgs
##}

##function bazFunction() {
##	__die 1 "dying for test purposes"
##}