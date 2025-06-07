# Tasmota Scripte zum Auslesen und Anzeigen (Diagramme) von smarten Stromzählern / Sonoff / Gosund-Steckdosen
Tasmota Script with SML and Google Charts for Energy / Grid meter or energy measuring plugs.  
Tasmota Skripte mit SML und Google Charts für smarte Stromzähler / Energiezähler oder smarte Steckdosen.  

Für eine Anleitung, Beschreibung sowie passende Tasmota Images siehe mein Blog:
[https://ottelo.jimdo.de](https://ottelo.jimdofree.com/stromz%C3%A4hler-auslesen-tasmota/)

### Tasmota Image/Firmware
Die Skripte funktionieren nur, wenn ihr ein speziell angepasstes Tasmota Image (Firmware) verwendet (z.B. mit SML Support). Die Images könnt ihr auf meiner Seite herunterladen. Wenn ihr sehen möchtet, welche Features ich beim Erstellen der Images verwendet habe oder ihr euer eigenes Image erstellen wollt, dann schaut [hier](https://github.com/ottelo9/tasmota-sml-images) vorbei.

### Hardware
Die Scripte sind so gemacht, dass sie sogar auf einem **ESP8266** laufen (z.B. im Hichi Lesekopf oder in Sonoff / Gosund Steckdosen verbaut). Dafür muss das Script aber dringend über den externen Script Editor "komprimiert" werden. D.h. es werden alle Kommentare und Leerzeichen entfernt. Der Editor überträgt das Script dann auch gleich. Beim **ESP32** muss dies nicht mehr unbedingt gemacht werden. Aber es sollten die Kommentare entfernt werden. Dort wird das Script einfach in den internen Editor kopiert.

### Anleitung
Skript herunterladen und z.B. mit dem Windows Editor öffnen (öffnet mit). Es gibt auch für die Tasmota Skripte einen speziellen Editor vom Tasmota Script Entwickler [gemu2015](https://github.com/gemu2015) den ihr [hier](https://github.com/gemu2015/Sonoff-Tasmota/blob/universal/tasmota/scripting/Scripteditor.zip) herunterladen könnt. Dieser kann die Scripte direkt auf euren ESP übertragen und entfernt dabei alle Kommentare und leere Zeilen um Platz zu sparen! Eine genauere Anleitung findet ihr auf meinem Blog.

Die Skripte müssen von euch auf euren Zähler angepasst werden:  

Sucht die Zeile  
`>M 1`

Dort müsst ihr den SML Descriptor für euren Zähler anpassen. Weitere Details auf meiner Seite!  
Wenn ihr SML Zeilen entfernt oder hinzufügt, dann müsst ihr auch die Variablen im Script anpassen. Wenn die erste SML Zeile im Script z.B. `1,77070100100700ff@1,Leistung,W,Power_curr,0` ist, dann wird im Hintergrund von Tasmota die aktuelle Leistung `Power_curr` des Zählers in die Variable `sml[1]` geschrieben. Die 2te und 3te Zeile (im Script ist das der Verbrauch und die Netzeinspeisung) werden in `sml[2]` und `sml[3]` geschrieben.  

Wichtig noch die korrekte Uhrzeit (Zeitzone, Winter/Sommer) festlegen (via Console):  
`Backlog0 Timezone 99; TimeStd 0,0,10,1,3,60; TimeDst 0,0,3,1,2,120`  
oder lasst euch den Befehl generieren: https://tasmotatimezone.com

So sieht das Google Chart Script in Natura aus:  
![screencapture-192-168-178-31-2024-12-28-15_41_15](https://github.com/user-attachments/assets/cc1d8a8f-62c9-4609-839c-d90ff3d4c089)

[Offizielle Tasmota Github Seite](https://github.com/arendst/Tasmota)

------------------
Bedanken möchte ich mich besonders bei [gemu2015](https://github.com/gemu2015), der das Tasmota Scripting und SML entwickelt hat und mir immer sofort bei Problemen geholfen hat. Und natürlich beim restlichen [Tasmota Entwickler-Team](https://tasmota.github.io/docs/About/), für das grandiose Tasmota :).
