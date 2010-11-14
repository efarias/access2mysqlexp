#!/bin/bash
#
# Copyright 2010-2011 Tau-iT Informática, Eduardo A. Farías Reyes
#
# Este script realiza la exportación de la base de datos Access
# y crea los archivos SQL que serán importados a la base de datos
# MySQL del programa RepMin
#

# Configuración Inicial
#
BASEDIR=/home/efarias/.repmin
DB_ORI=/home/efarias/CeliteControl/src/db/access/pesajeSER.mdb
SQLDIR_OLD=$BASEDIR/values_old
SQLDIR_ACT=$BASEDIR/values_act
SQLDIR_NEW=$BASEDIR/values_new

exportar_tablas ()
{
	# Función para exportar cada tabla de la base de 
	# datos configurada en DB_ORI

	db=$DB_ORI

	for i in $( mdb-tables -1 $db); do
		echo $i
		mdb-export -SHI -R ";"'\n' $db $i >> $SQLDIR_ACT/values.sql 
	done
}

exportar_tablas
exit 0
