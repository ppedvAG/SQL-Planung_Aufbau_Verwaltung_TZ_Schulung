--Monitoring

--Live Infos

--dauert alles irgendwie länger..

/*
Was geht .. auf Server--> Taskmanager
+ Ressourcemonitor

==> wo geht die Leistung hin
--Antivirentool, Trojanerquark, andere Tools, Software


--aber die beiden sagen : SQL Server
--auch wennn gar nix zu sehen , wo die Leistung hingeht, dann evtl doch SQL Server..


--> Taskmanager für SQL Server: Aktivitätsmonitor


select 

select * from sysprocesses  where spid <= 50.. alles andere = User

--Systemsichten



DMV  DataManagement Views

Systemsichten.. die nach dem Neustart des SQL Server geleert

--daher Systemsichten evtl wegischern.. bzw best Abfragen


Tools zum Aufzeichen , falls das Problem vorbei ist.. SQL Text und Messwerte


--QueryStore Abfragespeicher: sammlet Abfragen der DB plus rel viele Messungen
			--> aber nicht wer


--Perfom (NT): Messwerte einer SQLINstanz und Windows Messwerte
---------> Grafische Auswertung.. sehr leicht um Problem zu erkennen

--Profiler: Tool um Abfragen aufzuzeichen

Hallo






*/


select * from sys.dm_os...    --SQL Server
select * from sys.dm_db... --rund um Datenbanken

select * from sys.dm_db_index_usage_stats

use msdb

select * from dbo.sys.... 



*/

select * from sys.dm_os_wait_stats


select * from sys.dm_os_performance_counters

--Query--Postkasten(Fifo)--> Worker(Analyse)-- Ressourcen!!

---(LCK_M_S)|.................|..........|RUNNING
--          0                 50ms CPU   20ms

--wait_time_ms: Gesamte Dauer: 70ms
--              Signal_time_ms: Anteil der CPU: 70-20=50

--leider sind die Werte kummilierend seit Neustart :-(
--wenn der Anteil der signaltime > 25% sein sollte, dann CPU Engpass

select * from sys.dm_os_wait_stats order by 3 desc