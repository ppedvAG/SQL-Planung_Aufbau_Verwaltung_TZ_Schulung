/*

Größe der DB: 5 GB
Arbeitszeiten:  Mo bis Fr
			    0600 bis 1800

A) Ausfallzeit der DB/ Server in min: 30min
B) Datenverlust der DB in min: 60min


Ziel ist unter A) restoren --> rel wenige Restorevorgänge V d wenige T


V 19 Uhr
D von 700 bis 1800 stündlich

RecoveryModel: Einfach


Falls aber RecoveryModel nicht einfach sein darf...

B = Intervall für Logfile  60min .. klingt nach lange
	--dennoch 30min Takt


das Logfileintervall steuert das D... alle 2T ein D



PLAN  
V 1900 täglich ausser SA/SO
T ab 0630 alle 30min bis 1800
D 0715 D alle Stunde  bis 1815
Mo bis Fr 








*/