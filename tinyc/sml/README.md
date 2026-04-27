Mini-Scripter-Compatible SML Descriptors
========================================

These four `.tas` descriptors were hand-adapted from the upstream
`ottelo9/tasmota-sml-script` versions so they compile with the TinyC
mini-scripter subset (see `xdrv_124_tinyc_vm.h`, `tc_mscr_compile()`).

The subset now (v1.3.16+) covers every construct the upstream M-Bus wake
descriptors actually need. Remaining transformations vs. upstream:

  - `=#name` subroutines           → **inlined at the single call site**
                                      (no call/return in the subset)
  - `print …` diagnostic output    → **dropped** (soft-skipped by the
                                      compiler anyway since v1.3.15)
  - `mins` / `upsecs` / `tstamp`   → **replaced with an `lnv` tick counter**
                                      (the `>S` block fires at 1 Hz anyway)
  - `sb(tstamp …)` byte slice      → **dropped** (was redundant with adjacent
                                      branch in the Itron source)

Constructs kept verbatim (all supported natively by the subset):

  - `for lnvN <start> <end> <step> … next`   (v1.3.16)
  - `spin(pin, v)` / `spinm(pin, mode)`      (v1.3.14)
  - `sml(meter, 0|1, …)`, `delay(ms)`,
    `if / endif`, `switch / case / ends`,
    `lnv0..lnv9`, `+= -= *= /=`, arithmetic/compare ops

Load them via TinyC's `smlScripterLoad("/path/to/descriptor.tas")`. On builds
with `-DTINYC_NO_SCRIPTER`, they keep the M-Bus / IR-read-head wake-up
handshake working without the full Scripter subsystem.

Files
-----

  - `allmess_wasseruhr.tas`      M-Bus water meter  — once-per-hour read
  - `engelmann_sensostar.tas`    M-Bus heat meter   — every ~45 min read
  - `itron_cf_echo_ii.tas`       M-Bus heat meter   — once-per-hour read
  - `easymeter_q3a.tas`          3-phase IR reader  — 60 s GPIO duty cycle

Notes
-----

- `TC_MSCR_BC_MAX = 512 B` per section (`>F`, `>S`). The for-loop preamble
  pattern (`for lnv1 1 53 1 / sml(1 1 "55…") / next`) compiles to ~60 B,
  leaving plenty of headroom. A manually-unrolled equivalent (5 sequential
  `sml()` calls with 128 B each) would compile to ~1100 B and overflow —
  that is why the loop is used rather than decomposed.

- `TC_MSCR_HEX_MAX = 128 B` caps any single `sml(m, 1, "HEX…")` payload.
  The loop-per-iteration payload of 10 B (20 hex chars) is well under.

- The `lnv` counter approach means the first fire is N ticks after boot,
  not phase-locked to wall-clock minute. For M-Bus heat/water meters this
  is irrelevant — what matters is the repeat interval.

- Pin placeholders like `%0txpin%` are substituted with numeric pin IDs
  by `smlApplyPins()` before compile. The EasyMeter Q3A example uses a
  literal `15` for self-contained testability; production descriptors
  should keep the placeholder.
