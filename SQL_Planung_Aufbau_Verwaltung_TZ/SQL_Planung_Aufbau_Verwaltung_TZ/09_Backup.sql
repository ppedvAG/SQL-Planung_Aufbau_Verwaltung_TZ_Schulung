/*

Vorfälle


1. DB inkonsistent (funktionsfähig aber falsche DAten .. durch falsch INS UP DEL)
	--> logischer Fehler
	--> DB ist ok... 

1b: so exakt wie möglich restoren

2. DB korrupt defekt .. ein Haufen Asche...

3. nur eine Teil der DB ist weg.. zB mdf oder ldf...durch Ausfall einer HDD

4. Server ist weg...

5. Ich weiss, dass gleich was passieren kann...



Ausfalldefinition

A) wie lange darf der Server/DB ausfallen in Zeit?
B) wie groß darf der Datenverlust in Zeit?



Vokablen für Backup/Restore

Wiederherstellungsmodel
.. regelt, was in das TLog weggeschrieben wird und was gelöscht wird


Einfach
..INS UP DEL , auch BULK (rudimentär)
abgeschl. TX werden automatisch aus dem TLog entfernt, wenn commited 
--> Fazit: keine Sicherung des LogFiles möglich
		   Cool...!  Weil Restrore per Logfile oft diffizieler


Massenprotokolliert
.. INS, UP, DEL , auch BULK (rudimentär)
abgeschloss TX werden nicht gelöscht
--> Fazit: Logfile muss gesichert, weil nur die ZLogSicherung die commited TX aus dem Log entfernt

Info!: mit der Logfile Sicherug kann auf Sek restored werden, ausser bei Model Massenprotokolliert
			---> hier geht das nur , wenn kein BULK Befehl stattfand


Vollständig
.. ausführliche Protkollierung

--> Fazit: auf Sek Restore möglich, braucht daher auch mehr Platz


--Auswahl des Models ist abhängig von Restoregenuigkei
-->so exakt wie möglich restore oder geringst möglicher Datenverlust: FULL
-->Spiegelung, Availability Groups --> FULL

--TestDBs--> Einfach



Sicherungsarten

Vollständige
V: Dateien + Pfade + Größen, aber die Dateien sind im Backup komprimiert
Checkpoint.. veränderte Seiten im RAM werden in mdf weggeschrieben (commited TX)


Differenzierende 
Alle Blöcke, die sich seit dem V verändert haben (INS, UP, DEL)
Checkpoint


TLogSicherung
..bin eine "Makro".. merkt sich Anweisungen...I U D
..sind immer aufeinander aufbauend




Geschwindigkeit beim Restore
Was ist der schnellste Restore, den man haben kann?
V


Wie lange dauert der Restore einer T Sicherung?
so lange die Aktionen dauerten, die im Log stecken


Logfilessicherung

*/

--VOLL
BACKUP DATABASE [Northwind] TO  DISK = N'D:\_BACKUP\nwindx.bak' 
WITH NOFORMAT, NOINIT,  NAME = N'Northwind-FULL ', 
SKIP, NOREWIND, NOUNLOAD,  STATS = 10
GO


--DIFF
BACKUP DATABASE [Northwind] TO  DISK = N'D:\_BACKUP\nwindx.bak' 
WITH  DIFFERENTIAL , NOFORMAT, NOINIT,  NAME = N'Northwind-DIFF', 
SKIP, NOREWIND, NOUNLOAD,  STATS = 10
GO

--TLOG
BACKUP LOG [Northwind] TO  DISK = N'D:\_BACKUP\nwindx.bak' 
WITH NOFORMAT, NOINIT,  NAME = N'Northwind-TLOG', 
SKIP, NOREWIND, NOUNLOAD,  STATS = 10
GO



--V	TTT D TTT D TTT D TTT
--V                 D TTT



--Fall 1 : Restore bei logischen Fehlern

--Restore unter anderen Namen
--evtl per TSQL die Orig Daten updaten aus der Restore DBs
-----Pfade bzw Dateinamen anpassen wg akt OriginalDB
-----Fragementsicherung deaktiveren



