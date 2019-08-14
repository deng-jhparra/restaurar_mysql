#!/bin/bash
# Este script crea una base de datos, y un usuario con permisos para operar en ella.
# Defaults
DB_HOST=""
DB_ROOT=""
DB_ROOT_PASS=""
DB_NAME=""
DB_USER=""
DB_PASS=""

# Recogemos el input del usuario
read -e -p " + Host del servidor mysql: " DB_HOST
read -e -p " + Usuario del servidor mysql: " DB_ROOT
read -e -s -p " + Contraseña del usuario ${DB_ROOT} en el servidor mysql: " DB_ROOT_PASS; echo
read -e -p " + Nombre del nuevo usuario mysql: " DB_USER
read -e -s -p " + Contraseña del nuevo usuario: " DB_PASS;
echo 
echo
# Creamos el nuevo usuario sql
mysql -h ${DB_HOST} -u ${DB_ROOT} -p${DB_ROOT_PASS} -e "CREATE USER '${DB_USER}'@'${DB_HOST}' IDENTIFIED BY '${DB_PASS}'; GRANT USAGE ON * . * TO '${DB_USER}'@'${DB_HOST}' IDENTIFIED BY '${DB_PASS}';"

# Comprobamos errores
if [ $? == 0 ]; then
    echo " El usuario ${DB_USER} se ha creado con éxito."

    for LINEA in `cat database.sql ` #LINEA guarda el resultado del fichero
    do
        NOMBRE=`echo $LINEA | cut -d ":" -f1` #Extrae nombre

        mysql -h ${DB_HOST} -u ${DB_ROOT} -p${DB_ROOT_PASS} -e "CREATE DATABASE ${NOMBRE} DEFAULT CHARACTER SET utf8 DEFAULT COLLATE utf8_general_ci; GRANT ALL PRIVILEGES ON ${NOMBRE} . * TO '${DB_USER}'@'${DB_HOST}'; FLUSH PRIVILEGES"

        # Comprobamos errores
        if [ $? == 0 ]; then 
            echo " La base de datos ${NOMBRE} se ha creado con éxito."
        else
            echo " La base de datos ${NOMBRE} no se ha podido crear con éxito."
            exit
        fi
    done
else
    echo " Si mysql devuelve ERROR 1396 probablemente signifique que el usuario que intentas crear ya existe."
    echo " Prueba otro nombre de usuario."
    exit
fi