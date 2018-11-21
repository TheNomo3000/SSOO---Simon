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
#--------------Titulo---------------#
titulo(){
    echo -e "\t\t\t${YELLOW}S${NC}${RED}i${NC}${BLUE}m${NC}${YELLOW}o${NC}${RED}n${NC} ${CYAN}Game${NC} ${GREEN}v1.0${NC}"
    echo -e "${PURPLE}\t\t============================${NC}"
    return
}
#--------------MENU---------------#
 menu(){
    cargarValores
    clear
    titulo
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
        menu;;
    e|E)
        stats
        menu;;
    s|S)
        echo Has salido del menú
        exit 0;;
    *)
        echo Has introducido mal la opción, prueba de nuevo
        cont
        menu;;
    esac
}

#-----------CONFIG-----------#
 config(){
    cargarValores
    clear
    titulo
    echo -e "1) Numero de colores : $numcolores "
    echo -e "2) Tiempo : $segundos"
    echo -e "3) Archivo de estadisticas : $ubiEst/$ficEst"
    echo -e "4) VOLVER AL MENU"

    echo -e "\n\nIntroduzca una opcion para modificar >>"
    read opcion
    case "$opcion" in
    1)
        echo -e "\nIntroducir valor >>"
        read opcion
        while (( opcion < 2 ||opcion > 4))
        do
            echo -e "$RED+El numero no puede ser menor de 2 o mayor de 4.$NC"
            echo -e "\nIntroducir un valor valido >>"
            read opcion
        done
        echo -e "OPCION : $opcion"
        sed "/NUMCOLORES/ s/$numcolores/$opcion/g" confi.cfg > confiTemp.cfg && mv confiTemp.cfg confi.cfg
        rm confiTemp.cfg
        config;;
    2)
        echo -e "\nIntroducir valor >>"
        read opcion
        while (( opcion < 1 ||opcion > 4))
        do
            echo -e "$RED+El numero no puede ser menor de 1 o mayor de 4.$NC"
            echo -e "\nIntroducir un valor valido >>"
            read opcion
        done
        sed "/ENTRETIEMPO/ s/$segundos/$opcion/g" confi.cfg > confiTemp.cfg && mv confiTemp.cfg confi.cfg
        rm confiTemp.cfg
        config;;
    3)
        echo $ficEst
        echo -e "\nIntroducir valor >>"
        read opcion
        sed "/ESTADISTICAS/ s/$ficEst/$opcion/g" confi.cfg > confiTemp.cfg && mv confiTemp.cfg confi.cfg
        rm confiTemp.cfg
        config;;
    4)
        echo Has salido del menú
        menu;;
    *)
        echo Has introducido mal la opción, prueba de nuevo
        cont
        config;;
    esac
}
#-----------JUEGO------------#
 game (){
    aciertos=0
    START=$SECONDS
    CONTADOR=1
    AUX=""
    SECUENCIA="${NC}"
    titulo
    echo Numero de posibilidade=$numcolores
    echo Numero de segundos=$segundos
    obtenerColor `echo $(($RANDOM%4))`
    echo -e "La secuencia empieza por : $SECUENCIA"
    while (( aciertos<=1 ))
    do
        echo Espera... y mira bien...
        sleep $segundos
        clear
        titulo
        echo -e "Introduce la secuencia"
        read USERCOL
        obtenerColor `echo $(($RANDOM%$numcolores))`
        AUX=$AUX`echo $SECUENCIA | cut -c $((18*$CONTADOR))`
        USERCOL=`echo $USERCOL | tr [a-z] [A-Z]`
        if [[ $AUX = $USERCOL ]]; 
        then
            clear
            titulo
            CONTADOR=`expr $CONTADOR + 1`
            aciertos=${aciertos}+1
            #FALTA SOLUCIONAR QUE GUARDE LA SECUENCIA CORREECTAMENTE AL GANAR
            echo -e "La secuencia es : $SECUENCIA"
        else
            clear
            titulo
            echo -e "${RED}HAS FALLADO! :C${NC}"
            echo -e "La secuencia era : $SECUENCIA"
            echo -e "\n${GREEN}VUELVE A INTENTARLO!${NC}"
            HORATEMP=`echo $(date +%r)| tr -d ' '`
            DURACION=$(( SECONDS - START ))
            echo -e "$$|$(date +%x)|$HORATEMP|$numcolores|$DURACION|$CONTADOR|$SECUENCIA" >> $ubiEst/$ficEst
            cont
            menu
        fi
    done
    clear
    echo -e "\n${WHITE}----------------------------------${NC}" 
    echo -e "\n${BLUE}\t¡ENHORABUENA! \t\t\t\t\t\t${NC}"
    echo -e "\n${BLUE}   HAS COMPLETADO LA SECUENCIA \t${NC}" 
    echo -e "\n${WHITE}----------------------------------${NC}" 
    HORATEMP=`echo $(date +%r)| tr -d ' '`
    DURACION=$(( SECONDS - START ))
    echo -e "$$|$(date +%x)|$HORATEMP|$numcolores|$DURACION|$CONTADOR|$SECUENCIA" >> $ubiEst/$ficEst
    cont
    menu
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

#-----------STATS------------#
stats(){
    clear
    echo -e "\t\t\t\t${YELLOW}ESTADISTICAS${NC}"
    echo -e "${PURPLE}\t\t\t============================${NC}\n\n"
    echo -e "${BLUE}   Partida |   Fecha   |    Hora    | Numero | Tiempo | Longitud | Secuencia"
    echo -e "   =======================================================================${NC}\n"
    for LINEA in `cat $ubiEst/$ficEst` #LINEA guarda el resultado del fichero datos.txt
    do
        PARTIDA=`echo $LINEA | cut -d "|" -f1`
        FECHA=`echo $LINEA | cut -d "|" -f2`
        HORA=`echo $LINEA | cut -d "|" -f3`
        NUMERO=`echo $LINEA | cut -d "|" -f4`
        TIEMPO=`echo $LINEA | cut -d "|" -f5`
        LONGITUD=`echo $LINEA | cut -d "|" -f6`
        SECUENCIA1=`echo $LINEA | cut -d "|" -f7`
        echo -e "    $PARTIDA    $FECHA    $HORA      $NUMERO        $TIEMPO         $LONGITUD       $SECUENCIA1"
    done
    echo -e "${BLUE}\n   =======================================================================${NC}\n"
    cont
    menu
}

#-----------JUEGO------------#
cont(){
    echo ""
    echo -e "\n${PURPLE}Pulsa INTRO para continuar...${NC}"
    read;
    return
}
menu