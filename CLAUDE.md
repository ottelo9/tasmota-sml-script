# tasmota-sml-script — notes for Claude

Smart-meter reading for Tasmota: legacy Scripter scripts (`*.tas`) and the TinyC
program family in `tinyc/`, with bilingual help pages in `docs/` (served as
GitHub Pages). Personal setup, devices and working rules: `CLAUDE.local.md`
(not in the repo).

## Layout

| Path | What |
|---|---|
| `tinyc/*.tc` | the six programs: `sml_simple`, `sml_chart`, `sml_ct002`, `sml_chart_ct002`, `sml_eco_shelly`, `sml_chart_eco_shelly` |
| `tinyc/common/` | shared modules, `#include`d by the programs |
| `tinyc/bytecode/` | built `.tcb`, `build.html` (the compiler), `index.json` (program picker) |
| `docs/<topic>/index.html` | help pages, `en`/`de` blocks side by side |
| `script-list-menu/meters/` | SML descriptors (`.tas`) and `smartmeter.json` for the repo pulldown |
| `pvakku-powermeter-emulator/` | `Shelly-EcoTracker Tester.ps1` |

Module chain: `ui_common` ← `sml_descriptor` ← `sml_chart_common`;
`sml_modbus_common`, `ct002_common`, `eco_shelly_common` each include `ui_common`.

## Workflow

- **Building:** always the way `tinyc/bytecode/build.html` does it: the
  compiler from `tinyc/bytecode/tinyc_ide.html`, every `.tc` with `main()`,
  output `.tcb` + `index.txt` + `index.json`. The owner uses the page;
  Claude runs the same steps in Node (script in `CLAUDE.local.md`). Not gemu's
  `idesrc` - the IDE in this repo decides the compiler version. The `.tcb`
  files are committed next to the source.
- Bump `sml_vers` in **all six** programs whenever something ships — it is
  the date, `dd.MM.yyyy`, of the day of the change.
- Help pages are bilingual — change both languages together. Behaviour changes
  go into the help page, not into source comments.
- Do not commit unless asked. Commit messages: German, a title line plus short
  bullets.
- **Line endings are mixed** (LF and CRLF, `autocrlf`) — keep each file's own.
  Do not edit with `sed`/`perl` from Git Bash (it rewrote LF files to CRLF);
  use the Edit tool or a Node script that normalises to LF and restores. Bash
  heredocs mangle backslashes — write scripts with the Write tool instead.
- **No needless flash writes.** Nothing periodic; at most once at midnight,
  riding along with a write that happens anyway. The firmware saves the `.pvs`
  itself on restart, slot stop and upload — no saving in `CleanUp`/`OnExit`.

## Conventions

- Source comments: **English, short**, only the non-obvious *why*.
- `addLog()` lines: always English.
- UI text: `if (ui_de) … else …`; widget labels must be string **literals**.
- **Settings take effect on Save.** Widgets bind to `*_e_*` edit copies;
  `uiApplyBegin()` latches the press, modules act on `ui_applying` /
  `ui_reloading`. Exceptions: language switch (immediate), CT MAC (`/ctreg`).
