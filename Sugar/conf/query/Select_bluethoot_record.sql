SELECT * FROM bluetooth 
INTO OUTFILE './Export_BL.csv' 
FIELDS TERMINATED BY ',' 
OPTIONALLY ENCLOSED BY '"' 
LINES TERMINATED BY '\n';
