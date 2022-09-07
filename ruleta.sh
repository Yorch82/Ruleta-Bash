#!/bin/bash

#Colours
greenColour="\e[0;32m\033[1m"
endColour="\033[0m\e[0m"
redColour="\e[0;31m\033[1m"
blueColour="\e[0;34m\033[1m"
yellowColour="\e[0;33m\033[1m"
purpleColour="\e[0;35m\033[1m"
turquoiseColour="\e[0;36m\033[1m"
grayColour="\e[0;37m\033[1m"

function ctrl_c(){
  echo -e "\n\n${redColour}[!] Saliendo...${endColour}\n"
  tput cnorm && exit 1
}

# Ctrl+C
trap ctrl_c INT

function helpPanel(){
  echo -e "\n${yellowColour}[+]${endColour}${grayColour} Uso:${endColour}${purpleColour} $0${endColour}\n"
  echo -e "\t${blueColour}m)${endColour}${grayColour} Dinero con el que se desea jugar${endColour}"
  echo -e "\t${blueColour}t)${endColour}${grayColour} Técnica a utilizar${endColour}${purpleColour}(${endColour}${yellowColour}martingala${endColour}${blueColour}/${endColour}${yellowColour}inverseLabrouchere${endColour}${purpleColour})${endColour}\n"
  exit 1
}

function martingala(){
  echo -e "\n${yellowColour}[+]${endColour}${grayColour} Dinero actual:${endColour}${blueColour} $money€${endColour}"
  echo -ne "${yellowColour}[+]${endColour}${grayColour} ¿Cuánto dinero tienes pensado apostar? ->${endColour} " && read initial_bet
  echo -ne "${yellowColour}[+]${endColour}${grayColour} ¿A qué deseas apostar continuamente (par/impar)? ->${endColour} " && read par_impar

  echo -e "\n${yellowColour}[+]${endColour}${grayColour} Vamos a jugar con una cantidad inicial de${endColour}${blueColour} $initial_bet€${endColour}${grayColour} a${endColour}${blueColour} $par_impar${endColour}"

  backup_bet=$initial_bet
  play_counter=1
  juagadas_malas=""

  tput civis # Ocultamos cursor
  while true; do  
    money=$(($money-$initial_bet))
#    echo -e "\n${yellowColour}[+]${endColour}${grayColour} Acabas de apostar${endColour}${blueColour} $initial_bet€${endColour}${grayColour} y tienes${endColour}${blueColour} $money€${endColour}"
    random_number="$(($RANDOM % 37))"    
#    echo -e "${yellowColour}[+]${endColour}${grayColour} Ha salido el número${endColour}${blueColour} $random_number${endColour}"
    
    if [ ! "$money" -lt 0 ];then
      if [ "$par_impar" == "par" ]; then
        # Apostar a pares
        if [ "$(($random_number % 2))" -eq 0 ]; then
          if [ "$random_number" -eq 0 ]; then
#            echo -e "${redColour}[+] Ha salido 0, por tanto perdemos${endColour}"
            initial_bet=$(($initial_bet*2))
            juagadas_malas+="$random_number "
#            echo -e "${yellowColour}[+]${endColour}${grayColour} Ahora mismo te quedas en${endColour}${blueColour} $money€${endColour}"
          else
#            echo -e "${yellowColour}[+]${endColour}${greenColour} El número que has salido es par, ¡Ganas!${endColour}"
            reward=$(($initial_bet*2))
#            echo -e "${yellowColour}[+]${endColour}${grayColour} ganas un total de${endColour}${blueColour} $reward€${endColour}"
            money=$(($money+$reward))
#            echo -e "${yellowColour}[+]${endColour}${grayColour} Tienes${endColour}${blueColour} $money€${endColour}"
            initial_bet=$backup_bet

            juagadas_malas=""
          fi
        else
#          echo -e "${yellowColour}[+]${endColour}${redColour} El número que ha salido es impar, ¡Pierdes!${endColour}"
          initial_bet=$(($initial_bet*2))
          juagadas_malas+="$random_number "
#          echo -e "${yellowColour}[+]${endColour}${grayColour} Ahora mismo te quedas en${endColour}${blueColour} $money€${endColour}"
        fi
      else
        # Apostar a impares
        if [ "$((random_number % 2))" -eq 1 ];then                            
#          echo -e "${yellowColour}[+]${endColour}${greenColour} El número que has salido es impar, ¡Ganas!${endColour}"
          reward=$(($initial_bet*2))
#          echo -e "${yellowColour}[+]${endColour}${grayColour} ganas un total de${endColour}${blueColour} $reward€${endColour}"
          money=$(($money+$reward))
#          echo -e "${yellowColour}[+]${endColour}${grayColour} Tienes${endColour}${blueColour} $money€${endColour}"          
          initial_bet=$backup_bet
          juagadas_malas=""
        else
#          echo -e "${yellowColour}[+]${endColour}${redColour} El número que ha salido es par, ¡Pierdes!${endColour}"
          initial_bet=$(($initial_bet*2))
          juagadas_malas+="$random_number "
#          echo -e "${yellowColour}[+]${endColour}${grayColour} Ahora mismo te quedas en${endColour}${blueColour} $money€${endColour}"
        fi 
      fi
    else
      # Nos quedamos sin dinero
      echo -e "\n${redColour}[!] Te has quedado sin pasta cabrón${endColour}"
      echo -e "${yellowColour}[+]${endColour}${grayColour} han habido un total de${endColour}${yellowColour} $((play_counter-1))${endColour}${grayColour} apuestas${endColour}"

      echo -e "\n${yellowColour}[+]${endColour}${grayColour}A continuación se van a representar las malas jugadas consecutivas que han salido:${endColour}\n"
      echo -e "${blueColour}[$juagadas_malas]${endColour}"
      tput cnorm && exit 0
    fi

    let play_counter+=1
  done

  tput cnorm # Recuperamos cursor
}

