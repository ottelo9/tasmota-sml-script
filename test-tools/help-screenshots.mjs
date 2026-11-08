// Screenshots for the help pages (docs/<topic>/img/), taken from a test device.
//   node test-tools/help-screenshots.mjs [topic] [file.png ...]
// Needs Node 22+ and Chrome; the device UI must be set to English and run the
// program named in the group. Numbered red marks are added in the page, so the
// pictures can be redone after a UI change. DEVICE=http://ip overrides the address.
import { spawn } from 'child_process';
import { writeFileSync, mkdirSync, mkdtempSync, rmSync } from 'fs';
import { join, dirname } from 'path';
import { tmpdir } from 'os';
import { fileURLToPath } from 'url';

const DEV = process.env.DEVICE || 'http://192.168.178.132';
const CHROME = 'C:/Program Files/Google/Chrome/Application/chrome.exe';
const DOCS = join(dirname(fileURLToPath(import.meta.url)), '..', 'docs');
const PORT = 9333;
const sleep = ms => new Promise(r => setTimeout(r, ms));

// A mark is [what, number]: what = exact text, "abc*" = starts with,
// "css:selector@n" = n-th match. markX = its fixed page x, in a free margin.
// clip is evaluated in the page; find() and box() are available there.
const chartClip = y => `({ x: 24, y: ${y}, width: 456, height: 558 })`;
const GROUPS = {
  sml: [   // program in slot 0: sml_chart, slot 1: Zähler-PIN, slot 2: FTP-Backup
    { file: 'main.png', url: '/', wait: 4500, markX: 56,
      marks: [['Power', 1], ['L1 / L2 / L3', 2], ['Import day', 3], ['Charts', 4]],
      clip: `(() => { const r = find('Power').closest('fieldset').getBoundingClientRect(); return { x: r.left - 30, y: r.top - 12, width: r.width + 38, height: r.height + 20 }; })()` },
    { file: 'settings.png', url: '/tc_ui?p=0', wait: 3500, markX: 466,
      marks: [['Language', 1], ['Power saving off', 2], ['Central European time (summer time)', 3],
              ['Meter active', 4], ['3 phases', 5], ['Import meter', 6], ['SML display', 7], ['SML Filter', 8],
              ['Descriptor', 9], ['Meter', 10], ['RX', 11], ['TX', 12]],
      clip: `(() => { const a = find('\\u26A1 Settings').getBoundingClientRect(); const b = find('TX').getBoundingClientRect(); return { x: 24, y: a.top - 16, width: 472, height: b.bottom - a.top + 100 }; })()` },
    { file: 'settings2.png', url: '/tc_ui?p=0', wait: 3500, markX: 466,
      marks: [['Feed-in', 1], ['PV switch', 2], ['PwrAvg (MQTT)', 3], ['HTTP API', 4], ['Active', 5],
              ['Short-term', 6], ['Main Charts', 7], ['\uD83D\uDD22 Reset', 8], ['Save', 9], ['\uD83D\uDCBE CSV', 10]],
      clip: `(() => { const a = find('\\u2600\\uFE0F PV').getBoundingClientRect(); const b = find('\\uD83D\\uDCBE CSV').getBoundingClientRect(); return { x: 24, y: a.top - 14 + scrollY, width: 472, height: b.bottom - a.top + 30 }; })()` },
    { file: 'charts_power.png', url: '/tc_ui?p=2', wait: 8000, marks: [], clip: chartClip(215) },
    { file: 'charts_days.png', url: '/tc_ui?p=2', wait: 8000, marks: [], clip: chartClip(775) },
    { file: 'charts_weeks.png', url: '/tc_ui?p=2', wait: 8000, marks: [], clip: chartClip(1335) },
    { file: 'console.png', url: '/tc', wait: 4000, markX: 490,
      marks: [['TinyC VM Slots', 1], ['css:fieldset:nth-of-type(3) select@0', 2], ['css:fieldset:nth-of-type(3) select@1', 3], ['Download & Load', 4]],
      clip: `(() => { const f = document.querySelectorAll('fieldset'); const a = f[0].getBoundingClientRect(), b = f[2].getBoundingClientRect(); return { x: 12, y: a.top - 10, width: 504, height: b.bottom - a.top + 12 }; })()` },
    { file: 'pin.png', url: '/', wait: 4500, markX: 56,
      marks: [['\uD83D\uDD13 PIN', 1], ['Zähler-PIN*', 2]],
      clip: `(() => { const r = find('\\uD83D\\uDD13 PIN').closest('fieldset').getBoundingClientRect(); return { x: r.left - 30, y: r.top - 12, width: r.width + 38, height: r.height + 20 }; })()` },
    { file: 'ftp.png', url: '/', wait: 4500, markX: 56,
      marks: [['Backup', 1], ['\uD83D\uDD52*', 2]],
      clip: `(() => { const r = find('Backup').closest('fieldset').getBoundingClientRect(); return { x: r.left - 30, y: r.top - 12, width: r.width + 38, height: r.height + 20 }; })()` },
  ],
  // main.png and marstek.png of ct002 come from a real emulator with a battery,
  // MACs and login painted over by hand: not made here, so a run cannot expose them.
  ct002: [   // program in slot 0: sml_chart_ct002
    { file: 'ct.png', url: '/tc_ui?p=4', wait: 3500, markX: 460,
      marks: [['CT MAC*', 1], ['Type', 2], ['Port', 3], ['RSSI [dBm]', 4], ['Timeout [s]', 5], ['UDP rx*', 6]],
      clip: `(() => { const a = find('\\uD83D\\uDD0C CT').getBoundingClientRect(); const b = find('UDP rx*').getBoundingClientRect(); return { x: 24, y: a.top - 12 + scrollY, width: 472, height: b.bottom - a.top + 24 }; })()` },
    { file: 'battery.png', url: '/tc_ui?p=4', wait: 3500, markX: 460,
      marks: [['Offset [W]', 1], ['Active control', 2], ['Trim [W]', 3], ['Step [W]', 4], ['Min DC [W]', 5], ['Max DC [W]', 6]],
      clip: `(() => { const a = find('\\uD83D\\uDD0B Battery').getBoundingClientRect(); const b = find('Max DC [W]').getBoundingClientRect(); return { x: 24, y: a.top - 12 + scrollY, width: 472, height: b.bottom - a.top + 34 }; })()` },
    { file: 'multi.png', url: '/tc_ui?p=4', wait: 3500, markX: 460,
      marks: [['Share the load', 1], ['Saturation', 2]],
      clip: `(() => { const a = find('\\u2696\\uFE0F Several batteries').getBoundingClientRect(); const b = find('Saturation').getBoundingClientRect(); return { x: 24, y: a.top - 12 + scrollY, width: 472, height: b.bottom - a.top + 28 }; })()` },
  ],
  eco_shelly: [   // program in slot 0: sml_chart_eco_shelly, mode Shelly Pro 3EM
    { file: 'main.png', url: '/', wait: 4500, markX: 40,
      marks: [['Emulation', 1], ['To battery', 2]],
      clip: `(() => { const r = find('Power').closest('fieldset').getBoundingClientRect(); return { x: r.left - 30, y: r.top - 12, width: r.width + 38, height: r.height + 20 }; })()` },
    { file: 'mode.png', url: '/tc_ui?p=0', wait: 3500, markX: 460,
      marks: [['Mode', 1], ['UDP port', 2]],
      clip: `(() => { const a = find('\\uD83D\\uDD0C Emulation').getBoundingClientRect(); const b = find('UDP port').getBoundingClientRect(); return { x: 24, y: a.top - 12 + scrollY, width: 472, height: b.bottom - a.top + 56 }; })()` },
    { file: 'battery.png', url: '/tc_ui?p=0', wait: 3500, markX: 460,
      marks: [['Offset [W]', 1], ['Regulator tweak', 2], ['Update rate [s]', 3], ['Force sending', 4]],
      clip: `(() => { const a = find('\\uD83D\\uDD0B Battery').getBoundingClientRect(); const b = find('Force sending').getBoundingClientRect(); return { x: 24, y: a.top - 12 + scrollY, width: 472, height: b.bottom - a.top + 24 }; })()` },
  ],
};

