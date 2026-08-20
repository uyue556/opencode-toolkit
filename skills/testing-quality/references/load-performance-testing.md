# Load & Performance Testing

Using k6 to validate system performance, find bottlenecks, meet SLAs, and catch
regressions. Merged from: `k6-load-testing`.

## When to use

- Load-test HTTP APIs, WebSocket endpoints, or browser scenarios.
- Set up performance regression tests in CI/CD.
- Analyze behavior under various load conditions; compare code changes.
- Validate SLA requirements and performance budgets.

## Basic script

```javascript
import http from 'k6/http';
import { check, sleep } from 'k6';

export const options = {
  vus: 10,
  duration: '30s',
};

export default function () {
  const res = http.get('https://httpbin.test.k6.io/get');
  check(res, {
    'status is 200': (r) => r.status === 200,
    'response time < 500ms': (r) => r.timings.duration < 500,
  });
  sleep(1);
}
```

Run: `k6 run simple-test.js`.

## Test types

| Type | Use case | Configuration |
|------|----------|---------------|
| Smoke | Verify basic functionality | Low VUs (1-5), short duration |
| Load | Normal expected load | Target VUs from traffic data |
| Stress | Find the breaking point | Ramp beyond capacity |
| Spike | Sudden traffic spikes | Rapid increase/decrease |
| Soak | Long-term stability | Extended duration |

## Options & thresholds (SLA)

```javascript
export const options = {
  vus: 100,
  duration: '5m',
  stages: [
    { duration: '30s', target: 20 },   // ramp up
    { duration: '1m', target: 100 },   // hold
    { duration: '30s', target: 0 },    // ramp down
  ],
  thresholds: {
    http_req_duration: ['p(95)<500', 'p(99)<1000', 'avg<200'],
    http_req_failed: ['rate<0.01'],
    http_reqs: ['rate>100'],
  },
};
```

Start relaxed, tighten based on historical data. Use `p(90)/p(95)/p(99)` for
percentiles.

## HTTP testing & request chaining

```javascript
export default function () {
  // Login, extract token
  const loginRes = http.post('https://api.example.com/login',
    JSON.stringify({ email: 'test@example.com', password: 'password123' }));
  const token = loginRes.json('access_token');

  // Use token in subsequent requests
  const res = http.get('https://api.example.com/profile', {
    headers: { 'Authorization': `Bearer ${token}` },
  });
  check(res, { 'profile loaded': (r) => r.status === 200 });
}
```

## Parameterized data (CSV/JSON)

```javascript
import { SharedArray } from 'k6/data';

// Load once, share across VUs (avoids OOM)
const users = new SharedArray('users', function () {
  return open('./users.csv').split('\n').slice(1).map(line => {
    const [email, password] = line.split(',');
    return { email, password };
  });
});

export default function () {
  const user = users[__VU % users.length];
  const res = http.post('https://api.example.com/login',
    JSON.stringify({ email: user.email, password: user.password }));
  check(res, { 'login ok': (r) => r.status === 200 });
}
```

## Browser load testing

```javascript
import { browser } from 'k6/browser';

export const options = {
  scenarios: {
    browser_test: {
      executor: 'constant-vus',
      vus: 5,
      duration: '30s',
      browser: { type: 'chromium' },
    },
  },
};

export default async function () {
  const page = await browser.newPage();
  try {
    await page.goto('https://example.com');
    await page.click('button[data-testid="submit"]');
    await page.waitForSelector('.success-message');
  } finally {
    await page.close();
  }
}
```

Install browser support: `k6 install chromium`.

## WebSocket testing

```javascript
import ws from 'k6/ws';

export default function () {
  ws.connect('wss://echo.websocket.org', {}, function (socket) {
    socket.on('open', () => socket.send('Hello'));
    socket.on('message', (data) => console.log(data));
    socket.setInterval(() => socket.send('ping'), 1000);
    socket.setTimeout(() => socket.close(), 5000);
  });
}
```

## Custom metrics

```javascript
import { Counter, Trend, Rate, Gauge } from 'k6/metrics';

const myCounter = new Counter('api_calls_total');
const responseTime = new Trend('response_time');
const errorRate = new Rate('error_rate');

export default function () {
  const res = http.get('https://api.example.com/data');
  myCounter.add(1);
  responseTime.add(res.timings.duration);
  errorRate.add(res.status !== 200);
  // Tag requests for granular analysis
  http.get('https://api.example.com/users', { tags: { endpoint: 'users' } });
}
```

## CI/CD integration

GitHub Actions:

```yaml
- name: Setup k6
  uses: grafana/k6-action@v0.2.0
- name: Run load test
  env:
    API_TOKEN: ${{ secrets.API_TOKEN }}
  run: k6 run --out json=results.json load-test.js
- name: Upload results
  uses: actions/upload-artifact@v4
  with: { name: k6-results, path: results.json }
```

GitLab CI: image `grafana/k6:latest`, run `k6 run load-test.js`, attach `results.json`
artifact, expose `results.xml` as JUnit report.

## Result output & analysis

```bash
k6 run load-test.js                          # text summary
k6 run --out json=results.json load-test.js  # JSON for parsing
k6 run --out influxdb=http://localhost:8086/k6 load-test.js   # + Grafana
k6 run --out prometheus=localhost:9090/k6 load-test.js        # Prometheus remote write
```

| Metric | Good | Warning | Bad |
|--------|------|---------|-----|
| http_req_duration (p95) | < 300ms | 300-500ms | > 500ms |
| http_req_failed | < 0.1% | 0.1-1% | > 1% |
| http_reqs | meeting target | near limit | at limit |
| vus | stable | gradual increase | unexpected spike |

## Best practices

- Start with a smoke test (1-5 VUs) before scaling.
- Parameterize with realistic data and behaviors.
- Set meaningful thresholds matching your SLA.
- Include ramp-up time in stages (warm-up).
- Monitor external/downstream dependencies too.
- Use tags for granular analysis.
- Keep one test file per scenario.

## Common pitfalls

| Problem | Solution |
|---------|----------|
| Passes locally, fails in CI | Match CI resources/network conditions to local |
| Inconsistent runs | Check external deps, random data, test-data pollution |
| k6 OOM | `SharedArray` for large data, reduce VUs, `--max-memory` |
| Thresholds too strict | Relax first, tighten from historical data |
