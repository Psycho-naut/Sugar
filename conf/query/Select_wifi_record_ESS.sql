SELECT * FROM wifi 
WHERE Capabilities 
LIKE "[ESS]"
INTO OUTFILE './Export_WIFI_ESS.csv' 
FIELDS TERMINATED BY ',' 
LINES TERMINATED BY '\n';

