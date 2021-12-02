/*
DB Settings


Anfangsgröße einer DB
seit 2016 8 MB + 8 MB
SQL 2014  5 MB	 2 MB

Wachstmraten: 64MB für Log oder Daten

SQL 2014 : 1 MB für Daten   10% für Logfile

eine DB Datei sollte nie autom. willkürlich wachsen

--> Anfangsgröße eher = Lebensddauer der DB
Backup hat kein Interesse die "Luft" mitzusichern ;-)


Anfangsgröße Logfile: 25-30% der Daten


Wachstumsrate: 1000MB
Logfile 1000MB.. sollte nie wachsen (Kontrolle durch LogBackup)
--> jedes Logfile hat virt Logfiles


evtl andere bzw eig HDDs für Daten und Logfile

Settings


DB Design

Kompabilitätsgrad auf neuesten Level ?

*/


create database testdb