--10:33
select * into messx from sysmessages



--Fall 2:
--auf anderen Server restoren
--V D T
--Pfade, Edition , Version ..mind gleiche Version zB SQL 2016 Sp1 oder höher
--Error select @@microsoftversion

--am besten Backupdatei auf Server Backup Verzeichnis kopieren
--von dort restore.. Pfade anpassen


-- Fall 3: ein Teil der DB fehlt

--DB trennen 
ALTER DATABASE [Northwind] SET  SINGLE_USER WITH ROLLBACK IMMEDIATE
GO
USE [master]
GO
EXEC master.dbo.sp_detach_db @dbname = N'Northwind'
GO


-- entweder mdf
--haha der ist lustig.. die db ist defekt weg.. hoffentlich Backup vorhanden


--oder ldf
--kein Problem , bekommen ein neues.. aber Datenverlust wg nicht vorhandenen Checkpoint 



-- Fall 1b: so exakt wie möglich

--prdouktive DB, mit logschen Fehlern (falsche Daten)
--evtl weilw korrupt
--Model Full.. also auf Sek restore möglich

--so gut wie möglich ohne Datenverlust

-- letzte T Sicherung 11:00.. nächste wäre um 11:45  (T)
--jetzt 11:32


/*

a) Restore von 11 Uhr, dann Datenverlust: 32 min

b) warten bis 11:45, dann restore auf 11:31. Datenverlust: alles ab 11:31 (14min)


c) manuell Tlog Sicherung um 11:33, dann rstore von 11:31: Datenverlust: 2 min

d) Backup ist online, dh ein Backup Logf von 11:33 sichert keine TSQL Anweisung seit Beginn der Sicherung
--Ergo: alle User runter!! hopp hopp..
--     dann Backup TLOG
--     dann restore auf 11:31

--DVerlust = 0. da Daten entweder in der DB sind oder im Backup


--Lustiger Funfact.. du musst dazu nix tun..!
*/


USE [master]
ALTER DATABASE [Northwind] SET SINGLE_USER WITH ROLLBACK IMMEDIATE--alle Leute runter von DB
BACKUP LOG [Northwind] TO  DISK = N'D:\_BACKUP\Northwind_LogBackup_2021-12-06_11-39-54.bak' WITH NOFORMAT, NOINIT,  NAME = N'Northwind_LogBackup_2021-12-06_11-39-54', NOSKIP, NOREWIND, NOUNLOAD,  NORECOVERY ,  STATS = 5
RESTORE DATABASE [Northwind] FROM  DISK = N'D:\_BACKUP\nwindx.bak' WITH  FILE = 1,  NORECOVERY,  NOUNLOAD,  REPLACE,  STATS = 5
RESTORE DATABASE [Northwind] FROM  DISK = N'D:\_BACKUP\nwindx.bak' WITH  FILE = 13,  NORECOVERY,  NOUNLOAD,  STATS = 5
RESTORE LOG [Northwind] FROM  DISK = N'D:\_BACKUP\nwindx.bak' WITH  FILE = 14,  NORECOVERY,  NOUNLOAD,  STATS = 5
RESTORE LOG [Northwind] FROM  DISK = N'D:\_BACKUP\nwindx.bak' WITH  FILE = 15,  NORECOVERY,  NOUNLOAD,  STATS = 5
RESTORE LOG [Northwind] FROM  DISK = N'D:\_BACKUP\nwindx.bak' WITH  FILE = 16,  NORECOVERY,  NOUNLOAD,  STATS = 5
RESTORE LOG [Northwind] FROM  DISK = N'D:\_BACKUP\Northwind_LogBackup_2021-12-06_11-39-54.bak' WITH  NOUNLOAD,  STATS = 5,  STOPAT = N'2021-12-06T10:32:00'
ALTER DATABASE [Northwind] SET MULTI_USER
GO

/*

DB auf anderen Server restore, der eine geleichnamige DB besitzt
daher unter anderen Namen restoren  zB nwind2



--danach ist seltssamerweise die Northwind restoren


restore database northwind 



--- Fall 5 Backup, wenn man weiss, dass was passieren kann












*/