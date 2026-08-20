# Payments: Stripe, PayPal & General Payment Integration

Payment integration is security-critical. Follow the PCI rules, use provider
SDKs, and make every flow idempotent and testable in sandbox mode.

## Core approach

1. Security first — never log sensitive card data.
2. Idempotency for all payment operations.
3. Handle all edge cases (failed payments, disputes, refunds).
4. Test mode first, with a clear migration path to production.
5. Comprehensive webhook handling for async events.
6. Always use official SDKs. Never handle raw card numbers on your server.

## Critical requirements

### Webhook security & idempotency

- **Signature verification**: ALWAYS verify webhook signatures using the official
  SDK (`stripe.Webhook.construct_event`), or raw HMAC with timing-safe compare.
- **Raw body preservation**: never let a JSON body parser touch the body before
  verification — it breaks signature validation.
- **Idempotent handlers**: store event IDs in your DB; check before processing.
  Providers retry and don't guarantee single delivery.
- **Quick response**: return 2xx within ~200ms, before expensive operations.
  Timeouts trigger retries and duplicate processing.
- **Server validation**: re-fetch payment status from the provider API. Never
  trust the webhook payload or client response alone.

### PCI compliance essentials

- **Never handle raw cards**: use tokenization APIs (Stripe Elements, PayPal SDK)
  that collect card data in the provider's iframe. Never store, process, or
  transmit raw card numbers.
- **Server-side validation**: all verification happens server-side via direct
  calls to the payment provider.
- **Environment separation**: test credentials must fail in production.
  Misconfigured gateways commonly accept test cards on live sites.

## Stripe quick patterns

### Checkout Session (hosted) — fastest, minimal PCI burden

```python
session = stripe.checkout.Session.create(
    payment_method_types=['card'],
    line_items=[{ 'price_data': { 'currency': 'usd',
        'product_data': {'name': 'Premium'}, 'unit_amount': 2000 },
        'quantity': 1 }],
    mode='subscription',  # or 'payment'
    success_url='https://yourdomain.com/success?session_id={CHECKOUT_SESSION_ID}',
    cancel_url='https://yourdomain.com/cancel',
)
```

### Payment Intents (custom UI)

Create intent server-side, send `client_secret` to the frontend, confirm with
Stripe.js. Full UI control, higher PCI burden.

### Subscriptions

- Components: Product → Price → Subscription → Invoice.
- Create with `payment_behavior='default_incomplete'` and handle the first
  invoice's PaymentIntent client_secret for upfront card confirmation.
- Provide a Customer Portal for self-service plan management.

### Webhook events to handle

`payment_intent.succeeded` / `.payment_failed`, `customer.subscription.updated`
/ `.deleted`, `charge.refunded`, `invoice.payment_succeeded`. Link Stripe
objects to your DB via `metadata` (order_id, user_id).

### Refunds & disputes

- Refunds: full or partial (`amount`), reason (`duplicate`, `fraudulent`,
  `requested_by_customer`).
- Disputes: respond with evidence (customer info, shipping docs, communication).

### Testing

- Test keys + magic cards: `4242424242424242` (success), `4000000000000002`
  (declined), `4000000000009995` (insufficient funds), `4000002500003155`
  (3-D Secure).
- Use test payment methods (`pm_card_visa`) to confirm PaymentIntents.

## PayPal quick patterns

- Products: PayPal Checkout (smart buttons / Orders v2), Advanced Card
  Processing, Pay Later.
- Backend pattern: create order server-side → capture on approval → verify.
- IPN (Instant Payment Notification): verify the IPN by POSTing it back to
  PayPal's endpoint (with `cmd=_notify-validate`); only then process. Handle
  webhook/IPN idempotently.
- Recurring billing via subscription plans / billing agreements.

## Common failures (from production retrospectives)

- Processor collapse during traffic spike → webhook queue backups, revenue loss.
- Out-of-order webhooks with no idempotency → production failures.
- Malicious price manipulation on unencrypted payment buttons → fraud.
- Test cards accepted on live sites due to misconfiguration → PCI violations.
- Webhook signature skipped → system flooded with malicious requests.

## Test scenarios checklist

- Successful payment (happy path)
- Declined card, insufficient funds, expired card, 3-D Secure required
- Subscription renewal success and failure
- Refund (full & partial) and dispute
- Duplicate webhook delivery (idempotency)
- Out-of-order events

## Sources

- `payment-integration`, `stripe-integration`, `paypal-integration`,
  `api-integration` (webhooks), `pakistan-payments-stack` (regional PSP rails).