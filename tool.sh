#!/bin/bash
#6007
#βουιδασκης χαραλαμπος
person=0
j=0
id=0
lastflag=0
firstflag=0
brow=0
dateA=0
since=0
unti=0
dateB=0
idi=0
for ((i=1; i<=$#; i++))
do
	if [ "${!i}" = "-f" ]
	then
	let j=($i + 1) #κανω let για γινει η πραξη
	person="${!j}" # βαζω στο person την θεση που ειναι το αρχειο
	fi
	if [ "${!i}" = -id ]
	then
	let j=($i + 1)
	id="${!j}" # βαζω στο id την θεση που ειναι το id
	idi=1
	fi
	if [ "${!i}" = --firstnames ]
	then
	firstflag=1 #χρισιμοποιω το firstflag για ενεργοποιηση ποιο κατω στον κωδικα
	fi
	 if [ "${!i}" = --lastnames ]
        then
        lastflag=1
        fi
	if [ "${!i}" = --browsers ]
	then
	brow=1
	fi
	if [ "${!i}" = --born-since ]
	then
	let j=($i + 1)
	dateA="${!j}" # βαζω στο dateA την θεση που ειναι η ημερωμινια
	since=1 
	fi
	if [ "${!i}" = --born-until ]
        then
        let j=($i + 1)
        dateB="${!j}"
        unti=1
        fi
done
if [ $# -gt 1 ]
then
	if [ $# -eq 2 ] #επειδη υπαρχει μονο μια περιπτωση να εχουμε 2 παραμετρους ερωτημα a
	then
	awk -F '|' '/^[^#]/' $person #βγαζει τα σχολια
	fi
	if [ $idi = 1 ] # ενεργοποιει το ερωτημα b 
	then
	grep -v '#' $person | grep -w "^$id" |sed  's/|/ /g' | awk '{print $3,$2,$5}' # η sed βγαζει τα (|) και η awk εκτυπονει
	fi
	if [ $# -eq 3 ]
	then
		if [ $firstflag = 1 ] # ενεργοποιει το ερωτημα c 
		then
		 awk -F '|' '/^[^#]/' $person | awk -F '|' '{print $3}' | sort -n | uniq # sort κανει ταξινομησ η uniq δενβγαζει διο ιδια
		fi
		if [ $lastflag = 1 ] # ενεργοποιει το ερωτημα d
        	then
        	 awk -F '|' '/^[^#]/' $person | awk -F '|' '{print $2}' | sort -n | uniq
        	fi
	fi
	if [ $brow = 1 ] #ενεργοποιει το ερωτημα f
	then
	awk -F '|' '/^[^#]/{ print $8 }' $person | sort | uniq -c | perl -pe 's/(\S+)(\s+)(.*)/$3$2$1/' | sed 's/^[ \t]*//' 
	#η sed αφερει στην αρχη τα κενα και η perl τα τοποθετει με την σειρα 
	fi
	if [ $since = 1 ] && [ $unti = 0 ] #ενεργοποιει το ερωτημα g μονο το μεγαλυτερο απο
        then
        awk '/^[^#]/' $person | awk -F "|" -v date="${dateA}" '{if( date <= $5 ) print } ' #to awk συγκρινει και μετα αποθηκευει τα μικροτερα απ
        fi
	if [ $unti = 1 ] && [ $since = 0 ] #ενεργοποιει το ερωτημα g μανο το μεχρι μικροτερο
        then
        awk '/^[^#]/' $person | awk -F "|" -v date="${dateB}" '{if( date >= $5 ) print } ' #το awk συγρινει και μετα δειχνει τα μεγαλητερα απο
        fi
	if [ $since = 1 ] && [ $unti = 1 ] #ενεργοποιει το ερωτημα g ολοκληρο και δεινει τα ενδιαμεσα μετα την συγριση
	then
 awk '/^[^#]/' $person | awk -F "|" -v date="${dateA}" '{if( date <= $5 )  print } ' | awk -F "|" -v date="${dateB}" '{if( date >= $5 ) print } '
	fi
else
echo 6007
fi
