/*
DB Settings


Anfangsgr��e einer DB
seit 2016 8 MB + 8 MB
SQL 2014  5 MB	 2 MB

Wachstmraten: 64MB f�r Log oder Daten

SQL 2014 : 1 MB f�r Daten   10% f�r Logfile

eine DB Datei sollte nie autom. willk�rlich wachsen

--> Anfangsgr��e eher = Lebensddauer der DB
Backup hat kein Interesse die "Luft" mitzusichern ;-)


Anfangsgr��e Logfile: 25-30% der Daten


Wachstumsrate: 1000MB
Logfile 1000MB.. sollte nie wachsen (Kontrolle durch LogBackup)
--> jedes Logfile hat virt Logfiles


evtl andere bzw eig HDDs f�r Daten und Logfile

Settings


DB Design

Kompabilit�tsgrad auf neuesten Level ?

*/


create database testdb