const helpers = `
window.find = t => {
  if (t.startsWith('css:')) { const [s, n] = t.slice(4).split('@'); return document.querySelectorAll(s)[+n || 0] || null; }
  let best = null; const pre = t.endsWith('*') ? t.slice(0, -1) : null;
  for (const e of document.querySelectorAll('body *')) {
    if (['SCRIPT', 'STYLE', 'SELECT', 'OPTION'].includes(e.tagName)) continue;
    const s = (e.textContent || '').replace(/\\s+/g, ' ').trim();
    if (pre ? s.startsWith(pre) : s === t) { const r = e.getBoundingClientRect(), b = best && best.getBoundingClientRect();
      if (r.width && r.height && (!best || r.width * r.height < b.width * b.height)) best = e; } }
  return best; };
window.mark = (t, n, px) => { const e = find(t); if (!e) return t; const r = e.getBoundingClientRect();
  const d = document.createElement('span'); d.textContent = n;
  d.style.cssText = 'position:absolute;display:block;margin:0;padding:0;box-sizing:content-box;z-index:9999;width:18px;height:18px;border-radius:50%;background:#e0243a;color:#fff;font:700 11px/18px Arial,sans-serif;text-align:center;box-shadow:0 0 0 1px #fff;left:' + (px != null ? px : r.left + scrollX - 22) + 'px;top:' + (r.top + scrollY + r.height / 2 - 9) + 'px';
  document.body.appendChild(d); return ''; };
`;

