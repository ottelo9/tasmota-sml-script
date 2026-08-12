# Stromzähler-Descriptoren (Meter Definitions)

In diesem Ordner liegen die **SML/OBIS-Zählerbeschreibungen** (`>M`-Sektionen), die von meinen
Tasmota-Scripten über die **Zählerauswahl per DropDown** geladen werden.

Wählt ihr in der Weboberfläche eures Tasmota-Lesekopfs euren Zähler aus, lädt Tasmota die
passende `.tas`-Datei aus diesem Ordner herunter und speichert sie als `/sml_meter.def` im
Dateisystem des ESP. Ein Bearbeiten der `>M`-Sektion im Script ist dadurch nicht mehr nötig.

Möglich macht das die Scripter-Funktion `smlpd()`, die in meinen Scripten so eingebunden ist:

```
smlpd("https://raw.githubusercontent.com/ottelo9/tasmota-sml-script/main/script-list-menu/meters" "Stromzählerauswahl" sel)
```

Voraussetzung ist ein Tasmota-Image ab **v15.1.0** (mit `USE_SML_M`, `USE_SML_SCRIPT_CMD` und
`USE_HTML_CALLBACK`) — z.B. eines meiner [Images](https://github.com/ottelo9/tasmota-sml-images).

---

## Aufbau des Ordners

| Element | Bedeutung |
| --- | --- |
| `<Hersteller>/` | Ein Unterordner je Hersteller (ABB, Iskra, Landis + Gyr, …) |
| `<Hersteller>/<Modell>.tas` | Die eigentliche Zählerbeschreibung (nur die `>M`-Sektion) |
| `_Test/` | Hilfsdateien zum Testen, z.B. „Lesekopftest mit Spiegel“ |
| `smartmeter.json` | **Index für das DropDown-Menü** — nur was hier steht, erscheint zur Auswahl |

### `smartmeter.json`

```json
{
	"smartmeter": [
		{ "label": "Kein Zähler gewählt", "filename": "" },
		{ "label": "Iskra MT175", "filename": "Iskra/Iskra MT175.tas" }
	]
}
```

`label` ist der Anzeigetext im DropDown, `filename` der Pfad relativ zu diesem Ordner.

---

## Aufbau einer Zählerdatei

Beispiel `Iskra/Iskra MT175.tas`:

```
>M 1
+1,%0rxpin%,s,%0smlf%,9600,MT175,%0txpin%
1,77070100100700ff@1,Leistung,W,Power,16
1,77070100010800ff@1000,Verbrauch,kWh,ImportActive,2
1,77070100020800ff@1000,Einspeisung,kWh,ExportActive,2
1,=h--
1,77070100240700ff@1,L1,W,L1,0
1,77070100380700ff@1,L2,W,L2,0
1,770701004C0700ff@1,L3,W,L3,0
#
```

**Platzhalter** (werden beim Laden vom Script ersetzt, bitte immer so übernehmen):

| Platzhalter | Bedeutung |
| --- | --- |
| `%0rxpin%` | RX-Pin, in der Weboberfläche einstellbar |
| `%0txpin%` | TX-Pin, in der Weboberfläche einstellbar |
| `%0smlf%` | SML-Medianfilter (0 = aus, 16 = an), per Checkbox schaltbar |

**Aufbau einer Metrik-Zeile:**

```
<Meter>,<OBIS-Code>@<Teiler>,<Label>,<Einheit>,<JSON-Name>,<Nachkommastellen>
```

Ausführliche Dokumentation: [Smart Meter Interface](https://tasmota.github.io/docs/Smart-Meter-Interface/)

---

## Zwei Werte zu einem zusammenrechnen (`=m`)

Manche Zähler liefern Bezug und Einspeisung als **zwei getrennte, immer positive** Werte —
statt einer vorzeichenbehafteten Gesamtleistung. Für die Nulleinspeisung mit PV-Akkus
(EcoTracker-/Shelly-Emulation) wird aber genau eine Summe gebraucht:
**positiv = Netzbezug, negativ = Einspeisung.**

Ausgangslage (z.B. bei einigen Zählern mit `+P` / `-P`):

```
1,020909x52UUuuUUuu@1,+P,W,+P,3
1,020909x57UUuuUUuu@1,-P,W,-P,3
```

Mit `=m` lässt sich daraus direkt im Descriptor die Summe bilden — die beiden Zeilen sind
Decoder-Eintrag **1** und **2**:

```
1,020909x52UUuuUUuu@1,+P,W,+P,3
1,020909x57UUuuUUuu@1,-P,W,-P,3
1,=m 1-2 @1,Wirkleistung,W,Power,3
```

### Regeln für `=m`

- Der **erste Operand muss ein Decoder-Eintrag sein**, keine Konstante
- Auswertung **strikt von links nach rechts**, **keine Klammern**
- `#` kennzeichnet Konstanten, z.B. `=m 1-2/#1000` für kW statt W
- `@1` ist der Teiler des Ergebnisses (`@1` = unverändert)
- Danach wie gewohnt: `,<Label>,<Einheit>,<JSON-Name>,<Nachkommastellen>`
- **Beim Zählen aufpassen:** `=m`, `=h` und `=soX` sind selbst **keine** Decoder-Einträge.
  Beim Referenzieren also nur die echten OBIS-Zeilen mitzählen.

### Im Script darauf zugreifen

Über `sml[X]` (X = Nummer der Decoder-Zeile). Da `=m`-Zeilen bei der Zählung eine
Sonderrolle haben, prüft ihr den Index am schnellsten direkt am Gerät:

```
http://<Tasmota-IP>/cm?cmnd=script?sml[3]
```

Alternativ rechnet ihr einfach im Script — dann braucht es die `=m`-Zeile gar nicht:

```
cpwr=sml[1]-sml[2]
```

Beide Wege sind gleichwertig. Mit `=m` erscheint die Summe zusätzlich in der Weboberfläche
und im MQTT-JSON, die Script-Variante ist unabhängig von der Index-Zählweise.

---

## Weitere nützliche Spezialzeilen

| Befehl | Zweck |
| --- | --- |
| `=h` | Text/HTML in der Weboberfläche einfügen, z.B. `1,=h--` als Trennlinie |
| `=d` | Differenz über ein Zeitintervall bilden — für Zähler **ohne** Momentanleistung, z.B. `1,=d 3 10` (Eintrag 3, 10 s) |
| `=so1` | Für Zähler, die die Energierichtung über ein Statusbit signalisieren (ED300L, AS2020, DTZ541) |
| `=so2` | Diverse Fixes, u.a. OBIS-Zeilenvergleich (`,2`) oder invertierte serielle Leitung (`,4`) |
| `=so3` | Größe des seriellen Puffers setzen, z.B. `1,=so3,512` bei langen Zeilen |
| `=so4` | AES-Schlüssel für verschlüsselte Zähler (16 Hex-Zeichen) |
| `*` | Wert in der Weboberfläche ausblenden (als Label) bzw. JSON-Ausgabe unterdrücken |

---

## Neuen Zähler beitragen

1. `.tas`-Datei im passenden Hersteller-Ordner anlegen (Name = Modellbezeichnung)
2. Nur die `>M`-Sektion hineinschreiben, mit `#` abschließen
3. Die Platzhalter `%0rxpin%`, `%0txpin%`, `%0smlf%` verwenden statt fester Werte
4. Eintrag in `smartmeter.json` ergänzen (alphabetisch einsortieren)

Gerne per Pull Request oder über die
[Kontaktseite](https://ottelo.jimdofree.com/kontakt) — Rückmeldungen zu funktionierenden
Zählern nehme ich auch ohne PR entgegen.
