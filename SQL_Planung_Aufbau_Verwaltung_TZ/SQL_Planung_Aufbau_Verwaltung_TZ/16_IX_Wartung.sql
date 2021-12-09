/*
Man muss regelm. nach 
fehlende Indizes
überflüssige Indizes
suchen und beseitigen

Aber wie findet man die? UNd was sind Indizes genau?

Es existiert folgendes

index_id  0 = HEAP .. eine Tabelle ohne CL Index
index_id  1 = CL IX  .. gruppierter IX
index_id >1 = N CL IX .. nicht gr Index


--passende IX Strategie auf der Basis eines repr. Workload
--Tool-->DTA DB Optimierungsrategeber.. dieser braucht allerdings einen typischen Workload um eine
geeignete IX Strategie vorschlagen zu können.  --> Profiler/QueryStore


Wartung: Rebuild und Reorg
je nach Fragemntierung der Indizes, die durch INS UP DEL steigt, sollten man IX warten:


bis 10% nix
über 30 Rebuild
10 - 30% Reorg


Wie?
--Wartungsplan (Rebuild, Reorg, Stats aktualisieren

*/


--Tool2 : Wartung

--DMVs

select * from sys.dm_db_index_usage_stats