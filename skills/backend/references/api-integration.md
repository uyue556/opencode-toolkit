# API Integration: Webhooks, Events, Composition

Integrating two or more systems reliably requires handling async delivery,
failures, and retries. Design for the fact that events can arrive out of order,
duplicated, or never.

## Webhook design (outbound — your system → subscriber)

```http
POST {subscriber_url}
Content-Type: application/json
X-Webhook-Signature: hmac-sha256=<sig>
X-Webhook-Event: order.created
X-Webhook-Delivery: <uuid>
X-Webhook-Timestamp: <unix-epoch>
```

Payload envelope:

```json
{
  "event": "order.created",
  "delivery_id": "uuid",
  "created_at": "2024-01-01T00:00:00Z",
  "data": { "order_id": "...", "amount": 99.99 }
}
```

Design points:
- Include a unique delivery ID so subscribers can dedupe.
- Sign the payload with an HMAC of a shared secret; include the signature header.
- Register/manage subscriber endpoints via an API: register URL + events,
  list, unsubscribe, fire a test event, and expose delivery history so operators
  can replay failed deliveries.

## Webhook receiver (inbound — you consume events)

- **Verify signature first**, using the provider SDK if available
  (e.g. `stripe.webhooks.constructEvent`) or raw HMAC with a **timing-safe
  comparison** (`crypto.timingSafeEqual` in Node, `hmac.compare_digest` in
  Python). Preserve the **raw body** — JSON body parsers break signature
  validation.
- **Respond fast**: return `2xx` within ~200ms-5s, BEFORE doing expensive work
  (DB writes, external calls). Providers retry on timeout, causing duplicates.
- **Be idempotent**: store event IDs; skip processing events already handled.
  Providers don't guarantee single delivery.
- **Validate the payload** as untrusted input (schema validation).
- On processing failure, return an error and let the provider retry, or ack and
  route to a dead-letter/retry queue.
- **Don't trust the payload alone for money flows** — re-fetch status from the
  provider API server-side.

Node HMAC example:

```javascript
import crypto from 'crypto';
function verifySignature(rawBody, signature) {
  const expected = crypto.createHmac('sha256', process.env.WEBHOOK_SECRET)
    .update(rawBody).digest('hex');
  return crypto.timingSafeEqual(
    Buffer.from(`sha256=${expected}`), Buffer.from(signature));
}
```

## API chaining / composition

When one operation depends on the results of previous API calls (token → user
→ order → payment):

- Handle failure at each step independently.
- Use idempotency keys on all state-changing calls.
- Retry with exponential backoff + jitter (base ~1s, max ~60s).
- Use a circuit breaker (open after ~5 failures in 10s) around external calls.

## Event-driven architecture

Event schema (CloudEvents 1.0):

```json
{
  "specversion": "1.0",
  "type": "com.example.order.created",
  "source": "/orders-service",
  "id": "uuid",
  "time": "2024-01-01T00:00:00Z",
  "datacontenttype": "application/json",
  "data": { "order_id": "...", "amount": 99.99 }
}
```

Topics/queues design: name by past-tense fact (`orders.created`), document
producers/consumers per topic, and set retention policy per topic. Carry a
correlation ID across all inter-service calls.

### Saga pattern (distributed transactions)

For multi-service operations that can't be atomic:

```
choreography:
1. orders-svc emits order.created
2. inventory-svc reserves stock → inventory.reserved
3. payments-svc charges → payment.completed
4. orders-svc emits order.confirmed
On failure at 3:
← payment.failed → inventory-svc releases stock (compensating)
← order.cancelled
```

Each step must have a compensating action. Prefer choreography for simple flows,
orchestration (a dedicated coordinator) for complex ones.

### Outbox pattern (reliable event publishing)

Write to DB + outbox in the same transaction; a separate publisher polls the
outbox and sends to the broker — guarantees events are published iff the
transaction committed.

```sql
CREATE TABLE outbox_events (
  id UUID PRIMARY KEY,
  aggregate_type VARCHAR,
  aggregate_id UUID,
  event_type VARCHAR,
  payload JSONB,
  created_at TIMESTAMP,
  published_at TIMESTAMP NULL
);
```

## Integration checklist

- [ ] Idempotency keys on all state-changing calls
- [ ] Retry with exponential backoff + jitter
- [ ] Circuit breaker on external dependencies
- [ ] Dead-letter queue for unprocessable events
- [ ] Webhook delivery logging + manual replay endpoint
- [ ] Schema versioning on all events (backward/forward compatible)
- [ ] Correlation IDs on all inter-service calls
- [ ] Signature verification on inbound webhooks

## Third-party API integration patterns (from provider skills)

Common patterns distilled from Stripe/PayPal/Twilio/WhatsApp/Slack/Algolia/
Salesforce/HubSpot/Plaid integration guides:

- **OAuth for user-scoped APIs** (Stripe Connect, HubSpot, Slack, Salesforce):
  authorization code flow → store refresh token encrypted → refresh on 401
  before retrying; handle token expiry gracefully.
- **API keys for server-to-server**: rotate keys, prefix by environment
  (`sk_test_` vs `sk_live_`), never ship in client code.
- **Rate limits**: read `Retry-After`, back off, and queue work during spikes.
- **Provider webhooks** are the source of truth for async state (payment
  succeeded, message delivered, subscription changed). Build handlers that are
  idempotent and fast (see above).
- **Sandbox vs live separation**: test credentials must fail in production;
  magic test values trigger deterministic success/failure.
- **Always use official SDKs** for signature verification and API shapes; don't
  reimplement HMAC/crypto unless necessary.
- **Search/platform providers** (Algolia, Elasticsearch, etc.): sync data via
  index jobs or change-data-capture, restrict API keys to the subset of indexes
  and operations the client needs.

## Sources

- `api-integration` (event-driven/webhooks), `payment-integration`,
  `stripe-integration`, `paypal-integration`, `twilio-communications`,
  `whatsapp-cloud-api`, `slack-bot-builder`, `algolia-search`,
  `hubspot-integration`, `plaid-fintech`, `salesforce-development`,
  `telegram-bot-builder`, `backend-architect`.