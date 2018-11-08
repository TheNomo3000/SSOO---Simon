#!/bin/bash
clear

#------------COLORES--------------#
NC='\033[0m' #NECESARIO SIEMPRE PARA FINALIZAR EL COLOR
RED='\033[1;31m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
BLUE='\033[1;34m'
CYAN='\033[1;36m'
PURPLE='\033[1;35m'

#---------COMPROBACIÓNES----------#
if [ $# -gt 1 ]; then
    echo "Has introducido más de un argumento"
    exit 1
fi
if [ "$1" == "-g" ]; then
    echo -e "\t\t\t\t${RED}AUTORES${NC}"
    echo -e "${PURPLE}\t\t\t=======================${NC}"
    echo -e "${GREEN}Arturo David Vázquez Paumard${NC}"
    echo -e "${GREEN}Rodrigo Zavala Zevallos${NC}"
    exit 1
fi

if !(test -f "confi.cfg"); then
    echo "El fichero \"confi.cfg\" no está en el directorio o no existe, creelo antes de ejecutar el script"
    exit 1
fi

#-----------ARGUMENTOS------------#
aciertos = 0
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
  echo ESTADISTICAS=$ubiEst/$ficEst>>confi.cfg
  echo Se ha creado el fichero estadisticas.txt
fi
#---------CARGAR VALORES----------#
 cargarValores(){
    temp=(`tail -1 confi.cfg|cut -d "=" -f 2`) 
    numcolores=(`head -1 confi.cfg|cut -d "=" -f 2`) #numcolores
    segundos=(`head -2 confi.cfg|tail -1 |cut -d "=" -f 2`) #segundos
    ubiEst=${temp%/*}
    ficEst=${temp##*[/]}
    return
}
#--------------MENU---------------#
 menu(){
    cargarValores
    clear
    echo -e "\t\t\t${YELLOW}S${NC}${RED}i${NC}${BLUE}m${NC}${YELLOW}o${NC}${RED}n${NC} ${CYAN}Game${NC} ${GREEN}v1.0${NC}"
    echo -e "${PURPLE}\t\t============================${NC}"
    echo -e "${PURPLE}J)${NC} JUGAR"
    echo -e "${PURPLE}C)${NC} CONFIGURACION"
    echo -e "${PURPLE}E)${NC} ESTADISTICAS"
    echo -e "${PURPLE}S)${NC} SALIR"
    echo -e "\n\n\"Simon\", Introduzca una opcion >>"

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
    cargarValores
    clear
    echo -e "\t\t\t${YELLOW}S${NC}${RED}i${NC}${BLUE}m${NC}${YELLOW}o${NC}${RED}n${NC} ${CYAN}Game${NC} ${GREEN}v1.0${NC}"
    echo -e "${PURPLE}\t\t============================${NC}"
    echo -e "1) Numero de colores : $numcolores "
    echo -e "2) Tiempo : $segundos"
    echo -e "3) Archivo de estadisticas : $ubiEst/$ficEst"
    echo -e "4) VOLVER AL MENU"

    echo -e "\n\nIntroduzca una opcion para modificar >>"
    read opcion
    echo -e "\nIntroducir valor >>"
    case "$opcion" in
    1)
        read opcion
        while (( opcion < 2 ||opcion > 4))
        do
            echo -e "$RED+El numero no puede ser menor de 2 o mayor de 4.$NC"
            echo -e "\nIntroducir un valor valido >>"
            read opcion
        done
        echo -e "OPCION : $opcion"
        sed -i "/NUMCOLORES/ s/$numcolores/$opcion/g" confi.cfg
        config;;
    2)
        read opcion
        sed -i "/ENTRETIEMPO/ s/$segundos/$opcion/g" confi.cfg
        config;;
    3)
        echo $ficEst
        read opcion
        sed -i "/ESTADISTICAS/ s/$ficEst/$opcion/g" confi.cfg 
        config;;
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
    SECUENCIA="${NC}"
    obtenerColor `echo $(($RANDOM%4))`        
    while (( aciertos<20 ))
    do
        echo -e "$SECUENCIA"
        CONTADOR=$CONTADOR+1
        read USERCOL
        AUX=`echo $SECUENCIA | cut -c $((18*$CONTADOR))`
        #FALLA A LA HORA DE COMPARAR
        if [[ "$AUX"="$USERCOL" ]]; 
        then
            aciertos=${aciertos}+1
            obtenerColor `echo $(($RANDOM%4))`        
        else
            echo -e "${RED}Te has equivocado!"
        fi
    done
    echo -e "$SECUENCIA"
}
 obtenerColor(){
    case "$1" in
    0)
        SECUENCIA="${SECUENCIA}${GREEN}V${NC}"
        return;;
    1)
        SECUENCIA="${SECUENCIA}${RED}R${NC}"
        return;;
    2)
        SECUENCIA="${SECUENCIA}${BLUE}Z${NC}"
        return;;
    3)
        SECUENCIA="${SECUENCIA}${YELLOW}A${NC}"
        return;;
    *)
        echo -e "${RED}ERROR INESPERADO${NC}";;
    esac
}

#-----------JUEGO------------#
 cont(){
    echo ""
    echo -e "\nPulsa INTRO para continuar\n"
    read;
    menu
}
menu