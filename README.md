# Tasmota Scripte zum Auslesen und Anzeigen (Diagramme) von smarten Stromzählern / Sonoff / Gosund-Steckdosen
Tasmota Script with SML and Google Charts for Energy / Grid meter or energy measuring plugs.  
Tasmota Skripte mit SML und Google Charts für smarte Stromzähler / Energiezähler oder smarte Steckdosen.  

Für eine Anleitung, Beschreibung sowie passende Tasmota Images siehe mein Blog:
[https://ottelo.jimdo.de](https://ottelo.jimdofree.com/stromz%C3%A4hler-auslesen-tasmota/)  
Eine kleine Anleitung befindet sich auch im Script selbst.

### Scriptauswahl
Scripte für den ESP8266 findet ihr nun in einem extra Ordner, da ich diese nicht mehr weiterentwickeln werde. Alle anderen Scripte aktualisiere ich nun (ab 01.12.2025) nur noch für den ESP32, der einfach mehr Power hat und Tasmota mehr Features dafür bietet.  
  
Die Scripte erstellen eine grafische Anzeige (Liniendiagramm) eures Verbrauches (Leistung [W]). Und zwar fein aufgelöst für die letzten 4 Stunden, grob aufgelöst für die letzten 24 Stunden und dann Tages und Monatsverbräuche [kWh] als Balkendiagramm. 
Ich habe über die Zeit einige Varianten des Scriptes erstellt, die alle durch unterschiedliche Nutzeranfragen auf meinem Blog entstanden sind.  

***ACHTUNG: KRITISCHE ÄNDERUNG AB SCRIPT VERSION 01.12.2025***  
Diagramm-Daten müssen vor dem Upgrade auf diese Version gesichert werden. Nach dem Update können die Daten wieder importiert werden.  
Anleitung: https://ottelo.jimdofree.com/stromz%C3%A4hler-auslesen-tasmota/#14  
Die Daten werden nun in einer extra Datei „data.csv“ gespeichert und können so jederzeit gesichert werden.  
Dieses Script ist nur noch für den __ESP32__. Tasmota (ottelo) Image ab v15.1.0 (07.12.2025) notwendig.

**Hauptverzeichnis (ESP32)**
- `0_SML_Simple`  
  einfaches Zählerscript ohne Diagramme, zeigt nur die reinen Werte vom Zähler an
- `1_SML_Script_Chart`  
  wenn ihr keine PV-Anlage / Balkonkraftwerk BKW habt (ohne Einspeisung)
- `2_SML_Script_Chart_PV`  
  wenn ihr eure Einspeisung sehen möchtet und euer Zähler das unterstützt (2-Richtungszähler)
- `2_SML_Script_Chart_PV2`  
  wie _PV Script aber mit sehr hoch aufgelöstem 4h-Leistungs-Diagramm (alle 5s ein Wert)
- `2_SML_Script_Chart_PV3`  
  wie _PV Script aber mit Kalenderwochenübersicht über das ganze Jahr, Bezug und Einspeisung = 53 Wochen
- `3_SML_Script_Chart_PV_Bezugszaehler`  
  wie _PV Script aber für 1-Richtungszähler (Netzeinspeisung in kWh wird berechnet)
- `4_SML_Script_Chart_PV_no_4h24h`  
  wie _PV Script aber ohne 4h und 24h Diagramme
- `5_SteckdoseLeistungsmesser_1`  
  wie 1_ Script jedoch für Energiemess-Steckdosen (z.B. Sonoff POW Elite, SONOFF POW320D, NOUS A8T)
  Script nicht mehr für ESP8266/8685 (Sonoff Pow R2, Nous A1T), schaut dazu in den Ordner ESP8266
- `5_SteckdoseLeistungsmesser_2`  
  wie 5_ Script aber mit sehr hoch aufgelöstem 4h-Leistungs-Diagramm (alle 5s ein Wert)
- `6_SML_Script_Wasseruhr`  
  Wasseruhr Script mit Diagrammen (Impulse)

**Wie passe ich das Script für meinen Stromzähler an?**
Vor Scriptversion 01.12.2025 musste die >M Sektion per Hand an den Zähler angepasst werden (das galt auch für die PINs der IR-Sende/Empfangsdioden des Lesekopfes). Nun kann ein passendes Zählerscript aus einem DropDown Menü ausgewählt werden. 
Auch die PIN-Auswahl geschieht nun bequem via DropDown. Je nach erkanntem ESP werden mehr oder weniger PINs zum Wählen dargestellt.

**andere-scripte (ESP32)**  
- `1_Script_DeepSleep`  
  ESP Tasmota Deepsleep Testscript (nur für ESP32)
- `2_Script_SML_Simulator`  
  emuliert ein MT175 Stromzähler, einfach auf einen 2. Lesekopf aufspielen (ESP8266 / ESP32)

**ESP8266**
Alle Scripte in der alten Version für den kleinen ESP8266 und ohne Zähler-DropDown Auswahlmenü. Es sind die gleichen wie aus dem Hauptverzeichnis nur werden diese nicht mehr aktualisiert (eingeforener Versionstand). Die Scripte funktionieren natürlich auch auf einem ESP32.  

**pvakku-powermeter-emulator (ESP32)**  
_Damit die Scripte funktionieren werden von mir angepasste Tasmota Images benötigt (min. 15.0.1). Images gibt es [hier](https://github.com/ottelo9/tasmota-sml-images). Für den ESP8266 muss entweder das tasmota1m_energy_ottelo oder tasmota4m_ottelo gewählt werden._  
- `1_SML_EcoTrackerEmu_Simple`  
  Sehr kleines und wirklich einfaches Script zum Emulieren eines EcoTracker von everHome. Getestet mit Marstek Akkus (Jupiter, Venus, B2500) und Hoymiles MS-A2.
  Es ist so klein, dass es auch auf dem ESP8266 läuft. Es hat keine Diagramme sondern zeigt nur das nötigste (Zählerwerte + Tages/Monats/Jahreswerte) an.
  Benötigt mein Tasmota Image [V15.0.1](https://github.com/ottelo9/tasmota-sml-images/releases/) oder höher. Im Script ist eine grobe Beschreibung, wie ihr das alles zum Laufen bekommt.
  Weitere Infos auf meinem [Blog](https://ottelo.jimdofree.com/stromz%C3%A4hler-auslesen-tasmota/#13a) oder im [Forum](www.photovoltaikforum.com/thread/250523-marstek-venus-jupiter-b2500-shelly-pro-3em-emulator-tasmota-lesekopf)!
- `1_SML_ShellyEmu_Simple`  
  Einfaches Script zum Emulieren eines Shelly Pro 3EM (getestet mit Marstek Akkus Jupiter, Venus, B2500)
  Es ist so klein, dass es auch auf dem ESP8266 läuft. Es hat keine Diagramme sondern zeigt nur das nötigste (Zählerwerte + Tages/Monats/Jahreswerte) an.
  Benötigt mein Tasmota Image [V15.0.1](https://github.com/ottelo9/tasmota-sml-images/releases/) oder höher. Im Script ist eine grobe Beschreibung, wie ihr das alles zum Laufen bekommt.
  Weitere Infos auf meinem [Blog](https://ottelo.jimdofree.com/stromz%C3%A4hler-auslesen-tasmota/#13a) oder im [Forum](www.photovoltaikforum.com/thread/250523-marstek-venus-jupiter-b2500-shelly-pro-3em-emulator-tasmota-lesekopf)!
- `2_SML_Script_Chart_PV_EcoTrackerEmu`  
  Wie 2_SML_Script_Chart_PV aber mit EcoTracker Emulation. Getestet mit Marstek Akkus (Jupiter, Venus, B2500) und Hoymiles MS-A2.
  Es ist kleiner als das 2_SML_Script_Chart_PV_ShellyEmu und läuft bei mir aktuell auf dem bitShake ESP32-C3 Lesekopf zusammen mit dem Marstek Jupiter C Plus Akku einwandfrei. 
  benötigt mein Tasmota Image [V15.0.1](https://github.com/ottelo9/tasmota-sml-images/releases/tag/V15.0.1_250721) oder höher (nur ESP32). Im Script ist eine grobe Beschreibung, wie ihr das alles zum Laufen bekommt.
  Weitere Infos auf meinem [Blog](https://ottelo.jimdofree.com/stromz%C3%A4hler-auslesen-tasmota/#13a) oder im [Forum](www.photovoltaikforum.com/thread/250523-marstek-venus-jupiter-b2500-shelly-pro-3em-emulator-tasmota-lesekopf)!  
- `2_SML_Script_Chart_PV_ShellyEmu`  
  Wie 2_SML_Script_Chart_PV aber mit Shelly Pro 3EM Emulation (getestet mit Marstek Akkus Jupiter, Venus, B2500)
  benötigt mein Tasmota Image [V15.0.1](https://github.com/ottelo9/tasmota-sml-images/releases/tag/V15.0.1_250721) oder höher (nur ESP32). Im Script ist eine grobe Beschreibung, wie ihr das alles zum Laufen bekommt.
  Weitere Infos auf meinem [Blog](https://ottelo.jimdofree.com/stromz%C3%A4hler-auslesen-tasmota/#13a) oder im [Forum](www.photovoltaikforum.com/thread/250523-marstek-venus-jupiter-b2500-shelly-pro-3em-emulator-tasmota-lesekopf)!

**script-list-menu (ESP32)**  
Hier liegen die Scripte, die via DropDown direkt über Tasmota auswählbar sind.
- `meters` = "Stromzähler konfigurieren / Daten sichern" Button -> DropDown Menü
- `scripts` = Tools -> Edit Script DropDown Menü

### Tasmota Image/Firmware
Die Skripte funktionieren nur, wenn ihr ein speziell angepasstes Tasmota Image (Firmware) verwendet (z.B. mit SML Support). Die Images könnt ihr ebenfalls auf [meiner github Seite](https://github.com/ottelo9/tasmota-sml-images/releases). herunterladen. Wenn ihr sehen möchtet, welche Features ich beim Erstellen der Images verwendet habe oder ihr euer eigenes Image erstellen wollt, dann schaut in die Readme [hier](https://github.com/ottelo9/tasmota-sml-images).

### Hardware
Die Scripte aus dem Hauptmenü bzw. die via DropDown auswählbar sind laufen nur noch auf einem ESP32 mit aktuellem Tasmota Image (ab 15.1.0) das ich ebenfalls hier anbiete.  
Hast du einen ESP8266 (z.B. im Hichi V1 Lesekopf oder in Sonoff / Gosund Steckdosen verbaut), dann kannst du die Scripte im Ordner ESP8266 verwenden. Dafür muss das Script aber dringend über den externen Script 
Editor "komprimiert" werden. D.h. es werden alle Kommentare und Leerzeichen entfernt. Der Editor überträgt das Script dann auch gleich.  

### Anleitung
Ein passendes Tasmota Image von mir herunterladen. Dann kann das Script unter Tools -> Edit Script ausgewählt werden. Danach wählt ihr euren Zähler und die PINs (IR-Sende/Empfangsdiode eures Lesekopfes) aus. Die Daten können bequem über den Button initialisiert werden.

Für die "alten" Scripte im ESP8266 Ordner gilt: Skript herunterladen und z.B. mit dem Windows Editor öffnen (öffnen mit). 
Es gibt auch für die Tasmota Skripte einen speziellen Editor vom Tasmota Script Entwickler [gemu2015](https://github.com/gemu2015) 
den ihr [hier](https://github.com/gemu2015/Sonoff-Tasmota/blob/universal/tasmota/scripting/Scripteditor.zip) herunterladen könnt. 
Dieser kann die Scripte direkt auf euren ESP übertragen und entfernt dabei alle Kommentare und leere Zeilen um Platz zu sparen! 
Eine genauere Anleitung findet ihr auf meinem Blog oder auch in jedem Script.  

GILT NUR FÜR DIE ESP8266 SCRIPTE:

**Die Skripte müssen von euch auf euren Zähler angepasst werden**  
Sucht die Zeile  
`>M 1`

Dort müsst ihr den SML Descriptor für euren Zähler anpassen. Weitere Details auf meiner Seite!  
Wenn ihr SML Zeilen entfernt oder hinzufügt, dann müsst ihr auch die Variablen im Script anpassen. Wenn die erste SML Zeile im Script z.B. `1,77070100100700ff@1,Leistung,W,Power_curr,0` ist, dann wird im Hintergrund von Tasmota die aktuelle Leistung `Power_curr` des Zählers in die Variable `sml[1]` geschrieben. Die 2te und 3te Zeile (im Script ist das der Verbrauch und die Netzeinspeisung) werden in `sml[2]` und `sml[3]` geschrieben.  

**Init**  
Wenn Tasmota und das Script läuft und ihr auch eure Zählerwerte (Leistung, Bezug und ggf. Einspeisung) sehen könnt, dann müsst ihr das Script einmal initialisieren, damit die Tages-, Monats-, und Jahreswerte und die Diagramme stimmen. Dazu geht zur Tasmota Console und tippt ein `script>=#init`. Anschließend sollte alles stimmen.  
 
Wichtig noch die korrekte Uhrzeit (Zeitzone, Winter/Sommer) festlegen (via Console),  
ab Script 18.08.2025 wird dies automatisch beim #init erledigt!  
`Backlog0 Timezone 99; TimeStd 0,0,10,1,3,60; TimeDst 0,0,3,1,2,120` <- Europe/Berlin  
Den Befehl müsst ihr ggf. auf euren Ort anpassen! https://tasmotatimezone.com  bzw. https://tasmota.github.io/docs/Timezone-Table/  

So sieht das Google Chart Script in Natura aus:  
![screencapture-192-168-178-31-2024-12-28-15_41_15](https://github.com/user-attachments/assets/cc1d8a8f-62c9-4609-839c-d90ff3d4c089)

### Debuggen oder Daten loggen
Falls ihr vielleicht im Script irgendwas loggen wollt (Zustände oder Werte in eine Datei mit Zeitstempel schreiben), dann gibt es eine schöne einfache Methode via Script. Erstellt dazu einfach ein neuen #Sub, da wo bereits Subs sind, ansonsten ist es egal wo:
```
#log(str)
tmp=fo("log.txt" a)
if tmp>=0 {
	res=fw(cts(tstamp 1) tmp)
	str="\t"+str+"\n"
	res=fw(str tmp)
	fc(tmp)
}
```
Ihr braucht dafür zwei neue Variablen, die ihr ganz oben im Script deklarieren müsst, falls sie noch nicht existieren:
```
tmp=0
res=0
str=""
```
Jetzt könnt ihr irgendwo im Script z.B. ein Wert in die Datei "log.txt" schreiben lassen inkl. Zeitstempel:
```
str="Leistung: "+s(sml[1])+" W"
=#log(str)
oder einfach nur
=#log(s(sml[1]))
```

------------------
Bedanken möchte ich mich besonders bei [gemu2015](https://github.com/gemu2015), der das Tasmota Scripting und SML entwickelt hat und mir immer sofort bei Problemen geholfen hat. Und natürlich beim restlichen [Tasmota Entwickler-Team](https://tasmota.github.io/docs/About/), für das grandiose Tasmota :).  

Die Stromzähler Meter Definition habe ich teilweise von folgenden Quellen übernommen und modifiziert:  
[Tasmota SML Wiki](https://tasmota.github.io/docs/Smart-Meter-Interface/#smart-meter-descriptors)  
[Stromleser.tasmota Scripte](https://stromleser.de/pages/scripts)  
[bitshake](https://bitshake.de/skripte/)  
DANKE !


[Offizielle Tasmota Github Seite](https://github.com/arendst/Tasmota)
