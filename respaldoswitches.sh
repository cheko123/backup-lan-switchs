#!/bin/bash


# -*- ENCODING: UTF-8 -*-


#revisa para ver si existen los archivos creados  si no los crea

if [ -f ipsdetectadas.temp ]; 
then 
touch siexiste.txt
echo "Sí, sí existe.";
rm ipsdetectadas.temp
touch ipsdetectadas.temp
else 
touch noexiste.txt
echo "No, no existe creando...";  
touch ipsdetectadas.temp
fi




if [ -f ipslimpias.temp ]; 
then 
echo "Sí, sí existe."; 
rm ipslimpias.temp
touch ipslimpias.temp
else 
echo "No, no existe creando...";  
touch ipslimpias.temp
fi



rangoips="192.168.1.1-255" # formato del rango de ips ejemplo 
#escaneamos el segmento de red para ver los switches conectados 
nmap -sn $rangoips >> ipsdetectadas.temp

#limpiamos el archivo donde guardamos las ips escaneadas
cat ipsdetectadas.temp | grep -oi "[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}"|sort >> ipslimpias.temp


#creamos carpeta de con la fecha de hoy
fecha=$(date +"%m_%d_%Y")
mkdir -pv $fecha



while read line
do 
   echo -e "$line\n"

                

host=$line
#host=192.168.200.217    #aqui la ip de switch
port=23
user=ro      #cambia usuario por el del switch
pass=""      #cambia contraseña por la del switch

#estas son las ordenes que se enviaran al switch
cmd1="set length 0"
cmd2="show config"
#cmd3="show config"
cmd4=exit


#este trozo que sigue son las ordenes que se envian al router atraves de telnet(que estan mas arriba)
( echo open ${host}
sleep 1
echo ${user}
sleep 1
echo ${pass}
sleep 1
echo ${cmd1}
sleep 1
echo ${cmd2}
sleep 60

echo ${cmd4} ) | telnet  >>     $fecha/$line.txt       # respaldo.txt
notify-send $line "realizado con exito"

done < ipslimpias.temp




echo "Fin del Respaldo"

#notify-send “Respaldo Terminado”                    #en algunos sistemas operativos soporta las notificaciones
