#!/bin/bash
# Este script restaurar las bases de datos.
# Defaults
DB_HOST=""
DB_USER=""
DB_PASS=""

read -e -p " + Host del servidor mysql: " DB_HOST
read -e -p " + Usuario del servidor mysql: " DB_USER
read -e -s -p " + Contraseña del usuario ${DB_USER} en el servidor mysql: " DB_PASS; echo

for LINEA in `cat database.sql ` #LINEA guarda el resultado del fichero database.sql
do
    NOMBRE=`echo $LINEA | cut -d ":" -f1` #Extrae nombre
 	mysql -h ${DB_HOST} -u ${DB_USER} -p${DB_PASS} ${NOMBRE} < "/home/dba/Documentos/PremiunSoft/Respaldos/db_${NOMBRE}.sql"
 	# Comprobamos errores
    if [ $? == 0 ]; then 
        echo " La base de datos ${NOMBRE} se ha restaurado con éxito."
    else
        echo " La base de datos ${NOMBRE} no se ha podido restaurar con éxito."
        exit
   	fi
done