## TinyC-Programme für Stromzähler [by ottelo]

TinyC-Variante meiner Scripte: statt des Tasmota-Scripters läuft hier eine kleine
VM auf dem ESP32. Gleiche Aufgaben — Zähler auslesen, Diagramme, Nulleinspeisung —
nur schneller und mit einer richtigen Weboberfläche.

**📖 Anleitung, Einrichtung und alle Optionen:
[ottelo9.github.io/tasmota-sml-script](https://ottelo9.github.io/tasmota-sml-script/)**

Dorthin zeigen auch die ℹ️-Links neben jeder Einstellung auf dem Gerät.
Die Seite gibt es auf Deutsch und Englisch, umschaltbar oben rechts.

**WICHTIG: Es wird mein [Tasmota Image](https://github.com/ottelo9/tasmota-sml-images)
mit TinyC-Unterstützung benötigt (Variante `_tc`), und ein ESP32 — kein ESP8266.**

### Programme

Eines aussuchen, in Slot 0 laden. Modbus-TCP ist in jedem als Option enthalten.

| Datei | Beschreibung |
|---|---|
| `sml_simple.tc` | Nur Zähler. Kleinstes Programm. |
| `sml_chart.tc` | + Diagramme und Tabellen, Einspeisung schaltbar |
| `sml_eco_shelly.tc` | + EcoTracker- / Shelly-Pro-3EM-Emulator für PV-Akkus |
| `sml_chart_eco_shelly.tc` | Diagramme + EcoTracker / Shelly |
| `sml_ct002.tc` | + Marstek-CT002/CT003-Emulator |
| `sml_chart_ct002.tc` | Diagramme + Marstek CT002/CT003 |

Die Emulator-Varianten müssen in **Slot 0** laufen: ihre HTTP-Endpunkte sind
`webOn`-Handler, und die reicht Tasmota immer an Slot 0 weiter.

### Ordner

| | |
|---|---|
| `common/` | Bausteine, die per `#include` eingebunden werden. Nicht einzeln ladbar — kein `main()`. |
| `bytecode/` | Fertige `.tcb` plus `index.txt`. Das ist die Quelle für die Repository-Box auf der TinyC-Seite des Geräts. |

### Selbst kompilieren

Am einfachsten über `bytecode/build.html`: Ordner `tinyc` wählen, **Build** — fertig.
Die Seite übersetzt alle Programme auf einmal nach `bytecode/` und schreibt die
`index.txt` gleich mit. Den Compiler nimmt sie aus `bytecode/tinyc_ide.html`.

Einzeln in der IDE auf dem Gerät geht auch. Dann vorher mit **Incl** den Ordner
`common/` laden, sonst findet sie die `#include`-Dateien nicht.
