/*

Indizes

Sortieren ..ja..

Performance: können unglaublich beschleuningen aber langsamer machen


SELECT  +
INS UP DEL  -


3 Sorten von Indizes

Gr IX CLustered Index = Tabelle
legt die kompletten Datenstätze sortiert ab
kann es pro Tabelle nur einmal geben

gut bei eindeutigen Treffer
aber auch gut bei Abfragen auf Bereiche mit rel großer Ergebnismenge


N Gr Index  Non Clustered
kopiert!! Spalten aus den Tabellen in eig Seiten
und produziert einen Baum... Suche beginnt mit Wurzelknoten
--Telfonbuch. am Ende des Baumes ist die Telnummer
-- Anzahl der Telbücher ungrenzt.. theor... ..praktisch ca 1000 pro Tabelle

gut bei eindeutigen Ergebisse
bei rel geringer Eregbnismenge


--TIPP:. lege pro Tabelle zuerst den CL IX fest!!!!!
--		nicht zuviele Indizes
--		überflüssige Indizes
--		fehlende Indizes
--		Auswertung 1000er Abfragen
--      überleg dir den PK ganz genau
--         wird über die GUI immer als CL IX angelegt
--         PK will aber eiglt nur eine Eindeutigkeit
--der PK  kann auch non clustered sein





*/

set statistics io, time on 

--TABLE SCAN --  IX SCAN -- CL IX SCAN
-->IX SEEK  CL IX SEEK

---HEAP
select id from ku where id = 100 -- Plan: T SCAN
--56000  CPU-Zeit = 158 ms, verstrichene Zeit = 77 ms.

--CL IX wird auf Orderdate festgelegt
--also der Rest nur noch non clustered

--NIX_ID
select id from ku where id = 100 --PLAN:  IX SEEK
--Seiten 3   0 ms


select id, freight from ku where id = 100 --IX SEEK + Anruf(Lookup)

--wg Lookup 4 Seiten 3 für finden und 1 fürs nachschauen


select id, freight from ku where id < 100

--Lookup wird mit mehr DS immer teuerer..

select id, freight from ku where id < 10500 --ab ca 10500 Table Scan
--knapp 1 % der Menge


--besser wirds, wenn man nicht anrufen muss
--NIX_ID_FR_-  37 Seiten 
--weniger CPU und Dauer


--> zusammengestzter IX.. mehr Spalten: max 16 Spalten
---diue Werte addiert < 900byte

--der hilft eigtl nur dann sehr gut wenn die gesuchten Werte im 
--where alle vorkommen

select country, city, sum(unitprice*quantity)
from ku
where employeeid = 1 and freight < 1
group by country, city


--ohne IX: 56000 300ms CPU  mit IX 0 sek CPU 200 Seiten











*/


--Spieltabelle

SELECT        Customers.CustomerID, Customers.CompanyName, Customers.ContactName, Customers.ContactTitle, Customers.City, Customers.Country, Orders.EmployeeID, Orders.OrderDate, Orders.Freight, Orders.ShipCity, 
                         Orders.ShipCountry, Employees.LastName, Employees.FirstName, Employees.BirthDate, [Order Details].OrderID, [Order Details].ProductID, [Order Details].UnitPrice, [Order Details].Quantity, Products.ProductName, 
                         Products.UnitsInStock
into ku
FROM            Customers INNER JOIN
                         Orders ON Customers.CustomerID = Orders.CustomerID INNER JOIN
                         Employees ON Orders.EmployeeID = Employees.EmployeeID INNER JOIN
                         [Order Details] ON Orders.OrderID = [Order Details].OrderID INNER JOIN
                         Products ON [Order Details].ProductID = Products.ProductID


insert into ku
select * from ku

--bis 1,1 Mio DS
alter table ku add id int identity

--eind ID
--SCAN oder SEEK.. ohne where ein SCAN.. T SCAN oder CL IX SCAN
select * from best