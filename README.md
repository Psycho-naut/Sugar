# Sugar

*Read this in other languages: [English](README.EN.md).

![pxArt](https://user-images.githubusercontent.com/54377521/234706539-a601fed6-0a9e-441a-88a9-bacd4023848c.png)
> Sugar è uno script che automatizza la creazione di DB e tabelle, e la modifica e l'export dei record contenuti nei file csv generati da Wigle


# Indice

- [Script](#script)
- [Installazione Dipendenze](#installazione-dipendenze)
- [Creazione Directory](#creazione-directory)
- [Utilizzo](#utilizzo)

# Script

Lo Script è scritto interamente in bash e mysql, per la parte Database viene utilizzato mariaDB.
Quest'ultimo è stato pensato e testato usando file CSV prodotti da Wigle tramite cellulare.
Dopo aver eseguito una sessione di wardriving ed esportato le reti trovate in formato csv, è possibile creare in maniera automatica un Database contenente due tabelle, una per le reti Wifi, l'altra per le reti Bluetooth.

Lo script tramite l'apposita opzione genera due file dal csv, uno contenente le reti Wifi e l'altro le reti Bluetooth, in seguito i due file vengono trasformati in maniera automatica in query sql di insert, e possono essere inseriti nel Database, in questo modo vengono eliminati i record doppi.

Il MACAddress delle reti è usato come Primary Key e le query di insert usano l'opzione "INSERT IGNORE" in questo modo si potranno esportare solo i record effettivamente trovati, senza nessuna rete duplice.

Oltre all'export delle intere tabelle, pronte da caricare su Wigle, è possibile effettuare delle ricerche in base alle chiavi utilizzate dalle reti (WPA2,WPA,WEP ...) o agli SSID delle reti Wifi e Bluetooth.

Gli export generati, sempre in csv, vengono salvati in genere nella directory /var/lib/mysql/.

La versione corrente è stata testata su Linux Mint 21.

## Installazione Dipendenze

Iniziamo con l'installazione di mariaDB, lanciando i seguenti comandi : 

```bash
sudo apt update
sudo apt install mariadb-server
sudo systemctl start mariadb.service
```
Ora aggiungiamo tra gli utenti nel DB il nostro utente locale.

Ricaviamo il nome del nostro utente con il seguente comando :
```bash
whoami
```
e lanciamo mariaDB : 
```bash
sudo mariadb
```

Ora lanciamo la seguente query :

```mysql
# Inserire il nome del proprio utente al posto di user

CREATE USER 'user'@'localhost';
GRANT ALL PRIVILEGES ON *.* TO 'user'@'localhost';
FLUSH PRIVILEGES;
```

Ora il nostro utente locale potrà accedere al database e modificarlo.

Verifichiamo che il pacchetto utils-linux sia già installato : 

```bash
dpkg -l|grep utils-linux
```
Altrimenti installiamolo con il comando : 

```bash
sudo apt install utils-linux -y
```


## Creazione Directory

Dopo aver scaricato Sugar con il comando :

```bash
git clone https://github.com/Psycho-naut/Sugar.git
```

lanciamo i seguenti comandi :

```bash
# Entriamo nella directory di Sugar e creiamo le directory mancanti:
cd Sugar
mkdir -p {input,log,output}
mkdir -p output/sql

# Assegnamo i permessi di esecuzione allo script 
sudo chmod +x Sugar.sh
```

# Utilizzo
### Link a documentazione esterna 

# Come contribuire

## Installare le dipendenze di sviluppo

## Struttura del progetto

## Community

### Code of conduct

### Responsible Disclosure

### Segnalazione bug e richieste di aiuto

# Manutenzione 

# Licenza 

## Licenza generale 

## Autori e Copyright

## Licenze software dei componenti di terze parti
