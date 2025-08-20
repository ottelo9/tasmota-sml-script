# Tasmota Scripte zum Auslesen und Anzeigen (Diagramme) von smarten Stromzählern / Sonoff / Gosund-Steckdosen
Tasmota Script with SML and Google Charts for Energy / Grid meter or energy measuring plugs.  
Tasmota Skripte mit SML und Google Charts für smarte Stromzähler / Energiezähler oder smarte Steckdosen.  

Für eine Anleitung, Beschreibung sowie passende Tasmota Images siehe mein Blog:
[https://ottelo.jimdo.de](https://ottelo.jimdofree.com/stromz%C3%A4hler-auslesen-tasmota/)  
Eine kleine Anleitung befindet sich auch im Script selbst.

### Scriptauswahl
Die SML Scripte erstellen eine grafische Anzeige (Liniendiagramm) eures Verbrauchs. Und zwar fein aufgelöst für die letzten 4 Stunden, grob aufgelöst für die letzten 24 Stunden und dann Tages und Monatsverbräuche als Balkendiagramm. Ich habe über die Zeit einige Varianten des Scriptes erstellt, die alle durch unterschiedliche Nutzeranfragen auf meinem Blog entstanden sind.
- `1_SML_Script_Chart`  
  wenn ihr keine PV-Anlage / Balkonkraftwerk BKW habt (ohne Einspeisung)
- `2_SML_Script_Chart_PV`  
  wenn ihr eure Einspeisung sehen möchtet und euer Zähler das unterstützt (2-Richtungszähler)
- `2_SML_Script_Chart_PV_2`  
  wie _PV Script aber mit sehr hoch aufgelöstem 4h-Leistungs-Diagramm (alle 5s ein Wert)
- `2_SML_Script_Chart_PV_Ecotracker`  
  wie _PV Script aber mit Ecotracker Emulation (z.B. für Marstek Akku) - **TESTVERSION!**
  benötigt mein Tasmota Image [V15.0.1](https://github.com/ottelo9/tasmota-sml-images/releases/tag/V15.0.1_250721) oder höher (ESP8266/ESP32)
- `2_SML_Script_Chart_PV_ShellyEmu`  
  wie _PV Script aber mit Shelly Pro 3EM Emulation (für Marstek Akkus Jupiter, Venus, B2500)
  benötigt mein Tasmota Image [V15.0.1](https://github.com/ottelo9/tasmota-sml-images/releases/tag/V15.0.1_250721) oder höher (nur ESP32). Im Script ist eine grobe Beschreibung, wie ihr das alles zum Laufen bekommt.
  Weitere Infos auf meinem [Blog FAQ 17](https://ottelo.jimdofree.com/stromz%C3%A4hler-auslesen-tasmota/#13a) oder im [Forum](www.photovoltaikforum.com/thread/250523-marstek-venus-jupiter-b2500-shelly-pro-3em-emulator-tasmota-lesekopf)!  
  Das Script basiert auf dem ["Basisscript" von gemu2015](https://github.com/gemu2015/Sonoff-Tasmota/blob/universal/tasmota/scripting/shelly_emu_script.tas). Das Basisscript läuft auch auf dem ESP8266!
- `3_SML_Script_Chart_PV_1-Richtungszaehler`  
  wie _PV Script aber für 1-Richtungszähler (Netzeinspeisung in kWh wird berechnet)
- `4_SML_Script_Chart_PV_no_4h24h`  
  wie _PV Script aber ohne 4h und 24h Diagramme
- `5_SonoffPowR2_GosundEP2_NousA1T`  
  wie 1_ Script jedoch für Energiemess-Steckdosen
- `5_SonoffPowR2_GosundEP2_NousA1T_2`  
  sehr hoch aufgelöstes 4h-Leistungs-Diagramm (alle 5s ein Wert)
- `6_SML_Script_Wasseruhr`  
  Wasseruhr Script mit Diagrammen (Impulse)
- `8_Script_DeepSleep`  
  ESP Tasmota Deepsleep Testscript (nur für ESP32)
- `9_Script_SML_Simulator`  
  emuliert ein MT175 Stromzähler, einfach auf einen 2. Lesekopf aufspielen (ESP8266 / ESP32)

### Tasmota Image/Firmware
Die Skripte funktionieren nur, wenn ihr ein speziell angepasstes Tasmota Image (Firmware) verwendet (z.B. mit SML Support). Die Images könnt ihr ebenfalls auf [meiner github Seite](https://github.com/ottelo9/tasmota-sml-images/releases). herunterladen. Wenn ihr sehen möchtet, welche Features ich beim Erstellen der Images verwendet habe oder ihr euer eigenes Image erstellen wollt, dann schaut in die Readme [hier](https://github.com/ottelo9/tasmota-sml-images).

### Hardware
Die Scripte sind so gemacht, dass sie sogar auf einem **ESP8266** laufen (z.B. im Hichi Lesekopf oder in Sonoff / Gosund Steckdosen verbaut). Dafür muss das Script aber dringend über den externen Script Editor "komprimiert" werden. D.h. es werden alle Kommentare und Leerzeichen entfernt. Der Editor überträgt das Script dann auch gleich. Beim **ESP32** muss dies nicht mehr unbedingt gemacht werden. Aber es sollten die Kommentare entfernt werden. Dort wird das Script einfach in den internen Editor kopiert.

### Anleitung
Skript herunterladen und z.B. mit dem Windows Editor öffnen (öffnet mit). Es gibt auch für die Tasmota Skripte einen speziellen Editor vom Tasmota Script Entwickler [gemu2015](https://github.com/gemu2015) den ihr [hier](https://github.com/gemu2015/Sonoff-Tasmota/blob/universal/tasmota/scripting/Scripteditor.zip) herunterladen könnt. Dieser kann die Scripte direkt auf euren ESP übertragen und entfernt dabei alle Kommentare und leere Zeilen um Platz zu sparen! Eine genauere Anleitung findet ihr auf meinem Blog.

Die Skripte müssen von euch auf euren Zähler angepasst werden:  

Sucht die Zeile  
`>M 1`

Dort müsst ihr den SML Descriptor für euren Zähler anpassen. Weitere Details auf meiner Seite!  
Wenn ihr SML Zeilen entfernt oder hinzufügt, dann müsst ihr auch die Variablen im Script anpassen. Wenn die erste SML Zeile im Script z.B. `1,77070100100700ff@1,Leistung,W,Power_curr,0` ist, dann wird im Hintergrund von Tasmota die aktuelle Leistung `Power_curr` des Zählers in die Variable `sml[1]` geschrieben. Die 2te und 3te Zeile (im Script ist das der Verbrauch und die Netzeinspeisung) werden in `sml[2]` und `sml[3]` geschrieben.  

Wichtig noch die korrekte Uhrzeit (Zeitzone, Winter/Sommer) festlegen (via Console),  
ab Script 11.06.2025 wird dies beim Booten automatisch gesetzt!  
`Backlog0 Timezone 99; TimeStd 0,0,10,1,3,60; TimeDst 0,0,3,1,2,120` <- Europe/Berlin  
Den Befehl müsst ihr ggf. auf euren Ort anpassen! https://tasmotatimezone.com  bzw. https://tasmota.github.io/docs/Timezone-Table/  

So sieht das Google Chart Script in Natura aus:  
![screencapture-192-168-178-31-2024-12-28-15_41_15](https://github.com/user-attachments/assets/cc1d8a8f-62c9-4609-839c-d90ff3d4c089)

[Offizielle Tasmota Github Seite](https://github.com/arendst/Tasmota)

------------------
Bedanken möchte ich mich besonders bei [gemu2015](https://github.com/gemu2015), der das Tasmota Scripting und SML entwickelt hat und mir immer sofort bei Problemen geholfen hat. Und natürlich beim restlichen [Tasmota Entwickler-Team](https://tasmota.github.io/docs/About/), für das grandiose Tasmota :).
