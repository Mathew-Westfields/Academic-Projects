- Funktionen der verschiedenen Notebooks:
    - Init.ipynb:
        Das Init-Notebook ist da um die entsprechenden Dependencies und Pakete zu installieren, falls diese noch nicht vorhanden sind.
        Im Allgemeinen empfehle ich jedoch trotzdem die Pakete einzeln mit pip zu installieren, da dies oft schneller geht als über die
        Inline Magic zu arbeiten.
        In den hier übergebenen Directories ist auch schon die Initialisierung vorgenommen. Ich habe den Code trotzdem beigefügt damit man
        nachvoll ziehen kann was passiert.
        Das Init-Notebook führt nämlich insbesondere das Data_Pipeline Notebook aus.
        
        - Data_Pipeline.ipynb:
            Das Data_Pipeline-Notebook nutzt die REST-API von Alphavantage um Preisdaten für eine ausgewählte Selektion von Aktien 
            zu requesten und als ein Dictonary object abzuspeichern. Welche Aktien dabei ausgewählt werden wird über die sog. symbol_list in
            eben diesem Notebook spezifiziert.
            Es liegen aber schon gepicklete Preisdaten vor, es ist also nicht notwendig dieses Notebook auszuführen!
           
    - Main.ipynb:
        In diesem Notebook spielt sich der Hauptteil des Programmes ab.
        Hier zentralisiere ich Plotting, Dataframe-Konstruktions und Portfolio-Evaluations Methoden.
        
        - DataFrame_Construction.ipynb:
            - Dataframe Konstruktion:
              Das Konstruieren von relevanten Dataframes bricht auf hier darauf herunter die "adjusted close" columns der einzelnen 
              Preis-Dataframes für die Aktien in ein großes Dataframe zusammen zu fügen damit man sie vergleichen kann.
              Für viele unsere Anwendungen sind da vor allem aber die Prozentualen Änderungen in den Preisen (auch "Returns" genannt)
              interessant
            
            - Diversifikation:
              Die Funktion "get_diversification_candidates" ist dazu da um Aktien zu liefern dessen Korrellation in einem 
              (-epsilon,epsilon)-Intervall um Null liegen.
               Während "get_neg_corr" die Aktien mit negativer Korrellation im Return liefert (dies ist wichtig wenn man Hedging Strategien/ 
               Pairs Trading betreiben will)
              
            - Plotting:
              Ziemlich selbst erklärend, eine Heatmap Visualisierung für Korrelations Matrizen, eine Visualisierung von den Dichtefunktionen
              der Returns von ausgewählten Aktien und ein candlestick chart für die Preise einer Aktie.
              (Problem bei dem Candlestick Chart ist ,dass er nicht Stocksplits korregiert wie man im Notebook am Beispiel 
              von Apple gut sieht)
              
              
        - Portfolio_Methods.ipynb:
            - Das Portfolio Dataframe und die Summary-funktion:
              Die Funktion "get_portfolio_df" generiert ein Dataframe das den Preis der einzelnen Assets und den gesamt Portfoliowert über
              die Zeitspanne für die Preisdaten verfügbar sind.
              Während die Summary Funktion dieses Dataframe auswertet und eine Statistische Zusammenfassung erstellt von wichtigen 
              Kennzahlen um die entsprechende Zusammenstellung von Assets zu bewerten.
                
            - Portfolio Queries:
              Die Funktion "load_query_df" lädt das "query_df" dies ist ein Dataframe in dem jede Zeile zu einem möglichen Portfolio
              korrespondiert, dieses Dataframe auszurechnen ist sehr kostspielig und dauert ziemlich lange.
              Um diese Pickle zu erzeugen gibt eine Funktion "pickle_query_df" dessen funtion call aber im regulären Ablauf des Notebooks
              auskommentiert ist.
              Sobald wir dieses Dataframe jedoch haben, können wir, mit der pandas-nativen querysyntax, dieses Dataframe aller möglichen
              Portfolios nach uns gewollten Attributen query'n.
              Zwei Funktionen die dabei besonders geeignet sind, "get_potential_portfolios" und  "get_low_risk_portfolios".
              Die erste Funktion nimmt zwei Quantile entgegen so ,dass man zum Beispiel alle Portfolios ausgegeben bekommt. 
              Welches in den Risiko-Kennzahlen im 10%-Quantil sind aber in den Profit-Kennzahlen im 25% Quantil sind.
              Die zweite Funktion funktioniert ähnlich nur ,dass diese auch noch versucht den Maximalen Drawdown zu mindern.
              
             
            
        