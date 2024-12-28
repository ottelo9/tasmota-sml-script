# tasmota-sml-script
Tasmota Script with SML and Google Charts for Energy/Grid meter 

Tasmota Skripte mit SML und Google Charts für smarte Stromzähler (oder Energiezähler/smarte Steckdosen)

Für eine Anleitung, Beschreibung sowie passende Tasmota Images siehe mein Blog:
[https://ottelo.jimdo.de](https://ottelo.jimdofree.com/stromz%C3%A4hler-auslesen-tasmota/) (German)

Die Skripte funktionieren nur, wenn ihr ein speziell angepasstes Tasmota Image (Firmware) verwendet (z.B. mit SML Support). Die Images könnt ihr auf meiner Seite herunterladen. Welche Features ich beim Erstellen der Images verwendet habe findet ihr in der Datei "Tasmota Image selbst erstellen - Tasmota defines.txt" oder auf meinem Blog.

Fast HowTo:
Die Skripte müssen von euch auf euren Zähler angepasst werden:

Sucht die Zeile
>M 1

Dort müsst ihr den SML Descriptor für euren Zähler anpassen. Weitere Details auf meiner Seite!
Wenn ihr SML Zeilen entfernt oder hinzufügt, dann müsst ihr auch die Variablen im Script anpassen. Wenn die erste SML Zeile im Script z.B. "1,77070100100700ff@1,Leistung,W,Power_curr,0" ist, dann wird im Hintergrund von Tasmota die aktuelle Leistung "Power_curr" des Zählers in die Variable sml[1] geschrieben. Die 2te und 3te Zeile (im Script ist das der Verbrauch und die Netzeinspeisung) werden in sml[2] und sml[3] geschrieben.

So sieht das Google Chart Script in Natura aus.
![screencapture-192-168-178-31-2024-12-28-15_41_15](https://github.com/user-attachments/assets/f6b1e032-bbc3-4400-b440-39711195c780)
