/*

AGENT

Jobs
	Zeitpl�ne (Einmalzeitpl�ne, Wiederholende)
	Schritten (mehrere Schritte mit Ablaufkontrolle(Erfolg Fehler Ende des Schritts)
	Banachrichtigung (an Operatoren)
	Ausgef�hrt als ..normalerweise das Agentkonto
	  Schritte k�nnen auch als andere Person ausgef�hrt werden ( bei ext Services .. wie Freigaben)
		--> Proxykonto

Operatoren 
	Kontaktliste

	Nachricht bei Erfolg, Fehler, Ende des Jobs
	Idee: exec msdb..sp_send_dbmail

Emailsytem (DatabaseMail)
	SQL = SMTP CLient

*/
exec msdb..sp_send_dbmail