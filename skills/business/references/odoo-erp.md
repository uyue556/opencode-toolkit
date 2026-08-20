# Odoo ERP — Implementation & Development Guide

Odoo implementation across 22 module areas. Sources: `odoo-accounting-setup`, `odoo-automated-tests`, `odoo-backup-strategy`, `odoo-docker-deployment`, `odoo-ecommerce-configurator`, `odoo-edi-connector`, `odoo-hr-payroll-setup`, `odoo-inventory-optimizer`, `odoo-l10n-compliance`, `odoo-manufacturing-advisor`, `odoo-migration-helper`, `odoo-module-developer`, `odoo-orm-expert`, `odoo-performance-tuner`, `odoo-project-timesheet`, `odoo-purchase-workflow`, `odoo-qweb-templates`, `odoo-rpc-api`, `odoo-sales-crm-expert`, `odoo-security-rules`, `odoo-shopify-integration`, `odoo-upgrade-advisor`, `odoo-woocommerce-bridge`, `odoo-xml-views-builder`.

## When to Use

- Configuring Odoo for accounting, sales/CRM, inventory, manufacturing, purchase, HR/payroll, eCommerce, or project/timesheets.
- Building custom Odoo modules, XML views, QWeb reports, or security rules.
- Integrating Odoo with Shopify/WooCommerce/EDI or via RPC API.
- Deploying, backing up, migrating, upgrading, or performance-tuning Odoo.

## Module Development

**Scaffold structure:**
```
my_module/
├── __manifest__.py
├── __init__.py
├── models/
│   ├── __init__.py
│   └── my_model.py
├── views/
│   └── my_model_views.xml
├── security/
│   ├── ir.model.access.csv
│   └── security.xml
└── data/
```

**`__manifest__.py`:** `name`, `version` (e.g. `17.0.1.0.0`), `category`, `depends`, `data` (list security before views), `installable`, `license: 'LGPL-3'`, plus `author`/`website`.

**Model best practices:**
- Always prefix model `_name` with a namespace (e.g., `hospital.patient`).
- Use `_inherit = ['mail.thread', 'mail.activity.mixin']` for chatter/tracking.
- **Never modify core Odoo models directly — always `_inherit`.**
- New models must be added to `ir.model.access.csv` or users get access errors.
- Use snake_case module names (no spaces/uppercase).

## ORM Patterns

- **Search**: domains with field conditions; pass dates as `'YYYY-MM-DD'` strings, not `fields.Date` objects.
- **Computed fields**: decorate with `@api.depends`; store when query-heavy.
- **Bulk write**: use `recordset` operations (`search().write({...})`) to avoid N+1 — one query for all records, never per-record loops.
- **Domain filters**: combine `&`/`|`/`!` operators explicitly for complex logic.

## XML Views

- **Form**: `<form>` with `<group>`, `<notebook>` tabs, `<field>` attributes (`required`, `readonly`).
- **List/Tree, Kanban, Search, Calendar, Graph**: use proper `<tree>`, `<kanban>`, `<search>` (with filters/favorites), `<calendar>`, `<graph>` root elements. Target Odoo 14–17 syntax; Odoo 17 replaced `attrs` visibility with direct `invisible` expressions.

## Security (access control)

- `ir.model.access.csv`: one row per (model, group), with `create/read/write/unlink` flags.
- **Record rules** (`ir.rule`): restrict records by domain, e.g., "users see only their own records" — `[('user_id', '=', user.id)]`. Multi-company rules use `company_id`.
- Group definitions in `security.xml` (`res.groups`).

## QWeb Templates

- Use `t-if`, `t-foreach`, `t-field`, `t-esc`, `t-raw` for PDF reports, email templates, website pages.
- Custom PDF report: define a report action (`<report ... />`), a template extending `web.html_container_body`, and render with document options.
- Report actions reference the model's `_name` and template.

## Functional Setup Quick Reference

