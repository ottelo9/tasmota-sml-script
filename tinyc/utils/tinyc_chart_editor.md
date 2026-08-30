# TinyC `.pvs`-Editor

Bearbeitet die `.pvs` eines TinyC-Slots direkt — die Datei, in der das laufende
Programm seine `persist`-Variablen hält (`/sml_chart.tcb` → `/sml_chart.pvs`).
[`tinyc_chart_editor.html`](tinyc_chart_editor.html) im Browser öffnen, kein Server,
es wird nichts hochgeladen.

Wer von einem Tasmota-Scripter-Script umzieht, nimmt
[`script_charts_to_tinyc_pvs.html`](script_charts_to_tinyc_pvs.html).

## Ablauf

1. `.pvs` im Dateimanager des Geräts (`http://<geraet>/ufsd`) herunterladen und
   hier hineinziehen.
2. Alle Einträge werden aufgelistet: Reihen als Diagramm mit Wertefeld, Skalare
   als Eingabefeld. Geändertes ist blau umrandet.
3. `.pvs` herunterladen und zurückspielen:
   - Slot stoppen: **Tools › TinyC Console** › das rote ■
   - Datei hochladen: **Tools › Manage File system** › Upload — gleicher Name,
     gleicher Pfad
   - Slot starten: **Tools › TinyC Console** › das grüne ▶

   Die Reihenfolge zählt: läuft der Slot beim Hochladen noch, schreibt
   `saveVars()` beim Stoppen seine eigenen Werte darüber.

Die `.pvs` wird beim Start gelesen und **nicht** umbenannt — sie ist der
Speicher, keine Import-Datei.

## Das Format

`PVS3`, was der aktuelle Compiler schreibt (`tc_persist_save()` in
`xdrv_124_tinyc_vm.h`). Namensbasiert, **ohne Prüfsumme**:

```
'P' 'V' '3'  count:u8
je Eintrag:  nameLen:u8  name:nameLen  slotCount:u16 LE  data:slotCount×4 LE
```

`PVS2` ist der Vorgänger (`'P','V','H'`, `layout_hash:u32`, und `index:u16`
statt des Namens). Dieser Hash geht über das **Layout** — Anzahl, Index,
Slotzahl — nicht über die Daten. Werte zu ändern lässt ihn gültig, deshalb
werden die gespeicherten Hash-Bytes einfach durchgereicht. Beide Versionen
werden gelesen und in derselben Version wieder geschrieben.

Der Loader im Gerät ist nachsichtig: unbekannte Namen werden übersprungen, ein
fehlender Eintrag behält seinen aktuellen Wert, ein zu kurzer wird so weit
geladen wie er reicht.

**Ohne Änderung ist die Ausgabe Byte für Byte identisch mit der Eingabe.** Nur
was bearbeitet wurde, wird neu geschrieben — auch Einträge, die dieser Editor
gar nicht kennt, gehen unverändert wieder hinaus.

## Typen

Ein Slot sind immer 4 Bytes. **Wie** sie zu lesen sind, steht nicht in der
Datei — das weiß nur das Programm. Der Editor kennt die Variablen der
SML-Programme:

| Name | Typ | Werte |
|---|---|---|
| `sml_s4h`, `sml_s24h` | `int16` | 481 / 1441 |
| `sml_dcon`, `sml_dprod` | `float` | je 31 |
| `sml_mcon`, `sml_mprod` | `float` | je 12 |
| `sml_s4h_pos`, `sml_s24h_pos`, `sml_da` | `int32` | 1 |
| `sml_dval`, `sml_mval`, `sml_yval` und die `2`-Zwillinge | `float` | 1 |

`int16` liegt gepackt: `(n+1)/2` Slots, Element *i* an Byte-Offset *i*·2.

Alles andere wird als `float` gezeigt und kann je Eintrag auf `int32` oder
`int16` umgeschaltet werden — damit ist der Editor auch für andere
TinyC-Programme brauchbar.

## `.bin`

Eine `.bin` wird ebenfalls gelesen und geschrieben. Sie ist die *Import*-Datei:
rohe `float32` in der Reihenfolge aus `sml_chart_common.tc`, kein Kopf.

| Datei | Inhalt | ohne Basiswerte | mit |
|---|---|---|---|
| `sml_chart.bin` | `sml_s4h` · `sml_s24h` · `sml_dcon` · `sml_mcon` | 1965 | 1969 |
| `sml_chart_pv.bin` | `sml_dprod` · `sml_mprod` | 43 | 46 |

Das Programm liest sie beim Start **einmal**, schreibt sie in die `.pvs` und
löscht sie danach. Der Basiswert-Block wird nur angehängt, wenn alle Werte da
sind — das Programm liest ihn ganz oder gar nicht.

Für den normalen Fall ist die `.pvs` der bessere Weg: sie enthält *alle*
Variablen, die `.bin` nur diese.

Die CSV-Ausgabe ist nur zum Nachlesen; das Gerät liest sie nicht ein.
