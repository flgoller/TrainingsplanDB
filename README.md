# TrainingsplanDB
DB for Project in M153
## ER Diagramm
<img src="/Relationalesmodell.png" alt="Alt text" title="Optional title">

Diagramm mit Beschreibung der Felder:
https://drawsql.app/trainingsplandb/diagrams/trainingsplan/embed


## Inhalt
### Trigger
Beim erstellen einer Übung wird zuerst geprüft, ob bereits eine Übung mit dieser Bezeichnung existiert.

### Stored Procedure
Erstellen eines Trainingplans, welches direkt das Heutige Datum als ErstellDatum abfüllt.

### Stored Function
Berechnung verwendete Muskelgruppen eines Trainingplans. (string Ausgabe mit Kommatrennung)

### Select SQL
Ausgabe von Traingsplan mit allen Übungen.

## Erstellung der Datenbankstruktur
https://github.com/flgoller/TrainingsplanDB/blob/90be5c867354ec24aafc69b2accfbd730185d074/CreateDatabase.sql
