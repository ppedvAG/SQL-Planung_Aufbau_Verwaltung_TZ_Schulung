/*

AGENT

Jobs
	Zeitpläne (Einmalzeitpläne, Wiederholende)
	Schritten (mehrere Schritte mit Ablaufkontrolle(Erfolg Fehler Ende des Schritts)
	Banachrichtigung (an Operatoren)
	Ausgeführt als ..normalerweise das Agentkonto
	  Schritte können auch als andere Person ausgeführt werden ( bei ext Services .. wie Freigaben)
		--> Proxykonto

Operatoren 
	Kontaktliste

	Nachricht bei Erfolg, Fehler, Ende des Jobs
	Idee: exec msdb..sp_send_dbmail

Emailsytem (DatabaseMail)
	SQL = SMTP CLient

*/
exec msdb..sp_send_dbmail