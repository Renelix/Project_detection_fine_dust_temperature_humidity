%{
Antonio Caiafa

Codice sorgente per la ricezione seriale dei dati trasmessi dalla scheda ESP8266,
per la creazione di grafici riferiti ad ogni dato prelevato dalle schede, nello specifico: Temperatura, Umidità, PM 2.5 e PM 10,
per la scrittura su apposito file delle 25 letture effettuate, di cui una ogni 5 secondi,
per l'individuazione delle funzioni che rappresentano i dati ottenuti nel tempo e scrittura di tali funzioni su file.
%}

% Creazione dell'oggetto Porta di tipo serial con parametro COM3.
Porta = serial('COM3');

% Inizializzazione variabili che serviranno per l'iterazione del ciclo che in questo caso e' un costrutto while con condizione in testa.
time = 25;
i = 0;

% Creazione del file Rilevazione_dati di tipo txt e scrittura dei primi dati sulle principali 5 colonne che verranno utilizzate.
idfile = fopen('Rilevazione_dati.txt', 'w');
fprintf(idfile,'%1s %11s %7s %7s %7s\n\n', 't', 'Temperatura', 'Umidità', 'PM 2.5', 'PM 10');

% Costrutto iterativo while che si occupa della ricezione dei dati, scrittura dati su file e creazione dei grafici.
while(i<time)
    
    % Incremento variabile contatore.
    i = i + 1;
    
    % Apertura porta COM3 per la ricezione dei dati per via seriale.
    fopen(Porta);
    
    % Inserimento nella variabile out della stringa ottenuta dalla rilevazione e trasmissine tramite la porta seriale.
    out = fscanf(Porta);
    
    % Funzione che permette di decidere il layout dei grafici all'interno della scheda che apparirà, ovvero quante righe e quante colonne di grafici appariranno.
    tiledlayout(2,2);
    
    %{
    Schema di creazione grafico:
        Creazione di un nuovo spazio per la rappresentazione grafica di valori.
        Assegnazione al vettore in questione nello spazio di posizione i, dei valori prelevati dall'output da una certa posizione ad una certa posizione, facendo il casting al tipo string, al fine di risparmiare tempo e spazio nella trasmissione, i valori vengono trasmessi insieme e solo dopo vanno separati con opportuni accorgimenti.
        Creazione grafico in cui vengono inseriti tutti i valori del vettore in questione e viene segnalato di che colore, dimensione e forma dovrà essere la linea che li congiungerà.
        Stampa dell'ultimo valore inserito, in una certa posizione del grafico in modo che non dia fastidio al grafico stesso.
        Dichiarazione per la visualizzazione standard del grafico con un certo dominio e codominio.
        Dichiarazione Titolo grafico per ulteriori indicazioni su sensori utilizzati e misure prelevate.
        Scrittura sulla barra verticale sinistra per ulteriori indicazioni sul dato letto che e' stato stampato graficamente.
        Scrittura sulla barra orizzontale in basso per ulteriori indicazioni sul tempo trascorso tra una misurazione e quella successiva.
        Funzione che permette di visualizzare le linee principali della griglia all'interno del grafico.
    %}

    nexttile
    Temp(i)=str2num(out(1:6));
    plot(Temp, '-or');
    text(21, 47, string(Temp(i))+'°C', 'Color', 'r');
    axis([0, time, 0, 50]);
    title('Parametri - Sensore DHT22');
    ylabel('Temperatura °C');
    grid
    
    nexttile
    Pm25(i)=str2num(out(7:12));
    plot(Pm25, '-xm');
    text(21, 95, string(Pm25(i))+'μg/m^3', 'Color', 'm');
    axis([0, time, 0, 100]);
    title('Parametri - Sensore SDS011');
    ylabel('PM 2.5');
    grid

    nexttile
    Humi(i)=str2num(out(13:18));
    plot(Humi, '-^b');
    text(21, 95, string(Humi(i))+'%', 'Color', 'b');
    axis([0, time, 0, 100]);
    ylabel('% Umidità');
    xlabel('Intervallo di misurazione 5 secondi');
    grid
    
    nexttile
    Pm10(i)=str2num(out(19:24));
    plot(Pm10, '-pk');
    text(21, 95, string(Pm10(i))+'μg/m^3', 'Color', 'k');
    axis([0, time, 0, 100]);
    ylabel('PM 10');
    xlabel('Intervallo di misurazione 5 secondi');
    grid

    % Controllo attraverso costrutto if della lunghezza dell'indice, in modo che possa essere correttamente stampato all'interno del file, modificando lo spazio riservato ad una variabile.
    if(i<10)
        fprintf(idfile,'%1s %8s %9s %7s %7s\n', string(i), string(Temp(i)), string(Humi(i)), string(Pm25(i)), string(Pm10(i)));
    else
        fprintf(idfile,'%1s %7s %9s %7s %7s\n', string(i), string(Temp(i)), string(Humi(i)), string(Pm25(i)), string(Pm10(i)));
    end
    
    % Chiusura porta COM3 di comunicazione.
    fclose(Porta);

    % Funzione per aiutare matlab ad aggiornare i grafici senza errori nel tempo.
    drawnow;

% Fine ciclo iterativo while che si occupa della ricezione dei dati, scrittura dati su file e creazione dei grafici.
end

% Creazione del vettore x con valori nelle corrispondenti celle da 1 a 25.
x = 1:25;

%{
Individuazione funzione e scrittura su file:
    Attraverso l'ausilio della funzione polyfit si ricerca il polinomio di terzo grado che identifica l'andamento del valore in questione.
    Stampa della funzione in modo testuale all'interno del file.
%}

funTemp = polyfit(x,Temp,3);
fprintf(idfile,"\n%50s", "Funzione della temperatura nel tempo  y = " + string(funTemp(1)) + "*x^3 + " + string(funTemp(2))+ "*x^2 + " + string(funTemp(3)) + "*x + " + string(funTemp(4)));

funHumi = polyfit(x,Humi,3);
fprintf(idfile,"\n%50s", "Funzione dell'Umidità nel tempo  y = " + string(funHumi(1)) + "*x^3 + " + string(funHumi(2))+ "*x^2 + " + string(funHumi(3)) + "*x + " + string(funHumi(4)));

funPm25 = polyfit(x,Pm25,3);
fprintf(idfile,"\n%50s", "Funzione del PM 2.5 nel tempo  y = " + string(funPm25(1)) + "*x^3 + " + string(funPm25(2))+ "*x^2 + " + string(funPm25(3)) + "*x + " + string(funPm25(4)));

funPm10 = polyfit(x,Pm10,3);
fprintf(idfile,"\n%50s", "Funzione del PM 10 nel tempo  y = " + string(funPm10(1)) + "*x^3 + " + string(funPm10(2))+ "*x^2 + " + string(funPm10(3)) + "*x + " + string(funPm10(4)));

% Chiusura del file tramite il suo id.
fclose(idfile);

% Cancellazione della porta COM3.
delete(Porta);

% Inserimento nella variabile a di tutti gli oggetti porta seriale validi come array.
a = instrfind();

% Chiusura di a, ovvero di tutti gli oggetti porta seriale validi come array.
fclose(a);

% Cancellazione di tutte le variabili ed array utilizzati nel programma.
clear