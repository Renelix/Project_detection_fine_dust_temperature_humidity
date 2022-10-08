/*
  Antonio Caiafa
  
  Codice sorgente per la lettura attraverso la scheda ESP8266, i sensori DHT22 ed SDS011, di Temperatura, Umidità, PM 2.5 e PM 10.*/

/*Inclusione librerie per il corretto funzionamento di: Sensore DHT22, Sensore SDS011.
 *Definizione variabili globali: DHTPIN = D5 e DHTTYPE = DHT22.*/
#include <DHT.h>
#include <SDS011.h>
#define DHTPIN D5
#define DHTTYPE DHT22

/*Creazione oggetti my_sds di tipo SDS011 e dht(DHTPIN, DHTTYPE) di tipo DHT.*/
SDS011 my_sds;
DHT dht(DHTPIN, DHTTYPE);

/*Definizione variabili globali:
 * Temperatura, Umidita, PM10, PM25 di tipo float.
 * error di tipo int.*/
float Temperatura, Umidita, PM10, PM25;
int error;

/*Procedura per standardizzare il risultato ottenuto secondo la stessa dimensione di cifre,
  tramite opportuni controlli attraverso costrutti if.*/
void Uniformazione(){
  if(Temperatura<10){
    Serial.print("00" + String(Temperatura));
  }
  else if(Temperatura<100){
    Serial.print("0" + String(Temperatura));
  }
  else if(Temperatura>100){
    Serial.print(Temperatura);
  }
  if(PM25<10){
    Serial.print("00" + String(PM25));
  }
  else if(PM25<100){
    Serial.print("0" + String(PM25));
  }
  else if(PM25>100){
    Serial.print(PM25);
  }
  if(Umidita<10){
    Serial.print("00" + String(Umidita));
  }
  else if(Umidita<100){
    Serial.print("0" + String(Umidita));
  }
  else if(Umidita>100){
    Serial.print(Umidita);
  }
  if(PM10<10){
    Serial.print("00" + String(PM10));
  }
  else if(PM10<100){
    Serial.print("0" + String(PM10));
  }
  else if(PM10>100){
    Serial.print(PM10);
  }
}

void setup() {

  /*Taratura della comunicazione seriale a 9600 baud.*/
  Serial.begin(9600);

  delay(3000);

  /*Esecuzione del metodo begin per gli oggetti dht e my_sds per l'inizializzazione della libreria Wire,
  che permette un miglior utilizzo di sensori ed attuatori.*/
  dht.begin();
  my_sds.begin(D1, D2);
}

void loop() {

  /*Lettura di Temperatura ed Umidità dal sensore DHT22,
    e scrittura nelle apposite variabili di Temperatura ed Umidita.*/
  Temperatura = dht.readTemperature();
  Umidita = dht.readHumidity();

    /*Lettura attraverso la funzione read dell'oggetto my_sds,
      con il passaggio delle variabili PM25 e PM10, come parametri per indirizzi,
      in cui verranno scritti i valori delle polveri sottili rilevate.*/
    error = my_sds.read(&PM25,&PM10);

    /*Se la lettura e' priva di errori viene eseguita la procedura Uniformazione,
      che rende i risultati della stessa lunghezza di cifre, così da essere trasmessi al meglio.*/
    if (!error){
      Uniformazione();
    }
  delay(5000);
}
