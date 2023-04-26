#!/bin/bash

FILE="*.csv"
INPUT_DIR=$PWD/input
OUTPUT_DIR=$PWD/output
SQL_DIR=$OUTPUT_DIR/sql
TMP_DIR=$CONF_DIR/tmp
CONF_DIR=$PWD/conf/query
ERROR_LOG=$PWD/log
DATA=$(date +%Y_%m_%d)
DB="Wigle"



ICON () {

N="\e[41;30;2m"
D="\e[0;49m"
M="\e[41;30;7m\e[2m\e[5m"

#carattere elite
echo -e """
$N██████████████████████████████████████████████████$D
$N██████████████████████▓████████████▓██████████████$D
$N█████████████████████▒░▓▓████████▓░▒▓█████████████$D
$N████████████████▒▓███▒▓██████████▒░▓██████████████$D
$N███████████████░░▓███▓▒█████████▓░▓███████████████$D
$N███████████████▒▒████▓░▒▓▓██████░░▓███████████████$D
$N███████████████▓░▓█▓██▒░▒▓▓████░░░▓███████████████$D
$N████████▓▓▓█████▒░▒▒▒█▓░░▒▒▓██▒░░░▓███████████████$D
$N████████▒░▒▓▓████▓░░▒▒▒░░░░░░░░░▒▒████████████████$D
$N█████████▓▓██▓████▓░░░░░▒▒░░░░░▒▒█████████████████$D
$N████████████▓▓█▓██▒░░▒▓▒▒▒░░░░░▒▒█████████████████$D
$N██████████████▓▓█▒░░▓██▓▒▒░░░░░░▓█████████████████$D
$N████████████████▒░░▓█▓█▓▓░░░░░░░▓█████████████████$D
$N█████████████████░░░▒▓▓▓▓░▒░░░░░░▒▓▓▓█████████████$D
$N█████████████████░░░░░▒▓░░░░░░░░░░░░░░░▒▓▒▒▓██████$D
$N█████████████████▓░░░░░░░░░░░░░░░░░░░░░░░░░░▒█████$D
$N██████████████████░░░░░░░░░░░░░▒▒▓▓███▓▓▓▒▒▓██████$D
$N█████████████████▓░░░░░░░░░░▒▓████████████████████$D
$N████████████████▒░░░░░░░░▒▓▒██████████████████████$D
$N██████████████▓▓░░░░░░░▒▒█▓▓██████████████████████$D
$N██████████████▓▓░░░░░░▒▓██████████████████████████$D
$N█████████████▓█▓░░░░░░▓████▓██████████████████████$D
$N████████████▓▓█▓▒░░░▒██████▓██████████████████████$D
$N███████████▓▓▓███▓▓▓██████▓███████████████████████$D
$M        .▄▄ · ▄• ▄▌ ▄▄ •  ▄▄▄· ▄▄▄                $D
$M        ▐█ ▀. █▪██▌▐█ ▀ ▪▐█ ▀█ ▀▄ █·              $D
$M        ▄▀▀▀█▄█▌▐█▌▄█ ▀█▄▄█▀▀█ ▐▀▀▄               $D
$M        ▐█▄▪▐█▐█▄█▌▐█▄▪▐█▐█ ▪▐▌▐█•█▌              $D
$M         ▀▀▀▀  ▀▀▀ ·▀▀▀▀  ▀  ▀ .▀  ▀              $D
Made by Psychonaut
Version 1.0 - 14/04/2023   
"""
}




COUNT_RETI () {

  WIFI=$(cat $INPUT_DIR/$FILE|cut -d"," -f11|grep -I WIFI|wc -l)
  BL=$(cat $INPUT_DIR/$FILE|cut -d"," -f11|egrep -I 'BT|BLE'|wc -l)
  ALL=$(cat $INPUT_DIR/$FILE|wc -l)
  echo -e "Network in the CSV:"
  echo -e "------------------------"
  echo -e "Wifi Networks Found:\033[34;39;6m $WIFI \033[0m"
  echo -e "Blutooth Networks Found:\033[34;39;6m $BL \033[0m"
  echo -e "Total Networks Found:\033[34;39;6m $(( $ALL - 2 )) \033[0m"

}

