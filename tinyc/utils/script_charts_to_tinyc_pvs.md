# Scripter-Diagramme → TinyC

Führt in vier Schritten durch den Umzug der Balkendiagramme von einem
Tasmota-Scripter-Script zu den TinyC-Programmen.
[`script_charts_to_tinyc_pvs.html`](script_charts_to_tinyc_pvs.html) im Browser
öffnen — kein Server, keine Installation, es wird nichts hochgeladen.

Wer schon auf TinyC ist und nur seine Diagramme ansehen oder ändern will, nimmt
[`tinyc_chart_editor.html`](tinyc_chart_editor.html).

## Die vier Schritte

**1. `data.csv` einlesen.** Im Dateimanager des alten Geräts
(`http://<geraet>/ufsd`) herunterladen und hier auswählen. Bequemer: in Schritt 2
die IP eintragen, dann steht dort ein fertiger Link zur `data.csv`.

Das Layout wird an den Zeilen- und Spaltenzahlen erkannt:

| Script | Zeilen | Spalten | Anmerkung |
|---|---|---|---|
| `1_SML_Chart.tas` | 4 | 481 / 1441 / 31 / 12 | ohne Einspeisung |
| `2_SML_Chart_PV.tas`, `_PV2`, `_PV_Modbus`, `3_…_Bezugszaehler` | 5 | 481 / 1441 / 31 / 31 / 24 | |
| `2_SML_Chart_PV3.tas` | 7 | … + 53 / 53 | Wochenbalken entfallen |
| `4_SML_Chart_PV_no_4h24h.tas` | 3 | 31 / 31 / 24 | 4 h/24 h werden genullt |
| `5_SteckdoseLeistungsmesser_1`, `6_SML_Wasseruhr` | 4 | 481 / 1441 / 31 / 12 | gleiche Form wie `1_`, aber kein TinyC-Gegenstück |

Nicht dabei: `0_SML_Simple.tas` schreibt gar keine `data.csv`, und
`5_SteckdoseLeistungsmesser_2` hat `s4h` mit 721 statt 481 Werten — das passt in
kein TinyC-Array und wird mit einer entsprechenden Meldung abgelehnt.

**2. Basiswerte eintragen.** `dval`, `mval`, `yval`, `da` und die
Einspeise-Zwillinge sind im Scripter `p:`-Variablen und stehen **nicht** in der
`data.csv`. Ohne sie rechnet das Programm jede Minute

```
sml_dcon[heute] = Zählerstand − sml_dval
```

und schreibt bei `sml_dval = 0` den **kompletten Zählerstand** in den heutigen
Balken — der schießt auf z. B. 45 000 kWh hoch und drückt die ganze importierte
Historie optisch auf die Nulllinie.

Die Werte lassen sich beim alten Gerät direkt abfragen: IP eintragen, auf den
erzeugten Link klicken, die Antwort aus dem Tab hierher kopieren.

```
http://<ip>/cm?cmnd=script?dval;mval;yval;da
http://<ip>/cm?cmnd=script?dval2;mval2;yval2
```

Ein *angeklickter* Link ist eine normale Navigation — die Same-Origin-Sperre, die
ein `fetch` von einer lokalen Datei blockieren würde, greift dort nicht. Deshalb
braucht es kein `USE_CORS` im Image.

*Antwort übernehmen* versteht `{"script":{"dval":45231.5,…}}` und findet die
Werte auch, wenn beim Kopieren Text drumherum mitgekommen ist oder beide
Antworten hintereinander eingefügt werden.

Bleiben die Felder leer, wird die Datei ohne den Basiswert-Block geschrieben —
dann auf dem Gerät einmal *Tages/Monats/Jahres-Verbrauchswerte zurücksetzen*
drücken. Die Historie bleibt, nur der laufende Tag und Monat fangen bei 0 an.

`wval`/`wval2` (Wochenwerte aus `2_SML_Chart_PV3`) haben in
`sml_chart_common.tc` kein Gegenstück und entfallen.

**3. Herunterladen.** Erst hier — so sind die Basiswerte aus Schritt 2 mit drin.

| Datei | Inhalt | ohne Basiswerte | mit |
|---|---|---|---|
| `sml_chart.bin` | `sml_s4h[481]` · `sml_s24h[1441]` · `sml_dcon[31]` · `sml_mcon[12]` | 1965 | **1969** |
| `sml_chart_pv.bin` | `sml_dprod[31]` · `sml_mprod[12]` | 43 | **46** |

Format: rohe 4-Byte-Little-Endian-`float32`, aneinandergereiht, kein Header. Auch
für `sml_s4h`/`sml_s24h`, obwohl die im Gerät `int16` sind — `sml_chart_imp16()`
wandelt beim Lesen um.

Das `mcon[24]` des Scripters wird aufgeteilt: `[1..12]` Verbrauch → `sml_mcon`,
`[13..24]` Einspeisung → `sml_mprod`. Bei einem Script ohne Einspeisung entsteht
nur `sml_chart.bin` — 43 Nullen würden eine vorhandene Einspeise-Historie
löschen.

**4. Vorschau** (optional). Nur zum Nachsehen, ob die Werte richtig gelandet
sind.

## Einbauen — die Reihenfolge zählt

1. Slot stoppen: **Tools › TinyC Console** › das rote ■
2. Datei(en) hochladen: **Tools › Manage File system** › Upload
3. Slot starten: **Tools › TinyC Console** › das grüne ▶

Läuft der Slot beim Hochladen noch, schreibt `saveVars()` die `.pvs` neu, bevor
die `.bin` gelesen wird. Das Programm importiert die `.bin` **einmal**, schreibt
sie in die `.pvs` und **löscht sie danach** — dass die Datei weg ist, ist die
Markierung „schon importiert". Ab dann ist die `.pvs` der Speicher. Im Log steht

```
sml_chart: .bin carried baselines
sml_chart: imported .bin into .pvs, /sml_chart.bin deleted
```

## Was exakt übernommen wird

Die **Balken** für Tag und Monat, Verbrauch wie Einspeisung. Sie sind nach Tag
bzw. Monat indiziert, deshalb ist jede Zeile eine 1:1-Kopie (Scripter-Arrays sind
1-basiert, TinyC legt Tag 1 auf Index 0 — das hebt sich auf).

Die 4-h/24-h-Kurven kommen **verdreht** an: ihre Ringposition
(`sml_s4h_pos`/`sml_s24h_pos`) liegt in der `.pvs` und steht nicht in der `.bin`.
Nach vier bzw. 24 Stunden hat sich das von selbst erledigt.
