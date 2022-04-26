#!/bin/bash

#Game mainly based on arrays
#It potentially (future) can support multilingual

#Globals

M_MAIN_COURSE_EN=('Chicken_soup' 'Salad'  'Veggie_soup')
M_SEC_COURSE_EN=('Cod_fish' 'BeffSteak' 'Pork_chop')
M_DESSERT_EN=('Apple' 'Grapes' 'Muffin' 'Banana')
SEP=' ++ '
M_MAIN_COURSE=()
M_SEC_COURSE=()
M_DESSERT=()

M_RAND_MENUS=()

M_YOUR_CHOSEN_MENUS=()

set_lang_en() {

 
 for ITM in ${M_MAIN_COURSE_EN[@]} 
 do
	M_MAIN_COURSE+=($ITM)
 done	
	
 for ITM in ${M_SEC_COURSE_EN[@]} 
 do
	M_SEC_COURSE+=($ITM)
 done	

 for ITM in ${M_DESSERT_EN[@]} 
 do
	M_DESSERT+=($ITM)
 done	


}

choose_lang() {
local LN=''
if [[ $# -ge 1 ]]
then
	LN=$1
else
	LN=en
fi
echo $LN
case "${LN}" in
en)

 set_lang_en

;;
esac
	
}

generate_n_menus() {
local MAX=$1
local N=0
local IDX

local MNU=''
local MAIN=''
local SEC=''
local DES=''
while [[ $N -lt $MAX ]]
do
IDX=$RANDOM
IDX=`expr $IDX % ${#M_MAIN_COURSE[@]}`
MAIN=${M_MAIN_COURSE[$IDX]}
IDX=$RANDOM
IDX=`expr $IDX % ${#M_SEC_COURSE[@]}`
SEC=${M_SEC_COURSE[$IDX]}
IDX=$RANDOM
IDX=`expr $IDX % ${#M_DESSERT[@]}`
DES=${M_DESSERT[$IDX]}
MNU="${MAIN}${SEP}${SEC}${SEP}${DES}"
N=`expr $N + 1`
M_RAND_MENUS[$N]=`printf "%s" $MNU`
done	

echo $N

}
display_menus() {
local N=0
	for ITM in ${M_RAND_MENUS[@]}
	do
	 N=`expr $N + 1`
	 echo " ${N} - ${ITM} "
	done
	
	
	}
ask_menus_user() {
local N=0
local IDX=0
local CHOICE=''

	for ITM in ${M_RAND_MENUS[@]}
	do
	 N=`expr $N + 1`
	 echo " ${N} - ${ITM} "
	 read -p "Do you like this menu? (yes,no) " CHOICE	
	 if [[ $CHOICE == 'yes' ]]
	 then
		IDX=`expr $IDX + 1`
		M_YOUR_CHOSEN_MENUS[$IDX]="${ITM}"
	 fi
	
	done
	
	
	
	
	
	
	
	
	}

display_user_menus() {
local N=0	
	for ITM in ${M_YOUR_CHOSEN_MENUS[@]}
	do
	 N=`expr $N + 1`
	 echo " ${N} - ${ITM} "
	done
	}


LAN='en'

if [[ $# -gt 1 ]]
then
LAN=$1
NM=$2
elif [[ $# -eq 1 ]]
then
NM=$1
else
echo "You must supply entry parameters (Language (opt), Number of menus to generate)"
exit 1
fi
choose_lang $LAN
generate_n_menus $NM
display_menus
echo; echo
echo "Choose you preferred menus"
ask_menus_user
echo "Menus of your choice"
display_user_menus
echo;echo
exit 0