function inverseLabrouchere(){
  echo -e "\n${yellowColour}[+]${endColour}${grayColour} Dinero actual:${endColour}${blueColour} $money€${endColour}"
  echo -ne "${yellowColour}[+]${endColour}${grayColour} ¿A qué deseas apostar continuamente (par/impar)? ->${endColour} " && read par_impar
  
  declare -a my_sequence=(1 2 3 4)

  echo -e "\n${yellowColour}[+]${endColour}${grayColour} Comenzamos con la secuencia${endColour}${greenColour} [${my_sequence[@]}]${endColour}"

  bet=$((${my_sequence[0]} + ${my_sequence[-1]}))

  unset my_sequence[0]
  unset my_sequence[-1]
  my_sequence=(${my_sequence[@]})

  echo -e "${yellowColour}[+]${endColour}${grayColour} Invertimos ${endColour}${yellowColour}$bet€${endColour}${grayColour} y nuestra secuencia se queda en ${endColour}${greenColour}[${my_sequence[@]}]${endColour}"
  
  tput civis
  while true; do
    random_number=$((RANDOM % 37))

    echo -e "\n${yellowColour}[+]${endColour}${grayColour} Ha salido el número ${endColour}${blueColour}$random_number${endColour}"
    
    if [ "$par_impar" == "par" ]; then
      if [ "$(($random_number % 2))" -eq 0 ]; then
        echo -e "${yellowColour}[+]${endColour}${greenColour} El número es par, ¡Ganas!${endColour}"
      else
        echo -e "${redColour}[!] El número es impar, ¡Pierdes!${endColour}"
      fi
    fi

    sleep 10
  done

}

while getopts "m:t:h" arg; do
  case $arg in
    m) money=$OPTARG;;
    t) technique=$OPTARG;;
    h) helPanel;;
  esac
done

if [ $money ] && [ $technique ]; then
  if [ "$technique" == "martingala" ]; then
    martingala
  elif [ "$technique" == "inverseLabrouchere" ]; then
    inverseLabrouchere
  else
    echo -e "\n${redColour}[!] La técnica introducida no existe${endColour}"
    helpPanel
  fi
else
  helpPanel
fi
