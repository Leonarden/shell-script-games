#!/bin/bash

# Simple game for calculating numbers
#
# Usage: ./calc-game-b.sh [OPtiON] -v (verbose) 
#Examples: ./calc-game-b.sh
#> ( 1 + 2) ? [OPTION] answer , where options are -a: answer, -s: skip, -n: don't know
#> ( 1 + 2) ? -a 5 <intro>
#> Incorrect! The answer is three.
#
#> ( 5 + 6) ? -a 11 <intro>
#> Correct! The answer is eleven.
#>
#


#Globals

S_NUMBERS_EN="zero one two three four five six seven eight nine ten eleven twelve thirdteen fourteen fiveteen sixteen seventeen eighteen nineteen twenty"
SPLUS_EN='plus'
SMINUS_EN='minus'
S_NUMBERS_ES="cero uno dos tres cuatro cinco seis siete ocho nueve diez once doce trece catorce quince dieciseis diecisiete dieciocho diecinueve veinte"
SPLUS_ES='mas'
SMINUS_ES='menos'
S_NUMBERS_UKR="нульовий один два Три чотири п'ять шість Сім вісім Новий десять одинадцять Дванадцять тринадцять Чотирнадцять п'ятнадцять шістнадцять сімнадцять вісімнадцять дев'ятнадцять двадцять"
SPLUS_UKR='плюс'
SMINUS_UKR='мінус'
S_NUMBERS_DE="null ein zwei Drei vier fünf sechs Sieben acht Neu zehn elf Zwölf dreizehn Vierzehn fünfzehn Sechszehn siebzehn achtzehn neunzehn zwanzig"
SPLUS_DE='plus' 
SMINUS_DE='minus'
S_NUMBERS_FR="zéro une deux Trois quatre cinq six Sept huit neuf Dix Onze Douze treize Quatorze quinze seize dix-sept dix-huit dix-neuf vingt"
SPLUS_FR='plus'
SMINUS_FR='moins'

S_NUMBERS=""
SPLUS=''
SMINUS=''
NMAX=18

#Program variables
EQUATION=''
EXIT=-1
SOL=""
CNT=0
NTOTG=0
NTOTP=0
RES=0
NBER=0
SCORE=0
USER=''
LANG='en'
OPTION=''
SPELLED=''

#Functions
#	
error() {
local NUM="${1}"
case $NUM in
1)
echo "Error "
;;
2)
echo "Error, MAX must be < ${NMAX} "
;;
3)
echo "Error "
;;
*)
#echo 'Undetermined error"
      NUM=-1
;;

esac 

echo "Exiting...."
exit $NUM	

}
#
choose_lang() {
local LN=''

if [[ $# -eq 0 ]]
then
 LN=en
else
 LN="${1}"
fi

case "${LN}" in

es) #spanish 

S_NUMBERS="${S_NUMBERS_ES}"
SPLUS="${SPLUS_ES}"
SMINUS="${SMINUS_ES}"
#rest of dialogs
;;
fr) #french

S_NUMBERS="${S_NUMBERS_FR}"
SPLUS="${SPLUS_FR}" 
SMINUS="${SMINUS_FR}"
#rest of dialogs
;;
de) #german

S_NUMBERS="${S_NUMBERS_DE}"
SPLUS="${SPLUS_DE}"
SMINUS="${SMINUS_DE}"

#rest of dialogs
;;
ukr) #ukranian

S_NUMBERS="${S_NUMBERS_UKR}"
SPLUS="${SPLUS_UKR}" 
SMINUS="${SMINUS_UKR}"
#rest of dialogs
;;
en) #defaults to english

S_NUMBERS="${S_NUMBERS_EN}"
SPLUS="${SPLUS_EN}" 
SMINUS="${SMINUS_EN}"
#rest of dialogs
;;
esac

}
#
spell_num() {

local VAL="${1}"
local SYM=$SPLUS
local N=0
local S=''

if [[ $VAL -lt 0 ]]
then
SYM=$SMINUS
VAL=$((-1 * $VAL))
fi

for STN in ${S_NUMBERS}
do
N=$(expr $N + 1)
if [[ ${N} -eq $((${VAL} + 1)) ]]
then
    S="${STN}"
	break;
elif [[ ${N} -gt ${VAL} ]]
then
   STN=''
   break;
fi

done
SPELLED="\'${SYM} ${S}\'"

}
#
menu() {


local USR='?????'
local CR=1    
	while getopts m:l:u:h OPTION
	do
	case ${OPTION} in
	h)
	echo "Help under construction... "
	echo
	;;
	m)
	SN_MAX=$(( OPTARG * 1 ))
	
	if [[ $SN_MAX -lt 0 || $SN_MAX -gt $NMAX ]]
	then
	 SN_MAX=$NMAX
	 echo "Max set to ${NMAX}"
	 #error 2
	 fi
	;;
	l)
      echo $OPTARG
	  choose_lang $OPTARG
	  
	;;
	u)
    	#manage users?
		USR=$OPTARG
		if [[ $USR != 'JOE' && $USR ]] 
	    then
		USER="${USR}"
	    else
		 USER='anonymous'
	    fi

		#CHECK USER
		#CREATE FILE
	;;

	?)
		echo "Not found"
	;;
	esac
	done
	# Remove the options while leaving the remaining arguments.
	shift "$(( OPTIND - 1 ))"
	
	echo "Welcome ${USER} to Calc-Game ! Max number is: ${SN_MAX}"
	echo "Let's play...!"
	

	}
