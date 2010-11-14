Repmind - Reportes de Minas Daemon
==================================

&copy; 2010-2011 Tau-iT Informática, Eduardo A. Farías Reyes <eduardo.farias@tau-it.cl>

--------------------------------------------------------

Descripción:
------------

Repmind es un script para bash, que tiene la función de realizar la exportación de registros desde la base de datos access, del sistema de pesaje, hacia la base de datos MySQL, del sistema de reportes de Minas Repmin.

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
<git clone git@github.com/efarias/Repmind.git>

Crear el usuario Repmind.
