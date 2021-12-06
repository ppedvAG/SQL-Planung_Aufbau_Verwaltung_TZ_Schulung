--SNAPSHOT
--Vorlagen Explorer
--SNAPHOT erzeugt automatisch eine Sicherung der Seiten und Bl�cke einer DB vevor sie ge�ndert werden
--diese werden als SnapshotDb zur Verf�gung gestellt.
--Die SnapshotDB ist lesbar  und knn f�r restore verwendent werden

use master


CREATE DATABASE DBSNAPSHOTNAME ON
( NAME = northwind,--OrigDateiname der Origdb
FILENAME = 'D:\_SQLDB\DBSNAPSHOTNAME.mdf' )
AS SNAPSHOT OF OriginalDB;
GO



CREATE DATABASE Northwind_1221 ON
( NAME = northwind,--OrigDateiname der Origdb
 FILENAME = 'D:\_SQLDB\Northwind_1221.mdf' ) --Datei der neuen SnapshotDB
AS SNAPSHOT OF Northwind;
GO


--Kann man mehrere Snapshots machen
--ja


--Kann man die SNapshotDB sichern?
--nein


--Kann man den Snapshto restore?
--neeee


--Kann man die OrigDB backupen?
--logo

--auch restoren?
--n� /solange ein Snashot existiert
--zuerst Snapshot l�schen



--kann man von Snapshot die origDb retoren?


--aber es darf keiner auf dem Snapshot sein und keiner auf der OrigDb
use master
select * from sysprocesses where dbid in (db_id('northwind'),db_id('Northwind_1221')) and spid > 50

--User haben immer �ber 50 (spid)
kill 61
kill 64

--lets go
restore database northwind from database_snapshot = 'Northwind_1221'