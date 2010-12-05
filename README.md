Access2MysqlExp - Herramienta de exportación de base de datos Access a MySQL
==================================

&copy; 2010-2011 Tau-iT Informática, Eduardo A. Farías Reyes <eduardo.farias@tau-it.cl>

--------------------------------------------------------

Descripción:
------------

Access2MySQLExp es un script para bash, que tiene la función de realizar la exportación de registros desde una base de datos access, como origen, hacia una BD en un servidor MySQL.

Esta herramienta nace como un subproyecto del sistema de reportes de minas Celite.

Este script utiliza la librería y utilidades del proyecto [MDBTools](http://mdbtools.sourceforge.net/ "MDBTools") y el ambiente de consola de comandos tipo Unix[cygwin] (http://www.cygwin.com/ "Cygwin").

--------------------------------------------------------

Requisitos:
-----------

* [MDBTools](http://mdbtools.sourceforge.net/ "MDBTools") 
	>MDBTools es una librería y colección de utilidades que permiten la manipulación
	>de bases de datos Access a través de la línea de comandos.
	>
* [cygwin](http://www.cygwin.com/ "Cygwin")
	>Cygwin es un conjunto de herramientas y utilidades que permiten trabajar en una consola de comandos tipo Unix.
	>
	>

 ---------------------------------------------------------

Instalación
-----------

Primero es necesario instalar cygwin, en el equipo que posee la base de datos access de la que se obtendrán los registros.

Cygwin debe ser instalado junto con las utilidades Cron y Syslog-ng.

Instalar MDBTools, la última versión disponible en [Github](http://www.github.com).

Bajar el script desde el repositorio:

	$ git clone git@github.com/efarias/Repmind.git

Crear el usuario Repmind.