#
gen_equation() {

local A=0 
local B=0
#local OPERATIONS= "\'-\' \'+\'"
local OP=''
local MAX=$1

#need for more randomized by using a loop
RND=$(echo $RANDOM)
A=$( expr $RND % $MAX )


until [[ $B -ne 0 ]]
do
RND=$(echo $RANDOM)
B=$( expr $RND % $MAX )
done

OP='+'
RDN=$(echo $RANDOM)
ROP=$( expr $RND % 3 )
case $ROP in
0)
OP='-'
;;
1)
OP='/'
;;
?)
OP='+'
;;
esac
	
EQUATION="$A $OP $B"

}
#
solve_equation(){

case $2 in
'-')

RES=$((${1} - ${3}))

;;
'/')

RES=$((${1} / ${3}))

;;
'+')

RES=$(expr $1 + $3)

;;
?)
echo 'Invalid operand'
;;
esac


}
#
game_summary() {

local DATE=$(date)
local PERF=0	
local SC=$SCORE
	
	echo " Game Summary for user \" ${USER} \":"
	echo " Your game at date: ${DATE} "
	echo " You played ${NTOTG} YOUR SCORE: ${SC} "
	PERF=$(((${NTOTP} / ${NTOTG})* 100))
	echo " Your performance : ${PERF} "
	echo " Total trials : ${CNT} of max 20 "
	
	}
#
ask_user() {
	
   echo "What is the outcome of this operation ( $1 $2 $3 )  ?"  
   echo "------------------------------------------------------"	
   

	}	
#
user_plays() {

local EQ=''
#local SPELLED=''

local OPTARG="${1}"	
local OPTION=''

#echo "User plays: $@ "	
if [[ $# -ge 1 ]]
then
OPTION=a
case "${1}" in
'-e') OPTION=e ;;
'-s') OPTION=s ;;
'-n') OPTION=n ;;
esac
fi

	   	
   # getopts a:s OPTION  
   #	echo $OPTION
	case "${OPTION}" in
	a) 
	#Answer mode
      # echo $OPTARG
       
		NBER=$((OPTARG * 1))
		
		
		if [[ ! $NBER || $NBER -gt $(($SN_MAX + 10)) ]]
		then
		error 3
		fi
		
		spell_num "${RES}"
		
		if [[ $NBER -eq $RES ]]
		then
			echo "Your answer is CORRECT! IS: ${RES} OR: ${SPELLED} "
			SCORE=$((SCORE + 1))
			echo  "Your SCORE = ${SCORE}"
			NTOTP=$((NTOTP + 1))
		else
		    echo "Your answer is INCORRECT! ${NBER} IS NOT EQUAL To ${RES} NOR: ${SPELLED} "
			SCORE=$((SCORE - 1))
			echo  "Your SCORE = ${SCORE}"
		
		fi
		NTOTG=$(($NTOTG + 1))
	;;
	s)
		echo "Skipping question"
		
	;;
	n)
		echo "You answered Dont know (-n) , the ANSWER IS: ${RES} OR: ${SPELLED} "
		SCORE=$((SCORE - 1))
		echo  "Your SCORE = ${SCORE}"
		
	;;
	e)
		echo "You choose to EXIT the game"
		EXIT=0
		game_summary 	
		break
	;;
	?)
		echo "Invalid option, try again"
		echo  "Valid options: -a <your answer> -s (skip) -n (don't know) -e (exit) "
	;;
	esac
	
	

	
	
	
}

play_game() {
	
   
      gen_equation $SN_MAX
	 
	  solve_equation $EQUATION 

      ask_user $EQUATION 
	
	  read -p ":: " SOL
	
	  #echo $SOL
	
	  user_plays "${SOL}"

    
   	
}	
		

#
while [[ 1 && CNT -lt 20 ]]
do

	menu $@
	play_game 
	
    if [[ $EXIT -eq 0 ]] 
    then
	  break
	else
		EXIT=-1
	fi
CNT=$(($CNT + 1))
 
done
if [[ $CNT -eq 20 ]] 
then
 echo " Max of trial options input reached, Exiting... "
fi
echo "Good Bye!"
		
exit 0

