--Security

select * from syslogins


use Northwind
select * from sysusers

--Login _ Zutritt zum SQL Server

--User: zutritt zur DB
--DB merkt sicht Rechte in DB

--Login = User --> Usermapping


--NT User merkt sich SQL Server mit Windows SID: 0x010500000000000515000000D2A36BACB06446B43DEBAB2FED030000

--SQL Logins: erstellt komplett eig SID: 0x71441BE35BCFBD44A1A61D258610F66E

--Eine Eva auf Server 1  ist nicht gleich EVA auf Server 2 wg Namen
--Login klappt aber kein Zugriff zur DB wg SID

3 Benutzer: Admin / Susi  / Udo


--Beim Anlegen von Logins--> Benutzerzuordnung spart 10 Klicks pro DB  ;-)

--Zur verinfachung der Rechte Vergabe .. Ordner .. in SQL Server = schema


--IT MA

--Besitzer immer dbo!!!


USE [Northwind]
GO
CREATE SCHEMA [IT] AUTHORIZATION [dbo]
GO
USE [Northwind]
GO


--neuer Mitarbeiter Peter. Soll auchin IT arbeiten und gleiche Rechte wie Udo haben
CREATE SCHEMA [MA] AUTHORIZATION [dbo]
GO

USE [master]
GO
CREATE LOGIN [UDO] WITH PASSWORD=N'123', 
DEFAULT_DATABASE=[Northwind], 
CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
GO



--jede User kann STD Schema haben

USE [Northwind]
GO
ALTER USER [Susi] WITH DEFAULT_SCHEMA=[MA]
GO


USE [Northwind]
GO
ALTER USER [UDO] WITH DEFAULT_SCHEMA=[IT]
GO



--Admin

create table it.kst(itkst int)

create table it.personal(itperso int)

create table ma.kst(makst int)

create table ma.personal(maperso int)
--Susi soll auf alle MA Tabellen lesen dürfen

use [Northwind]
GO
GRANT SELECT ON SCHEMA::[MA] TO [Susi]
GO


--Susi soll Tabelle it.kst
use [Northwind]
GO
GRANT SELECT ON [IT].[kst] TO [Susi]
GO

--will man Rechte sehen (weil Vererbung nicht angezeigt wird) dann uSer mit reinnehmen und effetkive anzeigen


--Rollen werden wir Benutzer behandelt
USE [Northwind]
GO
CREATE ROLE [ITROLLE] AUTHORIZATION [dbo]
GO
USE [Northwind]
GO
ALTER ROLE [ITROLLE] ADD MEMBER [UDO]
GO

--Udo soll kein direktes rechte besitzen , sondern per Rolle
use [Northwind]
GO
REVOKE SELECT ON SCHEMA::[IT] TO [UDO] AS [dbo]
GO
use [Northwind]
GO
GRANT SELECT ON SCHEMA::[IT] TO [ITROLLE]
GO



--Serverrolle: public = jeder

--sind für Admintätigkeit

--EIn Verweigern ist nicht ultimativ ein verweigern


--UDO

select * from personal

select * from kst

select * from ma.kst

select * from personal

select * from kst


select * from dbo.employees --dbo employees ..kein Recht
--UDO hat deny auf Tabelle bekommen


alter view it.vdemo
as
select * from dbo.employees


select * from it.vdemo--darf lesen
select * from dbo.employees --darf nicht lesen

dbo dbo  dbo  dbo dbo  dbo
v1-->v2-->v3--V4--V5--Tabelle

dbo  evi  susi  peter
v1-->v2-->v3--V4--V5--Tabelle


--vergib nie einer normalen sterblichen Person eine CREATE Recht.. 
--bei Besitzverkettung  ist es möglich Sichten, Prozeduren, F() anzulegene die andere Daten abrufen, obwohl ein Deny vorliegt

