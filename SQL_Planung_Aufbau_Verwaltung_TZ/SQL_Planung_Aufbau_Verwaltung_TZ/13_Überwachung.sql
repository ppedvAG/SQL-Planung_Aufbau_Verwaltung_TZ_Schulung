--Überwachung

/*
Audit

a) Logfile zum protkollieren
b) Serverüberwachung und DB ÜBerwachung
	Login					SELECT
	Backup					Backup

---> Logfile

c) filterbar: 
ich möchte sehen, ob Udo auf die Tab Employees SELECT gemacht hat

*/

SELECT * FROM sys.fn_get_audit_file
('d:\_backup\SecurityAudit_9F076377-3314-49F1-A2F7-BE1A9FC50BBE_0_132834320638410000.sqlaudit',default,default)
where database_principal_name = 'UDO'
GO  