COUNT_DB () {

  COUNT_DB_BL=$(mysql -e 'USE Wigle; select count(*) from bluetooth;' Wigle|sed '/^+-/d'|sed '/^count/d')
  COUNT_DB_WIFI=$(mysql -e 'USE Wigle; select count(*) from wifi;' Wigle|sed '/^+-/d'|sed '/^count/d')
  echo -e "Network in the Database:"
  echo -e "------------------------"
  echo -e "Wifi Network :\033[34;39;6m $COUNT_DB_WIFI \033[0m"
  echo -e "Bluetooth Network:\033[34;39;6m $COUNT_DB_BL \033[0m"

}

CREATE_DB () {

	mysql --force -b 2> $ERROR_LOG/log_db_$DATA.txt -e "create database $DB";
    if [[ $? == 0 ]];
    then
      echo "Database $DB created"
	  mysql $DB < $CONF_DIR/Create_table_bluethoot.sql
	  mysql $DB < $CONF_DIR/Create_table_wifi.sql
	  echo "Created Tables"
    elif [[ $? == 1 ]]
    then
      echo "The Database already exist"
    fi
}

INSERT_WIFI () {

	WIFI=$SQL_DIR/WIFI*.sql

	mysql -b $DB < $WIFI 2> $ERROR_LOG/log_insert_wifi_$DATA.txt
    if [[ $? == 1 ]];
    then
      mysql -e "use $DB; truncate table wifi"
      echo "There was an error inserting into the Wifi table, check the log"
      echo "Cleared Table"
    elif [[ $? == 0 ]]
    then
      echo "Query exetuded successfully"
    fi
}

INSERT_BL () {

	BL=$SQL_DIR/BLT*.sql

	mysql -b $DB < $BL 2> $ERROR_LOG/log_insert_bl_$DATA.txt
    if [[ $? == 1 ]];
    then
      mysql -e "use $DB; truncate table bluetooth $DB;"
      echo "There was an error inserting into the Bluetooth table, check the log"
      echo "Cleared Table"
    elif [[ $? == 0 ]]
    then
      echo "Query exetuded successfully"
    fi
}



EXPORT_WIFI+ () {


	cat << EOF

Select the network you wanna export :

1)WPA2
2)WPA
3)WEP
4)ESS

EOF

	read N
	if [[ $N == "1" ]];
	then
        	echo "Running query . . ."
        	mysql -b $DB < $CONF_DIR/Select_wifi_record_WPA2.sql 2> $ERROR_LOG/log_wifi_export_wpa2_$DATA.txt
    		if [[ $? == 1 ]];
   		then
			echo "There was an error, check the log"
   		elif [[ $? == 0 ]];
   		then
     			echo "Query exetuded successfully"
   		fi
        elif [[ $N == "2" ]];
        then
                echo "Running query . . ."
                mysql -b $DB < $CONF_DIR/Select_wifi_record_WPA.sql 2> $ERROR_LOG/log_wifi_export_wpa_$DATA.txt
                if [[ $? == 1 ]];
                then
                        echo "There was an error, check the log"
                elif [[ $? == 0 ]];
                then
                        echo "Query exetuded successfully"
                fi
        elif [[ $N == "3" ]];
        then
                echo "Running query . . ."
                mysql -b $DB < $CONF_DIR/Select_wifi_record_WEP.sql 2> $ERROR_LOG/log_wifi_export_wep_$DATA.txt
                if [[ $? == 1 ]];
                then
                        echo "There was an error, check the log"
                elif [[ $? == 0 ]];
                then
                        echo "Query exetuded successfully"
                fi
        elif [[ $N == "4" ]];
        then
                echo "Running query . . ."
                mysql -b $DB < $CONF_DIR/Select_wifi_record_ESS.sql 2> $ERROR_LOG/log_wifi_ess_$DATA.txt
                if [[ $? == 1 ]];
                then
                        echo "There was an error, check the log"
                elif [[ $? == 0 ]];
                then
                        echo "Query exetuded successfully"
                fi

	fi
}