- **Accounting**: chart of accounts, journals, fiscal positions (EU VAT example: B2B intra-community 0% via fiscal position mapping), taxes, payment terms (e.g., Net 30 with 2% early-pay discount), bank reconciliation models.
- **Sales/CRM**: pipeline stages, quotation templates, pricelists (customer-tier VIP discounts), lead scoring, forecasting.
- **Inventory**: FIFO/AVCO valuation, min/max reordering rules, putaway rules, routes, 3-step warehouse delivery.
- **Manufacturing**: BoM, Work Centers, routings, MRP scheduler runs.
- **Purchase**: RFQ → PO → Receipt → Vendor Bill flow, 2-level approval, vendor price lists with quantity breaks, 3-way matching.
- **HR/Payroll**: salary structures, payslip rules, leave/time-off types, contracts, payroll journal entries.
- **eCommerce**: publish products, payment providers (Stripe), flat-rate shipping with free threshold, abandoned-cart recovery.
- **Project/Timesheets**: billable projects, task time logging, timesheet approval before invoicing, invoice from timesheets.

## Localization & Compliance (l10n)

- Country-specific modules (`l10n_mx` CFDI 4.0, `l10n_it`, SAF-T, etc.).
- EU intra-community VAT via fiscal positions (0% + reverse charge).
- Install via Apps or CLI; verify installed in Apps → Installed.

## Integrations

- **RPC API** (external): authenticate with `common.authenticate(db, user, key, {})`, then `execute_kw` for search/read/create. JSON-RPC requires `id` for correlation; prefer `/web/dataset/call_kw` in Odoo 16+.
- **Shopify**: push sale orders, sync products/inventory/orders/customers; Shopify webhooks for real-time orders.
- **WooCommerce**: REST API pull orders → Odoo, push stock; field-mapping table WooCommerce → Odoo.
- **EDI**: X12/EDIFACT document mapping (e.g., EDI 850 → sale.order), send 997 acknowledgments, partner onboarding.

## Deployment, Backup, Upgrade, Performance

### Docker deployment

`docker-compose.yml` with odoo + postgres services, persistent volumes, env-based config; drop the deprecated top-level `version` key (Compose v2+). Common commands: `docker compose up -d`, `docker compose logs -f odoo`, restart Odoo only (not DB — avoids data risk), DB dump, module update without server restart.

### Backup strategy

Database dump + filestore archive; automate with cron (daily 2 AM); upload to S3; delete local >7 days. **Restore:** stop Odoo → drop and recreate DB (a bare `--clean` fails if DB doesn't exist) → restore dump → restore filestore → restart → verify (login, records, attachments).

### Version upgrades/migration

- Pre-upgrade checklist: backup, review deprecated modules, check OCA compatibility.
- Community upgrade with OpenUpgrade: clone OpenUpgrade for the **target** version, run against staging DB, review log before touching production.
- Key API changes: v15→16 (website_published flag → `is_published`), v16→17 (attrs → invisible expressions, chatter block changes).
- Post-upgrade validation checklist: core flows, custom modules, reports.

### Performance tuning

- Worker config: `workers = (2 × CPU cores) + 1`, `max_cron_threads`, memory limits (e.g., 4-core/8GB reference).
- Find slow queries in PostgreSQL (`pg_stat_statements`), use Odoo's built-in profiler, tune `shared_buffers`/`work_mem`.
- Watch for N+1 in ORM; use `read_group`/`search_read` for aggregated data.

### Automated tests

- `TransactionCase` (Odoo 15+ pattern), `HttpCase` for controller tests, browser tour tests.
- Run via CLI: `odoo -i <module> -u <module> --test-enable`, filter by tags/class.
- Test data setup via `setUpClass`/fixtures; mock external calls.

## Best Practices Summary

- Always inherit, never patch core models.
- Security files loaded before views; every model needs access rules.
- Use ORM bulk operations; avoid N+1.
- Test migrations on staging before production.
- Back up both DB and filestore; verify restores.
- Keep modules small, namespaced, and versioned.
