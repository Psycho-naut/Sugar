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
mkdir -p conf/tmp

# Assegnamo i permessi di esecuzione allo script 
sudo chmod +x Sugar.sh
```

# Utilizzo

### Creazione Database

```bash
Sugar.sh --generate
o
Sugar.sh -g
```
Per creare un database rinominato in Wigle, al cui interno verranno create due tabelle, una per le reti wifi e l'altra per le reti bluetooth.

### Contare le reti presenti nel csv o nel database

```bash
Sugar.sh --count <csv|db|all>
o
Sugar.sh -c <csv|db|all>
```
Per contare le reti presenti nel file csv esportato da Wigle bisogna prima copiarlo all'interno directory Sugar/input/ .
Per contare le reti presenti nel database bisogna prima crearlo con l'opzione -g e poi popolarlo con l'opzione -i.

### Divisione reti e creazione script .sql 

```bash
Sugar.sh --split
o
Sugar.sh -s
```
L'opzione --split divide le reti bluetooth da quelle wifi e modifica i file rendendoli delle query eseguibili sul DB.

### Inserimento record nel database

```bash
Sugar.sh --insert
o
Sugar.sh -i
```
L'opzione --insert lancia le query all'interno del db in modo tale da inserire i record, se durante l'esecuzione viene registrato un errore inerente alla sintassi si consiglia di controllare i due file all'interno della directory Sugar/output/sql/, dopo averli aperti con qualsiasi editor assicurarsi che non siano presenti caratteri sporchi.

### Export dati da DB

```bash
Sugar.sh --export
o
Sugar.sh -e

"Opzioni"

Sugar.sh --export b
o
Sugar.sh --export w
o
Sugar.sh --export wb

```
con l'opzione --export possiamo selezionare ed esportare tutti i record presenti nelle tabelle, questi in genere verranno salvati nella directory /var/lib/mysql

l'opzione --export b esporta il contenuto della tabella bluetooth, --export w esporta il contenuto della tabella wifi, --export wb esporta entrambe in due file .csv separati.

Le opzioni sopracitate non producono output.

```bash
Sugar.sh --export w+
o
Sugar.sh --export n
```

L'opzione --export w+ permette di ricercare i record in base alla chiave (WPA2,WPA,WEP,ESS), in output viene rimandato il risultato della select, in seguito è possibile salvare il risultato della query.

L'opzione --export n permette di cercare su una delle due tabelle a scelta dei record partendo dal nome della rete (SSID).


## Autori e Copyright

Autore: Psychonaut

Non mi assumo nessuna responsabilità in merito all'uso dello script, creato al solo fine di studiare la manipolazione di file csv e il loro storage.
Lo script può essere scaricato e modificato a piacimento.