EXPORT_WIFI () {

	echo "Running query . . ."
	mysql -b $DB < $CONF_DIR/Select_wifi_record.sql 2> $ERROR_LOG/log_wifi_export_$DATA.txt

    if [[ $? == 1 ]];
    then
      echo "There was an error, check the log"
    elif [[ $? == 0 ]];
    then
      echo "Query exetuded successfully"
    fi
}



EXPORT_BL () {

        echo "Running query . . ."
        mysql -b $DB < $CONF_DIR/Select_bluethoot_record.sql 2> $ERROR_LOG/log_bl_export_$DATA.txt

    if [[ $? == 1 ]];
    then
      echo "There was an error, check the log"
    elif [[ $? == 0 ]];
    then
      echo "Query exetuded successfully"
    fi
}


EXPORT_NAME () {


cat << EOF

1) wifi
2) bluethoot

EOF
        read DEVICE
        if [[ $DEVICE == "1" ]];
        then
		echo "Enter name to search"
		read NAME
	        echo "Running query . . ."
	        mysql -e "use $DB; SELECT * FROM wifi WHERE SSID LIKE \"%$NAME%\";"

		prompt="Save result? y/N :"
		read -p "$prompt" INPUT
		if [[ $INPUT == "Y" || $INPUT == "y" || $INPUT == "yes" ]];
		then
		        mysql -e "use $DB; SELECT * FROM wifi WHERE SSID LIKE \"%$NAME%\" INTO OUTFILE './Export_WIFI_$NAME.csv' FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '\"' LINES TERMINATED BY '\n';"
		elif [[ $INPUT == "N" || $INPUT == "n" || $INPUT == "no" ]];
		then
			exit 0
		else 
			echo "General Error."
		fi
	elif [[ $DEVICE == "2" ]];
	then
                echo "Enter name to search"
                read NAME
                echo "Running query . . ."
                mysql -e "use $DB; SELECT * FROM bluetooth WHERE Device_Name LIKE \"%$NAME%\";"

                prompt="Save result? y/N :"
                read -p "$prompt" INPUT
                if [[ $INPUT == "Y" || $INPUT == "y" || $INPUT == "yes" ]];
                then
                        mysql -e "use $DB; SELECT * FROM bluetooth WHERE Device_Name LIKE \"%$NAME%\" INTO OUTFILE './Export_BL_$NAME.csv' FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '\"' LINES TERMINATED BY '\n';"

                elif [[ $INPUT == "N" || $INPUT == "n" || $INPUT == "no" ]];
                then
                        exit 0
                else 
                        echo "General Error."
                fi

        else
                echo "Choose which type of device to search for."
        fi

}

SPLIT () {

  OUTPUT_WIFI="$SQL_DIR/WIFI_$DATA.sql"
  OUTPUT_BL="$SQL_DIR/BLT_$DATA.sql"

  TMP_WIFI="$TMP_DIR/wifi.tmp"
  TMP_BL="$TMP_DIR/bl.tmp"
  local FILE2="$INPUT_DIR/$FILE"

  echo "Running . . ."
  cat $FILE2|cut -d, -f11|egrep -nI "WIFI" >> $TMP_WIFI
  cat $FILE2|cut -d, -f11|egrep -nI "BLE|BT" >> $TMP_BL
  
  while IFS= read -r line; do
    awk -v riga="${line//:*}" 'NR==riga {print"" $0 }' $FILE2 >> $OUTPUT_WIFI
  done < $TMP_WIFI

  while IFS= read -r line; do
    awk -v riga="${line//:*}" 'NR==riga {print"" $0 }' $FILE2 >> $OUTPUT_BL
  done < $TMP_BL

  rm $TMP_WIFI $TMP_BL

  echo -e "Completed"
}


