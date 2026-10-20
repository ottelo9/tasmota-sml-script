## Tasmota TinyC-Programme (Scripte) - Strom/Gas/Wasser-Zähler oder smarte Steckdosen auslesen [by ottelo]
### Werte grafisch darstellen, Verbraucher steuern, Nulleinspeisung für smarte Akkus realisieren
Tasmota TinyC-Programs (scripts) for Smart Meter Readers / Smart Powerplugs [by ottelo]. Display values graphically, implement zero-feed-in for smart batteries  

<a href="https://ottelo.jimdofree.com/stromz%C3%A4hler-auslesen-tasmota/"><img src="https://img.shields.io/badge/Mein%20Blog%20%E2%80%93%20Infos%2C%20Anleitungen%2C%20Hardware-0A6EBD?style=for-the-badge&logo=readme&logoColor=white" alt="Mein Blog: Ausführliche Infos, Anleitungen, Hardware"></a><br>
<a href="https://ottelo.jimdofree.com/tasmota-tinyc/"><img src="https://img.shields.io/badge/Mein%20Blog%20%E2%80%93%20TinyC%20Schnellanleitung-2EA043?style=for-the-badge&logo=rocket&logoColor=white" alt="Schnellanleitung TinyC"></a><br>
<a href="https://ottelo9.github.io/tasmota-sml-script/"><img src="https://img.shields.io/badge/Wiki%2FAnleitung%20%E2%80%93%20TinyC%20Programme%20erkl%C3%A4rt%20%26%20Script%3ETinyC%20Konverter%20(DE%2FEN)-8250DF?style=for-the-badge&logo=bookstack&logoColor=white" alt="Wiki/Anleitung – TinyC Programme erklärt &amp; Script&gt;TinyC Konverter (DE/EN)"></a><br>
<a href="https://github.com/ottelo9/tasmota-sml-images"><img src="https://img.shields.io/badge/Firmware%20%E2%80%93%20Hier%20gehts%20zu%20meinen%20Tasmota%20Images-D73A49?style=for-the-badge&logo=github&logoColor=white" alt="Firmware: Hier gehts zu meinen Tasmota Images"></a><br>
<sub>Die Hilfe erreicht ihr auch über das ℹ️ im TinyC-Programm.</sub>

