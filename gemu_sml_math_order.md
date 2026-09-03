# `=m`-Zeilen sollten am Ende eines Decode-Durchlaufs gerechnet werden, nicht an ihrer Position im Descriptor

## Störbild

Ein Nutzer meldet, dass der Shelly-Emulator mit einem **Elster Honeywell AS1440** nach wenigen
Minuten aus der Marstek-App verschwindet. Mit einem **KAIFA MB310** läuft dasselbe Setup stabil.
Der Unterschied ließ sich auf eine einzige Stelle eingrenzen:

| Quelle der Leistung | Ergebnis |
|---|---|
| `power = sml[1]` — die `=m`-Zeile des Descriptors | Verbindung bricht nach Minuten ab |
| `power = sml[5] - sml[6]` — dieselbe Rechnung im `>S`-Block | stabil |

Gleiches Gerät, gleicher Descriptor, gleiche Last. Nur die Quelle der Zahl unterscheidet sich.

Descriptor (Auszug, AS1440):

```
+1,%0rxpin%,o,%0smlf%,9600,AS1440,%0txpin%
1,=m 5-6 @1,Power,W,Power,16
1,1-1:1.8.2(@1,Total_HT In,KWh,ImportActive,2
1,1-1:2.8.0(@1,Total Out,KWh,ExportActive,2
1,1-1:1.8.1(@1,Total_NT In,KWh,Total_in_NT,2
1,=h--
1,1-1:1.7.0(@0.001,Power In,W,power_in,0
1,1-1:2.7.0(@0.001,Power Out,W,power_out,0
```

## Mechanismus

`SML_Decode` läuft den Descriptor von oben nach unten. Die `=m`-Zeile steht an **erster** Stelle,
ihre Operanden an fünfter und sechster. Wenn `=m` ausgewertet wird, sind `Power In` und
`Power Out` in diesem Durchlauf noch **nicht** aktualisiert — gerechnet wird mit den Werten des
vorigen Telegramms.

Zwei Folgen, die beide zum Störbild passen:

**1. Ein Telegramm Rückstand.** Beim KAIFA (Typ `s`, Telegramm im Sekundentakt) ist das eine
Sekunde und fällt nicht auf. Der AS1440 ist ein D0-Zähler (Typ `o`) mit einem `>F`-Weckzyklus von
rund 6 Sekunden — derselbe Rückstand sind dort 6 Sekunden zusätzlich zur ohnehin langsamen
Aktualisierung.

**2. Gemischter Zustand innerhalb eines Bursts.** Bei `o`-Zählern wird `SML_Decode` bei **jedem
CR/LF** aufgerufen, also einmal pro OBIS-Zeile (`xsns_53_sml.ino:2228`). `math_run` wird höchstens
einmal pro Sekunde gesetzt (`~2625`) und trifft damit einen beliebigen Zeilenwechsel — unter
Umständen genau zwischen der Aktualisierung von `1.7.0` und `2.7.0`. Dann rechnet `=m` **neuen
Bezug minus alten Einspeisewert**. Bei einem Zähler, der beide Richtungen als positive Zahl in
getrennten Registern führt, liegt das Ergebnis um die volle Einspeiseleistung daneben. Ein Akku,
der auf Nulleinspeisung regelt, bekommt einen Ausreißer von mehreren Kilowatt und verwirft den
Zähler.

Das erklärt auch, warum es „ein paar Minuten geht": solange die Drossel zufällig günstig fällt,
stimmen die Werte.

## Vorschlag

Die `=m`-Zeilen nicht an ihrer Position auswerten, sondern in einem **zweiten Durchlauf am Ende
von `SML_Decode`**, kurz vor `math_run = 0;` (`~3420`). Im Hauptdurchlauf würde die `=m`-Zeile nur
übersprungen (Position und `vindex` wie bisher weiterzählen), die Auswertung selbst wandert hinter
die letzte Wertaktualisierung.

Der zweite Durchlauf sollte weiterhin **in Descriptor-Reihenfolge** laufen, damit verkettete
`=m`-Zeilen — eine, die das Ergebnis einer vorherigen benutzt — unverändert funktionieren.

## Verträglichkeit

Descriptoren, deren `=m` ohnehin am Ende steht (etwa KAIFA MB310 mit den drei Phasenzeilen),
verhalten sich bitgleich wie bisher. Descriptoren mit `=m` vorne bekommen **ohne jede Änderung**
frische Werte. Es muss also kein einziges Zählerscript angefasst werden, und Scripter- wie
TinyC-Nutzer profitieren gleichermaßen. Ein Descriptor, der sich auf den alten
Ein-Telegramm-Rückstand verlässt, ist schwer vorstellbar.

Zwei Details, die beim Verschieben mitwandern müssen:

- der `SML_Immediate_MQTT`-Aufruf aus dem Math-Zweig (`~2727`)
- das Setzen von `dvalid` danach

Beides sollte an der Auswertung hängen bleiben, nicht an der alten Position.

## Optional, gründlicher

Selbst am Ende eines Durchlaufs ist bei `o`-Zählern erst **eine Zeile** eingelesen, nicht der ganze
Burst. Noch sauberer wäre, die Math-Auswertung an „in diesem Durchlauf wurde ein Wert
aktualisiert" zu koppeln oder auf den Abschluss des Telegramms zu legen. Der zweite Durchlauf
allein ist aber schon strikt besser als der Status quo und deutlich kleiner im Eingriff.

## Nachprüfen

`Power`, `power_in` und `power_out` gleichzeitig beobachten (Konsole oder MQTT). Zeigt `Power`
gelegentlich ungefähr `power_in + power_out` statt der Differenz, ist es genau dieser Effekt.

---

Zeilennummern beziehen sich auf den `universal`-Stand vom 03.09.2026; sie können gewandert sein.