const [topic, ...only] = process.argv.slice(2);
const profile = mkdtempSync(join(tmpdir(), 'help-shots-'));
const proc = spawn(CHROME, ['--headless=new', '--disable-gpu', '--hide-scrollbars', '--remote-debugging-port=' + PORT,
  '--remote-allow-origins=*', '--user-data-dir=' + profile, '--window-size=520,1700', 'about:blank'], { stdio: 'ignore' });
try {
  let target;
  for (let i = 0; i < 80 && !target; i++) {
    await sleep(250);
    try { target = (await (await fetch(`http://127.0.0.1:${PORT}/json/list`)).json()).find(t => t.type === 'page'); } catch {}
  }
  if (!target) throw new Error('Chrome not reachable');
  const ws = new WebSocket(target.webSocketDebuggerUrl);
  await new Promise(r => ws.onopen = r);
  let id = 0; const pending = new Map();
  ws.onmessage = m => { const d = JSON.parse(m.data); if (d.id && pending.has(d.id)) { pending.get(d.id)(d); pending.delete(d.id); } };
  const send = (method, params = {}) => new Promise(r => { const i = ++id; pending.set(i, r); ws.send(JSON.stringify({ id: i, method, params })); });
  const ev = async expr => {
    const d = await send('Runtime.evaluate', { expression: expr, returnByValue: true });
    if (d.result?.exceptionDetails) throw new Error(d.result.exceptionDetails.exception?.description);
    return d.result?.result?.value;
  };
  await send('Page.enable');
  for (const [name, shots] of Object.entries(GROUPS)) {
    if (topic && topic !== name) continue;
    for (const s of shots) {
      if (only.length && !only.includes(s.file)) continue;
      await send('Page.navigate', { url: DEV + s.url });
      await sleep(s.wait);
      await ev(helpers);
      for (const [what, n] of s.marks) {
        const miss = await ev(`mark(${JSON.stringify(what)}, ${n}, ${s.markX})`);
        if (miss) console.log('NOT FOUND', s.file, miss);
      }
      const clip = await ev(s.clip);
      const r = await send('Page.captureScreenshot', { format: 'png', captureBeyondViewport: true, clip: { ...clip, scale: 1 } });
      const png = Buffer.from(r.result.data, 'base64');
      mkdirSync(join(DOCS, name, 'img'), { recursive: true });
      writeFileSync(join(DOCS, name, 'img', s.file), png);
      console.log(name + '/' + s.file, png.length, 'B', Math.round(clip.width) + 'x' + Math.round(clip.height));
    }
  }
  ws.close();
} finally {
  proc.kill();
  await sleep(500);
  try { rmSync(profile, { recursive: true, force: true }); } catch {}
}
