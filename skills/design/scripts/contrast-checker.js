// WCAG contrast checker — pure functions, no dependencies.
// Adapted from the accessibility playbook (source: design/accessibility-* skills).
//
// Usage:
//   node contrast-checker.js '#1B2A49' '#F9F6F0'          -> prints ratio + pass/fail for AA/AAA
//   require('./contrast-checker.js').calculateContrast('#111','#fff')
//
// Ratios: AA normal 4.5 / large 3.0 ; AAA normal 7.0 / large 4.5.

function parseColor(input) {
  let s = String(input).trim();
  if (s.startsWith('#')) s = s.slice(1);
  if (s.length === 3) s = s.split('').map((c) => c + c).join('');
  const n = parseInt(s, 16);
  if (Number.isNaN(n) || s.length !== 6) throw new Error(`Unsupported color: ${input} (use #RRGGBB)`);
  return [(n >> 16) & 255, (n >> 8) & 255, n & 255];
}

function relativeLuminance(rgb) {
  const [r, g, b] = rgb.map((v) => {
    const c = v / 255;
    return c <= 0.03928 ? c / 12.92 : Math.pow((c + 0.055) / 1.055, 2.4);
  });
  return 0.2126 * r + 0.7152 * g + 0.0722 * b;
}

function calculateContrast(fg, bg) {
  const l1 = relativeLuminance(parseColor(fg));
  const l2 = relativeLuminance(parseColor(bg));
  const lighter = Math.max(l1, l2);
  const darker = Math.min(l1, l2);
  return (lighter + 0.05) / (darker + 0.05);
}

const LEVELS = {
  AA: { normal: 4.5, large: 3.0 },
  AAA: { normal: 7.0, large: 4.5 },
};

function check(fg, bg, isLarge = false) {
  const ratio = calculateContrast(fg, bg);
  const results = {};
  for (const [level, req] of Object.entries(LEVELS)) {
    const min = isLarge ? req.large : req.normal;
    results[level] = ratio >= min;
  }
  return { ratio: Number(ratio.toFixed(2)), pass: results };
}

if (require.main === module) {
  const [fg, bg, isLargeArg] = process.argv.slice(2);
  if (!fg || !bg) {
    console.error('Usage: node contrast-checker.js <foreground> <background> [large]');
    process.exit(1);
  }
  const { ratio, pass } = check(fg, bg, isLargeArg === 'large');
  console.log(`Contrast ${fg} on ${bg} = ${ratio}:1`);
  for (const [level, ok] of Object.entries(pass)) {
    console.log(`  WCAG ${level}: ${ok ? 'PASS' : 'FAIL'}`);
  }
  process.exit(pass.AA ? 0 : 2);
}

module.exports = { calculateContrast, check, relativeLuminance, parseColor };
