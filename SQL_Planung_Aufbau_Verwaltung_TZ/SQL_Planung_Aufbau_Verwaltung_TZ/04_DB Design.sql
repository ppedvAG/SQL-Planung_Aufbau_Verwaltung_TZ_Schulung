/*

DB Design:
Normalisierung
Stammdaten trennen von Bewegungsdaten

1.NF (atomar)
2.NF (Primärschlüssel)
3.NF keine weiteren Abhängigkeiten ausserhalb des PK

Kundetabelle im CRM System(Kdnr,...., Hobby1, Hobby2, ... Fax1, Fax2, Fax3, Frau1, Frau2, Frau3, Frau4, Religion..)
--> Tabelle hatte 250 Spalten



SQL Server speichert in Seiten und blöcke

Jeder DS wid in Seiten gespeichert

Seite hat: 8192bytes unveränderlich
		   8072 bytes nutzbar für DS
		   max 700 Slots
		   ein DS kann (bei fixen Längen) max 8060bytes haben
		   8 Seiten am Stück nennnt man Block

		   Seiten kommen 1:1 in RAM


		   Was wenn ein DS 4100bytes besitzt
		   1 Mio DS
		   --> 1 MIO Seiten  .. 8 GB
		   --> eigtl 4,1GB Daten
		   1DS belegt 51% der Seite

		   --dennoch 8 GB RAM



*/


create table t1 (id int, sp1 char(4100), sp2 varchar(4100))

Datentypen

Otto
Char(50) ... 'Otto             ' 50 
NCHAR(50) ...'Otto             ' 50*2
VARCHAR(50) 'otto'  4
NVARCHAR(50)     4* 2 = 8

N = UNICODE

select * from customers

--je mehr mehr Seiten desto mehr RAM desto mehr CPU

KOntrolle:

dbcc showcontig('customers')
- Gescannte Seiten.............................: 3
- Mittlere Seitendichte (voll).....................: 96.95%



- Gescannte Seiten.............................: 3983466
- Mittlere Seitendichte (voll).....................: 81.95% --96%