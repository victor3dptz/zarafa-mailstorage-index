#!/bin/bash

# Requires: procmail mysql-client

URL=/home/nfs/mail
DBUSER="USER"
DBPASS="PASS"
DBHOST="127.0.0.1"
DB="DATABASE"

find $URL -type f ! -name *.gz > all.txt

while IFS='' read -r line || [[ -n "$line" ]]; do
echo $line
check=`grep -I -r -e "^To:" $line`
if [ ! -z "$check" ]
then
echo OK
id=$(echo "SELECT id FROM storage WHERE file LIKE '%$line%'"| mysql -N -u$DBUSER -p$DBPASS -h $DBHOST $DB 2>/dev/null)
if [ ! -z "$id" ]
then
echo In base: $id
else
echo "Not in base"
date_text=`cat $line | formail -x Date`
date=`date -d "$date_text" +%Y-%m-%d`
time=`date -d "$date_text" +%H:%M-%S`
#echo $date
#echo $time
from=`cat $line | formail -x From | awk -vRS=">" -vFS="<" '{print $2}'`
if [ -z "$from" ]
then
fro=`cat $line | formail -x From | awk 'NR>1 {print $1}'`
from="$(echo "${fro//$'\n'/; }" | sed 's#^; ##g')"
if [ -z "$from" ]
then
from=`cat $line | formail -x From | awk '{print $1}'`
fi

fi
to=`cat $line | formail -x To | awk -vRS=">" -vFS="<" '{print $2}'`
if [ -z "$to" ]
then
to=`cat $line | formail -x To`
fi

#echo $to
mail_to="$(echo "${to//$'\n'/; }" | sed 's#^; ##g')"
#cat $line | formail -x To
#echo $from
#echo $mail_to
echo "INSERT INTO storage (file,date,time,mail_from,mail_to) VALUES ('$line','$date','$time','$from','$mail_to')" | mysql -u$DBUSER -p$DBPASS -h $DBHOST $DB 2>/dev/null
unset date
unset time
unset mail_to
unset date_text
unset from
unset to
fi
unset id
fi
unset check
done < "all.txt"

find $URL -type f -name *.gz > gz.txt

while IFS='' read -r line || [[ -n "$line" ]]; do
echo $line
check=`zgrep -I -e "^To:" $line`
if [ ! -z "$check" ]
then
echo OK
id=$(echo "SELECT id FROM storage WHERE file LIKE '%$line%'"| mysql -N -u$DBUSER -p$DBPASS -h $DBHOST $DB 2>/dev/null)
if [ ! -z "$id" ]
then
echo In base: $id
else
echo "Not in base"
date_text=`zcat $line | formail -x Date`
date=`date -d "$date_text" +%Y-%m-%d`
time=`date -d "$date_text" +%H:%M-%S`
#echo $date
#echo $time
from=`zcat $line | formail -x From | awk -vRS=">" -vFS="<" '{print $2}'`
if [ -z "$from" ]
then
fro=`zcat $line | formail -x From | awk 'NR>1 {print $1}'`
from="$(echo "${fro//$'\n'/; }" | sed 's#^; ##g')"
if [ -z "$from" ]
then
from=`zcat $line | formail -x From | awk '{print $1}'`
fi

fi
to=`zcat $line | formail -x To | awk -vRS=">" -vFS="<" '{print $2}'`
if [ -z "$to" ]
then
to=`zcat $line | formail -x To`
fi

#echo $to
mail_to="$(echo "${to//$'\n'/; }" | sed 's#^; ##g')"
#cat $line | formail -x To
#echo $from
#echo $mail_to
echo "INSERT INTO storage (file,date,time,mail_from,mail_to) VALUES ('$line','$date','$time','$from','$mail_to')" | mysql -u$DBUSER -p$DBPASS -h $DBHOST $DB 2>/dev/null
unset date
unset time
unset mail_to
unset date_text
unset from
unset to
fi
unset id
fi
unset check
done < "gz.txt"