> [!IMPORTANT]
> Damit die TinyC-Programme oder Scripte funktionieren müsst ihr mein [Tasmota Image](https://github.com/ottelo9/tasmota-sml-images) (Firmware) verwenden (flashen)!

### A) TinyC-Programme
TinyC ist der Nachfolger von Tasmota Script / Berry, ist ca. 10x schneller und bietet viel mehr Möglichkeiten. Es läuft allerdings nur auf dem ESP32. Wenn ihr nicht wechseln oder auf euren ESP8266 bzw. älteren Lesekopf (z.B. HichiV1 ESP01s) verzichten wollt, dann scrollt etwas herunter zu B). Ich würde jedoch jedem empfehlen, auf TinyC umzusteigen.  
<br>
Eine Liste von Programmen findet ihr auf meiner [neuen Wiki/Hilfe Seite](https://ottelo9.github.io/tasmota-sml-script/sml/#programs). Ich habe meine bekannten Scripte zu TinyC konvertiert und die Varianten als Optionen inkludiert. Das alles ist mit TinyC problemlos möglich gewesen. Z.b. ist nun ModbusTCP Slave als Option immer mit drin.  
  
Wenn noch eins meiner Scripte auf eurem ESP/Lesekopf läuft und ihr wechseln wollt, dann könnt ihr die Diagrammdaten/Verbräuche exportieren und dann wieder importieren. [Anleitung und Online-Converter Tool](https://ottelo9.github.io/tasmota-sml-script/converter/).  

1. Die TinyC Programme wählt ihr bequem direkt auf eurem ESP aus via Tools > TinyC Console > Repository Drop Down Menü:
   <img width="300" alt="image" src="https://github.com/user-attachments/assets/822d2298-d81e-44c9-b4f8-45df25e92ccc" />
3. Oder ladet euch die Programme herunter. Fertige tcb Programme unter [tinyc/bytecode](tinyc/bytecode). Sourcecode der Programme im [tinyc](tinyc) Ordner. Die fertigen Programme könnt ihr auf der TinyC Seite manuell hochladen. Den Sourcecode (tc) müsst ihr über die TinyC IDE kompilieren oder via [build.html](tinyc/bytecode/build.html) lokal auf eurem PC.
4. Dann starten und den Autostart aktivieren  
   <img width="300" alt="image" src="https://github.com/user-attachments/assets/5ef219fa-0b6b-4bea-bfab-8c40c4f1d073" />
5. Auf der Hauptseite in den Optionen ⚙️ könnt ihr euren Stromzähler wählen und verschiedene andere Sachen einstellen.
6. Updates: In der Slot-Zeile steht hinter dem Programmnamen seine Version. Gibt es im Repository eine neuere, erscheint ein 🔄-Knopf. Ein Klick lädt sie in denselben Slot, Einstellungen und Daten bleiben erhalten (Image ab 18.10.2026).


### B) Tasmota Scripte (veraltet)
Scripte für den kleinen ESP8266 findet ihr in einem extra Ordner. Die größeren/umfangreicheren Scripte für ESP32 liegen im Hauptverzeichnis dieser Repo, spezielle Scripte für PV-Akkus unter [pvakku-powermeter-emulator](pvakku-powermeter-emulator). Die komprimierten Scripte (ohne Kommentare) liegen in [script-list-menu/scripts](script-list-menu/scripts). Diese lädt Tasmota ins Scripteditor Fenster, wenn ihr sie mit dem DropDown Menü ausgewählt habt.
  
Die Scripte erstellen eine grafische Anzeige (Liniendiagramm) eures Verbrauches (Leistung [W]). Und zwar fein aufgelöst für die letzten 4 Stunden, grob aufgelöst für die letzten 24 Stunden und dann Tages und Monatsverbräuche [kWh] als Balkendiagramm. Ich habe über die Zeit einige Varianten des Scriptes erstellt, die alle durch unterschiedliche Nutzeranfragen auf meinem Blog entstanden sind.  
Info: Die TinyC-Programme enthalten alle diese Features als wählbare Optionen.  

Scriptauswahl direkt in Tasmota:  
<img width="300" height="200" alt="image" src="https://github.com/user-attachments/assets/d6c8114e-da35-49ba-9ba2-47df5fd1c3fb" />  
Stromzähler/Pin-Auswahl:  
<img width="200" height="300" alt="image" src="https://github.com/user-attachments/assets/308c6d35-80e5-4a78-88da-adc573ad1b8b" />

**Hauptverzeichnis (ESP32)**
- `0_SML_Simple`  
  einfaches Zählerscript ohne Diagramme, zeigt nur die reinen Werte vom Zähler an
- `1_SML_Script_Chart`  
  wenn ihr keine PV-Anlage / Balkonkraftwerk BKW habt (ohne Einspeisung)
- `2_SML_Script_Chart_PV`  
  wenn ihr eure Einspeisung sehen möchtet und euer Zähler das unterstützt (2-Richtungszähler)
- `2_SML_Script_Chart_PV_Modbus`  
  wie das vorherige Script aber mit ModbusTCP Server (Slave) Support. Leistung, Verbrauch und Einspeisung werden auf den Modbus Adressen 40000-40006 ausgegeben.  
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

**pvakku-powermeter-emulator (ESP32)**
Diese Scripte emulieren einen Shelly Pro 3EM oder Ecotracker, die mit smarten Akkus verbunden werden (zur Nulleinspeisung). Das Script ist direkt auf dem Lesekopf lauffähig und übernimmt neben dem Stromzähler auslesen die Emulation.  
Die Scripte sind bereits von mehreren Nutzern vielfach mit unterschiedlichen Akkus getestet wurden (siehe folgende Liste). Damit der Emulator vom Akku gefunden wird bzw. auch reibungslos läuft, sollte der Akku und der ESP/Lesekopf (auf dem der Emu läuft) eine gute WLAN Verbindung haben. Bei meinem Marstek Jupiter C Plus gabs nämlich Probleme, der Emulator wurde erkannt war aber danach sofort Offline. Der Akku hatte schlechten Empfang (im roten Bereich). Manche andere Akkus möglich es z.B. auch nicht, wenn sie mit unterschiedlichen Accesspoints/Repeatern im WLAN verbunden sind.  
  
Beispiel mit mehreren Akkus:  
[3 Marstek (2 × B2500 und einmal Venus A) im Parallelbetrieb](https://www.photovoltaikforum.com/thread/250523-marstek-venus-jupiter-b2500-shelly-pro-3em-emulator-tasmota-lesekopf/?postID=4673773#post4673773)  

Getestete Akkus: [Liste mit getesteten Akkus](https://ottelo9.github.io/tasmota-sml-script/eco_shelly/#tested)  

- `1_SML_EcoTrackerEmu_Simple`  
  Sehr kleines und wirklich einfaches Script zum Emulieren eines EcoTracker von everHome.  
  Es hat keine Diagramme sondern zeigt nur das nötigste (Zählerwerte + Tages/Monats/Jahreswerte) an.
  Benötigt mein Tasmota Image [V15.0.1](https://github.com/ottelo9/tasmota-sml-images/releases/) oder höher. Im Script ist eine grobe Beschreibung, wie ihr das alles zum Laufen bekommt.
  Weitere Infos auf meinem [Blog](https://ottelo.jimdofree.com/stromz%C3%A4hler-auslesen-tasmota/#13a) oder im [Forum](www.photovoltaikforum.com/thread/250523-marstek-venus-jupiter-b2500-shelly-pro-3em-emulator-tasmota-lesekopf)!
- `1_SML_ShellyEmu_Simple`  
  Einfaches Script zum Emulieren eines Shelly Pro 3EM.    
  Es hat keine Diagramme sondern zeigt nur das nötigste (Zählerwerte + Tages/Monats/Jahreswerte) an.
  Weitere Infos auf meinem [Blog](https://ottelo.jimdofree.com/stromz%C3%A4hler-auslesen-tasmota/#13a) oder im [Forum](www.photovoltaikforum.com/thread/250523-marstek-venus-jupiter-b2500-shelly-pro-3em-emulator-tasmota-lesekopf)!
- `2_SML_Script_Chart_PV_EcoTrackerEmu`  
  Wie 1_SML_EcoTrackerEmu_Simple aber Diagrammen (wie 2_SML_Script_Chart_PV).
  Es ist kleiner als das 2_SML_Script_Chart_PV_ShellyEmu und läuft bei mir aktuell auf dem bitShake ESP32-C3 Lesekopf zusammen mit dem Marstek Jupiter C Plus Akku einwandfrei. 
  Weitere Infos auf meinem [Blog](https://ottelo.jimdofree.com/stromz%C3%A4hler-auslesen-tasmota/#13a) oder im [Forum](www.photovoltaikforum.com/thread/250523-marstek-venus-jupiter-b2500-shelly-pro-3em-emulator-tasmota-lesekopf)!  
- `2_SML_Script_Chart_PV_ShellyEmu`  
  Wie 1_SML_ShellyEmu_Simple aber Diagrammen (wie 2_SML_Script_Chart_PV).
  Weitere Infos auf meinem [Blog](https://ottelo.jimdofree.com/stromz%C3%A4hler-auslesen-tasmota/#13a) oder im [Forum](www.photovoltaikforum.com/thread/250523-marstek-venus-jupiter-b2500-shelly-pro-3em-emulator-tasmota-lesekopf)!

**andere-scripte (ESP32)**  
- `1_Script_DeepSleep`  
  ESP Tasmota Deepsleep Testscript (nur für ESP32)
- `2_Script_SML_Simulator`  
  emuliert ein MT175 Stromzähler, einfach auf einen 2. Lesekopf aufspielen (ESP8266 / ESP32)
- `3_TemperaturLoggerDS18S20`  
  Temperatur-Logger (10x DS18S20) für eine Solarthermie-/Heizungsanlage. Benötigt `SetOption64 1` (via Console) und `#define DS18X20_MAX_SENSORS 10` (meine ESP32 oder tasmota1m_energy_ottelo_tas Images).

**script-list-menu (ESP32)**  
Hier liegen die Scripte, die via DropDown direkt über Tasmota auswählbar sind.
- `meters` = "Stromzähler konfigurieren / Daten sichern" Button -> DropDown Menü
- `scripts` = Tools -> Edit Script DropDown Menü

**ESP8266**  
Alle Scripte (auch pvakku-powermeter-emulator) in der alten Version für den kleinen ESP8266 und ohne Zähler-DropDown Auswahlmenü. Es sind die gleichen wie aus dem Hauptverzeichnis nur werden diese nicht mehr aktualisiert (eingeforener Versionstand). Die Scripte funktionieren natürlich auch auf einem ESP32. Hier findet ihr auch die pvakku-powermeter-emulator Scripte, die auf dem ESP8266 lauffähig sind. Hier gibt es keine Diagramme, da der ESP zu klein ist. Aber die Emulation läuft ebenfalls einwandfrei!  
Neu: [Marstek CT002 Emulator](ESP8266/pvakku-powermeter-emulator) für bis zu 4 Marstek-Akkus (`2_CT002_Emulator.tas`, von next145). Dafür das Image **tasmota1m_ct002_ottelo_tas** aus meinem [Image-Repo](https://github.com/ottelo9/tasmota-sml-images) verwenden. Es hat die Seite **Marstek CT002** (`/ctreg`, unter Tools) zur einmaligen Anmeldung in der Marstek-Cloud.  

### C) Testtools:
<b>UDP/HTTP/PING/mDNS Tester</b>  
Ihr könnt die Emulation mit meinem [PowerScript](test-tools/Shelly-EcoTracker%20Tester.ps1) Tool testen (UDP, HTTP Get, Ping, mDNS). Die Vorgabe-Knöpfe nennen jeweils das Gerät: EcoTracker, Shelly Pro 3EM oder Pro EM50:  
<img width="400" height="400" alt="image" src="https://github.com/user-attachments/assets/c70370f6-00c6-4fc8-bef0-9253bf2b6ece" />

<b>SML Simulator</b>  
Gemu2015 hat ein [SML Simulator Tool](https://github.com/gemu2015/Sonoff-Tasmota/blob/universal/tasmota/tinyc/sml_emulator.html) (simuliert einen x-beliebigen Stromzähler) für den Google Chrome Browser erstellt. Zum Simulieren eines Stromzählers wird ein USB Lesekopf am PC benötigt. Das Tool kann auch Zählerscripte (Meter Descriptor) erstellen und auch direkt an Tasmota senden. Wieso Google Chrome Browser? Nur Chrome unterstützt das serielle Interface.  
<img width="400" height="200" alt="image" src="https://github.com/user-attachments/assets/9a5190da-2e8c-4198-97d0-4152276ad7a1" />

### D) Tasmota Image/Firmware
Die TinyC-Programme oder Skripte funktionieren nur, wenn ihr ein speziell angepasstes Tasmota Image (Firmware) verwendet. Die Images könnt ihr ebenfalls auf [meiner github Seite](https://github.com/ottelo9/tasmota-sml-images/releases). herunterladen. Wenn ihr sehen möchtet, welche Features ich beim Erstellen der Images verwendet habe oder ihr euer eigenes Image erstellen wollt, dann schaut in die Readme [hier](https://github.com/ottelo9/tasmota-sml-images).

### E) Anleitung
Ein passendes Tasmota Image von mir herunterladen (_tc für TinyC oder _tas für Script). Dann kann das Programm unter Tools > TinyC Console > Repository bzw. das Script unter Tools > Edit Script ausgewählt werden. Ist das Programm oder Script geladen, wählt ihr euren Zähler und die PINs (IR-Sende/Empfangsdiode eures Lesekopfes) über die Option im Hauptmenü aus. Wenn alles läuft und ihr auch eure Zählerwerte sehen könnt, dann müsst ihr die Daten einmalig initialisieren, damit die Tages-, Monats-, und Jahreswerte und die Diagramme stimmen. Dazu tippt einfach auf den entsprechenden Button auf der Optionsseite. Alle Werte sind dann auf 0 zurückgesetzt! Wollt ihr von Script > TinyC wechseln und die Daten mitnehmen? Das geht mit dem [Online Converter Tool](https://ottelo9.github.io/tasmota-sml-script/converter/).  

**ESP8266:**  
Für die "alten" Scripte im ESP8266 Ordner gilt: Skript herunterladen und z.B. mit dem Windows Editor öffnen (öffnen mit). 
Es gibt auch für die Tasmota Skripte einen speziellen Editor vom Tasmota Script Entwickler [gemu2015](https://github.com/gemu2015) 
den ihr [hier](https://github.com/gemu2015/Sonoff-Tasmota/blob/universal/tasmota/scripting/Scripteditor.zip) herunterladen könnt. 
Dieser kann die Scripte direkt auf euren ESP übertragen und entfernt dabei alle Kommentare und leere Zeilen um Platz zu sparen! 
Eine genauere Anleitung findet ihr auf meinem Blog oder auch in jedem Script.  

Die älteren Scripte für den ESP8266, dort könnt ihr euren Zähler nicht via DropDown wählen. Den Zähler müsst ihr im Script editieren.  
Sucht die Zeile  
`>M 1`

Dort müsst ihr den SML Descriptor für euren Zähler anpassen. Weitere Details auf meiner Seite!  
Wenn ihr SML Zeilen entfernt oder hinzufügt, dann müsst ihr auch die Variablen im Script anpassen. Wenn die erste SML Zeile im Script z.B. `1,77070100100700ff@1,Leistung,W,Power_curr,0` ist, dann wird im Hintergrund von Tasmota die aktuelle Leistung `Power_curr` des Zählers in die Variable `sml[1]` geschrieben. Die 2te und 3te Zeile (im Script ist das der Verbrauch und die Netzeinspeisung) werden in `sml[2]` und `sml[3]` geschrieben.  

Wenn Tasmota und das Script läuft und ihr auch eure Zählerwerte (Leistung, Bezug und ggf. Einspeisung) sehen könnt, dann müsst ihr das Script einmal initialisieren, damit die Tages-, Monats-, und Jahreswerte und die Diagramme stimmen. Dazu geht zur Tasmota Console und tippt ein script>=#init. Anschließend sollte alles stimmen.

### F) Home Assistant Tasmota Integration
Korrektes Sensor-Mapping: Damit die Tasmota Integration die Werte vom Stromzähler voll automatisch konfiguriert (device_class, state_class, unit) muss in der >M Meter Sektion für jeden Wert ein korrekter Name vergeben werden.  

Beispiel:  
1,77070100100700ff@1,Leistung,W,**Power**,16  
1,77070100010800ff@1000,Verbrauch,kWh,**ImportActive**,2  
1,77070100020800ff@1000,Einspeisung,kWh,**ExportActive**,2  

Wenn ihr euren Zähler über mein Zähler DropDown Menü im Script ausgewählt habt, dann werden bereits die korrekten Namen vergeben. Ich habe nämlich alle Zählerscripte händisch angepasst!  

**Energie / Leistung**

| JSON-Key | unit | device_class | state_class |
|---|---|---|---|
| **Total** | kWh | `energy` | `total` |
| **Today** | kWh | `energy` | `total_increasing` |
| **Yesterday** | kWh | `energy` | — |
| **TotalTariff** | kWh | `energy` | `total` |
| **Energy** | kWh | `energy` | `total` |
| **ExportActive** | kWh | `energy` | `total` |
| **ExportTariff** | kWh | `energy` | `total` |
| **ImportActive** | kWh | `energy` | `total` |
| **ExportReactive** | kVArh | — | `total` |
| **ImportReactive** | kVArh | — | `total` |
| **Power** | W | `power` | `measurement` |
| **ActivePower** | W | `power` | `measurement` |
| **ApparentPower** | VA | `apparent_power` | `measurement` |
| **ReactivePower** | VAr | `reactive_power` | `measurement` |
| **Voltage** | V | `voltage` | `measurement` |
| **Current** | A | `current` | `measurement` |
| **CurrentNeutral** | A | `current` | `measurement` |
| **Frequency** | Hz | `frequency` | `measurement` |
| **Factor** | *(None)* | `power_factor` | `measurement` |
| **PhaseAngle** | ° | — | — |
| **TotalStartTime** | *(None)* | — | — |
Für weitere siehe [hier](https://github.com/ottelo9/tasmota-sml-script/pull/42#issuecomment-4053749869).  

  
------------------
Bedanken möchte ich mich besonders bei [gemu2015](https://github.com/gemu2015), der das Tasmota Scripting und SML entwickelt hat und mir immer sofort bei Problemen geholfen hat. Und natürlich beim restlichen [Tasmota Entwickler-Team](https://tasmota.github.io/docs/About/), für das grandiose Tasmota :).  

Die Stromzähler Meter Definition habe ich teilweise von folgenden Quellen übernommen und modifiziert:  
[Tasmota SML Wiki](https://tasmota.github.io/docs/Smart-Meter-Interface/#smart-meter-descriptors)  
[Stromleser.tasmota Scripte](https://stromleser.de/pages/scripts)  
[bitshake](https://bitshake.de/skripte/)  
DANKE !


[Offizielle Tasmota Github Seite](https://github.com/arendst/Tasmota)

------------------
## Lizenz

Alles in dieser Repo steht unter der [GPL-3.0](LICENSE) — dieselbe Lizenz wie Tasmota selbst, auf dem die Scripte und TinyC-Programme laufen.

Die Regelung des CT002/CT003-Emulators ist der [CT002-Regelung von AstraMeter](https://github.com/tomquist/AstraMeter/blob/main/docs/ct002.md) nachempfunden (ebenfalls GPL-3.0). Danke an tomquist.