ADD_CHARTER () {

sed -i "s/^/insert ignore into wifi values ('/g;s/,/', '/g;s/$/');/g" $OUTPUT_WIFI
sed -i "s/^/insert ignore into bluetooth values ('/g;s/,/', '/g;s/$/');/g" $OUTPUT_BL


echo -e "Generate file: \033[30;44;6m $OUTPUT_WIFI \033[0m"
echo -e "Generate file: \033[32;41;6m $OUTPUT_BL \033[0m"

}

HELP2 () {

echo -e "\nUse: Sugar.sh --help || Sugar.sh -h to call back the help\n"

}

HELP () {

cat << EOF

Database creation options:

	-g  --generate	:Generate database and tablespaces for data storage, Wifi and Bluetooth networks.

Goal count options:

	-c --count	:Count the networks present in the database or in the input csv file.

	Arguments:

		-c csv	:The Wifi and Bluetooth networks present only in the csv file are counted, duplicate records are also counted.

		-c db	:The Wifi and Bluetooth networks present inside the database are counted.
			 It must be used only after creating the database and inserting the networks.
			 Unlike the csv argument, there are no duplicate networks here.

		-c all	:It outputs both the count of networks present in the csv and those present in the db.

File split options:

	-s --split	:Split the csv file into two files, one containing the wifi records and the other the bluetooth ones.
			 Then transform the csv files into insert queries.

Data entry options:

	-i --insert	:Execute the queries generated within the respective database tables.
			 In case of an error during the insert check the logs.
			 There may still be some dirty characters inside the sql scripts.
			 In this phase the inserts are performed using the "INSERT IGNORE" option so as not to insert any duplicate rows.

Export options:

	-e --export	:Export the data present in the tables in csv files, in various ways.
			 Generally the exports are saved in the /var/lib/mysql directory.

        Arguments:

		-e w	:All the networks present in the wifi table are exported in a csv file.

		-e b	:All the networks present in the bluetooth table are exported in a csv file.

                -e wb   :All the networks present in the database are exported in a csv file.

		-e w+	:The user can choose which Wifi networks to export within the csv between WPA2, WPA, WEP, ESS.

		-e n	:The user can perform a search based on the name of the networks (SSID) on both tables, these are returned in output.
			 It is also given the possibility to save the networks in a csv file.


EOF
}


ICON
getopt --test > /dev/null
if [[ $? -ne 4 ]];
then
	echo "La versione di getopt non è corretta."
	echo "Installa il pacchetto utils-linux tramite il Packaging Tool del tuo sistema"
	exit 1
fi

SHORT_O=hsc:gie:
LONG_O=help,split,count:,generate,insert,export:

TEMP=$(getopt --options="$SHORT_O" --longoptions="$LONG_O" --name "Dingo_test.sh" -- "$@")
if [[ $? -ne 0 ]];
then
	HELP
	exit 2
fi

eval set -- "$TEMP"

while true
do
	case "$1" in
		-h|--help)
			HELP
			shift
			;;
		-c|--count)
			if [[ $2 == "db" ]];
			then
				COUNT_DB
			elif [[ $2 == "csv" ]]
			then
				COUNT_RETI
			elif [[ $2 == "all" ]]
			then
				COUNT_DB
				echo -e "\n::::::::::::::\n"
				COUNT_RETI
			else
				echo "Invalid option, use Sugar --help"
			fi
			shift
			;;
		-s|--split)
			SPLIT
			ADD_CHARTER
			shift
			;;
		-g|--generate)
			CREATE_DB
			shift
			;;
		-i|--insert)
			INSERT_WIFI
            		INSERT_BL
			shift
			;;
		-e|--export)
			if [[ $2 == "w" ]];
			then
				EXPORT_WIFI
			elif [[ $2 == "b" ]];
			then
				EXPORT_BL
			elif [[ $2 == "wb"  ]];
			then
				EXPORT_WIFI
				EXPORT_BL
			elif [[ $2 == "w+" ]];
			then
				EXPORT_WIFI+
			elif [[ $2 == "n" ]];
			then
				EXPORT_NAME
			else
				echo "Invalid option, use Sugar --help"
			fi
			shift
			;;
		--)
			HELP2
			shift
			break
			;;
		*)
			echo "Bye Bye!"
			exit ;;
	esac
done