- **`/tc_options.cfg`** carries settings across programs (`.pvs` is per program,
  named after the `.tcb`). `@name=value` lines; `-32768` = absent; floats
  (energy baselines) in a separate table. A new option needs: a slot in
  `tc_opt[]`, a `tcOptLoad` line, a `tcOptSave` line, `tcOptGet/Set` in the
  program. **All 38 slots are taken** — the next option must grow the arrays.

  | idx | key | idx | key | idx | key |
  |---|---|---|---|---|---|
  | 0 | ui_de | 12 | mb_port | 24 | ct_tweak |
  | 1 | ui_nosleep | 13 | es_mode | 25 | sml_da |
  | 2 | sml_meter_sel | 14 | es_port | 26 | ct_trim |
  | 3 | sml_rx_pin | 15 | es_offset | 27 | ct_pace |
  | 4 | sml_tx_pin | 16 | es_tweak | 28 | ct_mindc |
  | 5 | sml_filter | 17 | es_force | 29 | ct_fair |
  | 6 | sml_activ | 18 | es_throttle | 30 | chart_short (minutes) |
  | 7 | sml_drvrows | 19 | ct_kind | 31 | chart_onmain |
  | 8 | sml_ph3 | 20 | ct_offset | 32 | sml_bezug |
  | 9 | sml_pv | 21 | ct_port | 33 | ct_sat |
  | 10 | sml_sndpwr | 22 | ct_rssi | 34 | ct_maxdc |
  | 11 | mb_on | 23 | ct_ttl | 35 | sw_on |
  | | | | | 36 | sw_won |
  | | | | | 37 | sw_woff |

  One string key outside the table: `@sw_ip=` (`tc_opt_ip`, `char[16]`,
  `tcOptSetIp`) — the PV switch's target (`pv_switch_common.tc`).

  Floats (`tc_optf[]`, 9 slots, all taken): 0 `imp_day`, 1 `imp_month`,
  2 `imp_year`, 3 `exp_day`, 4 `exp_month`, 5 `exp_year`, 6 `imp_week`,
  7 `exp_week`, 8 `exp_virt`. The cfg wins over the `.pvs` on the first tick;
  for `exp_virt` (only grows) the higher of the two wins.

- **`webOn` handler numbers are family-wide:** 1, 2, 3, 5, 6 = eco_shelly
  endpoints, 4 = `/ctreg`, 7 = `/pwr`. Tasmota never unregisters a `webOn` URL,
  so after a program switch without reboot the old binding wins and the new
  program serves it under its own meaning of that number.
  The firmware has **7 slots** (`TC_MAX_WEB_HANDLERS`); a `webOn(8)` is dropped
  without a word. A new endpoint goes on `/pwr` as a query parameter.

## HTTP API (`/pwr`)

- `/pwr`, all programs, always (the telemetry switch is for MQTT only):
  `{"sml1".."sml6","power2"[,"cpwr"]}` — `smlPwrJson()` in `sml_descriptor.tc`,
  sent raw via `webRawMode`/`webRawWrite` as `application/json` with
  `Content-Length`. `webSend` would declare `text/html`.
- `/pwr?v=a;b;c` — `smlVars()` in `sml_descriptor.tc`, chunked JSON collected
  in ~240-char chunks. `sml`, `smlN`/`sml[N]`, `power2`, `cpwr` everywhere;
  the chart names come from `sml_chart_var()` in `sml_chart_common.tc`, hooked
  in with `#define SML_CHART`. `dval`..`yval2` answer the energy since the
  zero point (the main page values), not the zero point. `all`, `sml` are
  shorthands. Keys are sanitised (letters, digits, `_[]`) before being echoed.
- Without "3 phases" `sml4` = total power, `sml5`/`sml6` = 0 (`sml_phase()`).

## Data

- `.pvs` is **PV3, name-keyed**: a new persist var starts at 0, old data stays;
  renaming or retyping a var loses it. `TC_MAX_PERSIST` = 64 (ESP8266) /
  128 (ESP32).
- One-time `.bin` import (read, stored in the `.pvs`, file deleted), raw
  float32: `sml_chart.bin` 1965 (s4h 481, s24h 1441, dcon 31, mcon 12)
  / +4 baselines = 1969 / +wval + wcon 53 = 2023; `sml_chart_pv.bin` 43 / 46
  / 100 the same way. Each block only if present.
- Weeks are ISO (`tasm_cw`), index 0 = week 1, new week on Monday 00:00
  (`tasm_wday == 2`). `sml_wval == 0` at first start falls back to `sml_dval`.
- Editor (`docs/pvs_editor/tinyc_chart_editor.html`) and converter
  (`docs/converter/script_charts_to_tinyc_pvs.html`) share their chart code —
  fix both. Up to 60 values are drawn as bars (days, months, 53 weeks).

## TinyC pitfalls (each one cost a debugging round)

