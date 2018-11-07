#!/bin/bash
clear

#---------COMPROBACIÓNES----------#
if [ $# -gt 1 ]; then
  echo Has introducido más de un argumento
  exit 1
fi
if [ "$1" == "-g" ]; then
  echo Arturo David Vázquez Paumard
  echo Rodrigo Zavala Zevallos
  exit 1
fi

if !(test -f "confi.cfg"); then
  echo El fichero \"confi.cfg\" no está en el directorio o no existe, creelo antes de ejecutar el script
  exit 1
fi

#-----------ARGUMENTOS------------#
temp=(`tail -1 confi.cfg|cut -d "=" -f 2`)
numcolores=(`head -1 confi.cfg|cut -d "=" -f 2`)
segundos=(`head -2 confi.cfg|tail -1 |cut -d "=" -f 2`)
ubiEst=${temp%/*}
ficEst=${temp##*[/]}
ruta=(`pwd`)
if !(test -f $ubiEst/$ficEst); then
  touch estadisticas.txt
  ubiEst=(`pwd`)
  rm confi.cfg
  touch confi.cfg
  chmod 744 confi.cfg
  echo NUMCOLORES=$numcolores>>confi.cfg
  echo ENTRETIEMPO=$segundos>>confi.cfg
  echo Estadisticas=$ubiEst/$ficEst>>confi.cfg
  echo Se ha creado el fichero estadisticas.txt
fi

#--------------MENU---------------#
g=0
menu(){
    temp=(`tail -1 conf.cfg|cut -d "=" -f 2`) 
    numcolores=(`head -1 conf.cfg|cut -d "=" -f 2`) #numcolores
    segundos=(`head -2 conf.cfg|tail -1 |cut -d "=" -f 2`) #segundos
    clear
    echo -e "\t\t\tSimon Game v 1.0"
    echo -e "\t\t============================"
    echo -e "J) JUGAR"
    echo -e "C) Configuracion"
    echo -e "E) Estadisticas"
    echo -e "S) SALIR"
    echo -e "\n\nSimon, Introduzca una opcion >>"

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

#-----------CONFIG-----------#
config(){
    clear
    echo -e "\t\t\tSimon Game v 1.0"
    echo -e "\t\t============================"
    echo -e "1) Numero de colores : $numcolores "
    echo -e "2) Tiempo : $segundos"
    echo -e "3) Archivo de estadisticas : $ubiEst/$ficEst"
    echo -e "4) VOLVER AL MENU"

    echo -e "\n\nIntroduzca una opcion para modificar >>"
    read opcion
    case "$opcion" in
    1)
        clear
        game;;
    2)
        config
        cont;;
    3)
        statistics
        cont;;
    4)
        echo Has salido del menú
        menu;;
    *)
        echo Has introducido mal la opción, prueba de nuevo
        cont;;
    esac
}
#-----------JUEGO------------#
game (){
    echo Numero de posibilidade=$numcolores
    echo Numero de segundos=$segundos

    aciertos = 0
    while [aciertos<20]
    do
        echo Introduce la secuencia:
        read
        clear
        if [ "${t}" = "$(echo ${t}|egrep '^[0-9]*$')" ];then
            let tries--
            let j--
            echo "No se permiten números"
            continue
        fi
    done
}

#-----------JUEGO------------#
cont(){
    echo ""
    echo -e "\nPulsa INTRO para continuar\n"
    read;
    menu
}
menu