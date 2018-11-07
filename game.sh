#!/bin/bash
clear

if [ $# -gt 1 ]; then
  echo Has introducido más de un argumento
  exit 1
fi
if [ "$1" == "-g" ]; then
  echo Arturo David Vázquez Paumard
  echo Rodrigo
  exit 1
fi
if [ "$1" != "conf.cfg" ]; then
  echo El argumento debe ser \"conf.cfg\"
  exit 1
fi
if !(test -f "conf.cfg"); then
  echo El fichero \"conf.cfg\" no está en el directorio o no existe, creelo antes de ejecutar el script
  exit 1
fi

#-----------ARGUMENTOS------------#
temp=(`tail -1 conf.cfg|cut -d "=" -f 2`)
temp1=(`head -1 conf.cfg|cut -d "=" -f 2`)
temp2=(`head -2 conf.cfg|tail -1 |cut -d "=" -f 2`)
ubiEst=${temp%/*}
ficEst=${temp##*[/]}
ruta=(`pwd`)
if !(test -f $ubiEst/$ficEst); then
  touch estadisticas.txt
  ubiEst=(`pwd`)
  rm conf.cfg
  touch conf.cfg
  chmod 744 conf.cfg
  echo NUMCOLORES=$temp1>>conf.cfg
  echo ENTRETIEMPO=$temp2>>conf.cfg
  echo Estadisticas=$ubiEst/$ficEst>>conf.cfg
  echo Se ha creado el fichero estadisticas.txt
fi

#--------------MENU---------------#
g=0
menu(){
    temp=(`tail -1 conf.cfg|cut -d "=" -f 2`) 
    temp1=(`head -1 conf.cfg|cut -d "=" -f 2`) #numcolores
    temp2=(`head -2 conf.cfg|tail -1 |cut -d "=" -f 2`) #segundos
    clear
    echo "\t\tSaimon v 1.0\t\t"
    echo "========================="
    echo "J) JUGAR"
    echo "C) Configuracion"
    echo "E) Estadisticas"
    echo "S) SALIR"
    echo ""
    echo "Saimon, Introduzca una opcion >>"

    read opcion
    case "$opcion" in
    j|J)
        clear
        game;;
    c|C)
        config
        cont;;
    e|E)
        statistics
        cont;;
    s|S)
        echo Has salido del menú
        exit 0;;
    *)
        echo Has introducido mal la opción, prueba de nuevo
        cont;;
    esac
}

#-----------JUEGO------------#
game (){
    echo Numero de posibilidade=$temp1
    echo Numero de segundos=$temp2

    aciertos = 0
    while(aciertos<20){
        echo Introduce la secuencia:
        read
        clear
        if [ "${t}" = "$(echo ${t}|egrep '^[0-9]*$')" ];then
            let tries--
            let j--
            echo "No se permiten números"
            continue
        fi
    }
}

#-----------JUEGO------------#
cont(){
    echo ""
    echo \"Pulsa INTRO para continuar\"
    read;
    menu
}
smenu