- `sprintfAppend` needs ≥ 3 args — use `strcat` when there is nothing to format.
- The `sprintf %s` family cuts at 255 chars → `strcat` for long strings.
- A `%` inside a `sprintf` format is eaten → split and `strcat` that part.
- Array packing follows the **declared parameter type**: a `byte[]` passed to a
  `char[]` parameter is misread silently. Keep types aligned.
- `fileGetStr` needs a literal delimiter → one call per key.
- `WebChart`: title/unit are **literals**; `interval` is whole **minutes**;
  `pos` is the **next** write position (newest = `pos-1`). For a sub-minute
  axis, rewrite `dt` column 0 **and** `o.hAxis` in `WebChartJS` — the firmware
  pins `viewWindow` from the original x values. `int[]` cannot feed a chart;
  `int16[]` / `byte[]` can.
- `WebPage()` = Tasmota root page, once per load. `WebCall()` = every refresh.
  `WebUI()` = `/tc_ui`. A skipped callback renders nothing — check `WebSkip`.
- `confirm()` on a page with the 2 s refresh blocks JS; the queued `la()` then
  aborts the request. Send the write with its own `fetch()`, or avoid the dialog.
- `pr(0)` stops the `/tc_ui` refresh — only on the dedicated chart page.
- `WebChartJS`: the firmware keeps at most **383 chars** (`TC_BUF(js, 384)`)
  and cuts the rest silently — the short-term chart snippet is 367. A cut
  either breaks the syntax (default chart drawn) or throws at runtime.
- **RAM:** the whole `.tcb` stays in RAM and string constants are copied once
  more, so each text byte costs ~2 bytes. Identical literals are deduplicated —
  reuse them. Keep UI text short; explanations go to the help page.
- Every function call takes a 1 KB frame; a failed frame allocation is
  reported as "Stack overflow".
- Functions are collected in a first pass, so calling one defined further down
  works. A call to a function that only some programs have must sit behind
  `#ifdef` (the preprocessor knows `#ifdef/#ifndef/#else/#endif`).
- Passing a string literal to a `char[]` parameter that is then streamed
  rendered empty on firmware before 2026-07-28 — copy into a buffer first.

## CT002 emulator (`ct002_common.tc`)

Control loop ported from AstraMeter (GPL-3.0; credit on page 4),
`src/astrameter/ct002/balancer.py`. Constants are AstraMeter's defaults.

- `ctCtrl()` per phase bucket: grid predictor (credits reported battery output
  before the meter shows it) → import trim (fixed, gate 0..120 W, 6 fresh
  samples) → oscillation damper (sign reversals) → **absolute** pace clamp.
  Never pace against the last reported value — that is a windup oscillator.
- A battery reporting phase `0` is diagnosing its phase: send it the **raw**
  meter, no control, no offset (AstraMeter `_resolve_target`). When it leaves
  phase `0`, `ctCtrlReset()` re-seeds all four loops (AstraMeter #653) — Venus
  FW 1.50 repeats the sweep about every 35 min.
- `ctShare()` splits per bucket. Concentration and rotation apply only to the
  B2500 family (`HMA`/`HMJ`/`HMK`, 80 W start floor); Venus and Jupiter always
  share. Batteries on different phases never form a pool — with a netting meter
  they belong on phase D. With saturation detection on, a saturated peer leaves
  the share and the balance average (AstraMeter #679, ceilings there).
- Last AstraMeter comparison: `934b95b` (2026-10-07). Start the next one there.
- Source files may be CRLF or LF per file (Git `autocrlf`); patch scripts must
  keep each file's ending.

## Other facts

- Shelly emulation decimals follow a real Pro 3EM: phases `%.1f`, total `%.3f`.
- SML descriptor value line: `dp & 0x0F` = decimals, `dp & 0x10` = immediate
  MQTT (`tele/SENSOR` on every telegram). The median filter is `smlf` in the
  meter header, not this bit.
- Device diagnostics over HTTP: `/cs?c2=0` (log), `/ufsd?download=/path`,
  `/?m=1`, `/tc_ui?p=0&m=1`, `/tc_api?cmd=status`, `/cm?cmnd=Status%2012`
  (crash dump). Read the log before theorising.
