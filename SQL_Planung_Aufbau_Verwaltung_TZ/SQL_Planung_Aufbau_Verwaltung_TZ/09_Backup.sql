/*

Vorf�lle


1. DB inkonsistent (funktionsf�hig aber falsche DAten .. durch falsch INS UP DEL)
	--> logischer Fehler
	--> DB ist ok... 

1b: so exakt wie m�glich restoren

2. DB korrupt defekt .. ein Haufen Asche...

3. nur eine Teil der DB ist weg.. zB mdf oder ldf...durch Ausfall einer HDD

4. Server ist weg...

5. Ich weiss, dass gleich was passieren kann...



Ausfalldefinition

A) wie lange darf der Server/DB ausfallen in Zeit?
B) wie gro� darf der Datenverlust in Zeit?



Vokablen f�r Backup/Restore

Wiederherstellungsmodel
.. regelt, was in das TLog weggeschrieben wird und was gel�scht wird


Einfach
..INS UP DEL , auch BULK (rudiment�r)
abgeschl. TX werden automatisch aus dem TLog entfernt, wenn commited 
--> Fazit: keine Sicherung des LogFiles m�glich
		   Cool...!  Weil Restrore per Logfile oft diffizieler


Massenprotokolliert
.. INS, UP, DEL , auch BULK (rudiment�r)
abgeschloss TX werden nicht gel�scht
--> Fazit: Logfile muss gesichert, weil nur die ZLogSicherung die commited TX aus dem Log entfernt

Info!: mit der Logfile Sicherug kann auf Sek restored werden, ausser bei Model Massenprotokolliert
			---> hier geht das nur , wenn kein BULK Befehl stattfand


Vollst�ndig
.. ausf�hrliche Protkollierung

--> Fazit: auf Sek Restore m�glich, braucht daher auch mehr Platz


--Auswahl des Models ist abh�ngig von Restoregenuigkei
-->so exakt wie m�glich restore oder geringst m�glicher Datenverlust: FULL
-->Spiegelung, Availability Groups --> FULL

--TestDBs--> Einfach



Sicherungsarten

Vollst�ndige
V: Dateien + Pfade + Gr��en, aber die Dateien sind im Backup komprimiert
Checkpoint.. ver�nderte Seiten im RAM werden in mdf weggeschrieben (commited TX)


Differenzierende 
Alle Bl�cke, die sich seit dem V ver�ndert haben (INS, UP, DEL)
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
--Pfade, Edition , Version ..mind gleiche Version zB SQL 2016 Sp1 oder h�her
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



-- Fall 1b: so exakt wie m�glich

--prdouktive DB, mit logschen Fehlern (falsche Daten)
--evtl weilw korrupt
--Model Full.. also auf Sek restore m�glich

--so gut wie m�glich ohne Datenverlust

-- letzte T Sicherung 11:00.. n�chste w�re um 11:45  (T)
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