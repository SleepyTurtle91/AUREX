# AUREX Domain Map

- **Status:** Working draft — owner review required
- **Date:** 2026-11-21
- **Scope:** Initial SME commerce and back-office ecosystem

This document is a discovery artefact, not an accepted architecture decision. It records a starting hypothesis so the business vocabulary and system boundaries can be reviewed before implementation.

## 1. Working product assumptions

The first AUREX business workflows are expected to cover:

- Retail and food & beverage sales at a physical point of sale.
- Product, service, price and tax configuration.
- Stock availability, purchasing, receiving, stocktaking and transfers.
- Payments, tenders, cashier shifts and cash reconciliation.
- Bookkeeping, accounting records and operational reporting.
- Multiple branches and terminals, including operation during internet outages.

The initial user group is assumed to be owner-operated and small-to-medium businesses, from a single outlet to a group with multiple branches and more than one legal entity.

These assumptions need owner confirmation. They do not imply that every capability ships in the first release or that all deployments require cloud hosting.

## 2. Initial user roles and scenarios

| Role | Main job | Example scenario |
|---|---|---|
| Owner / administrator | Configure the business and oversee operations | Create a company, branch, users, products and price rules |
| Cashier / salesperson | Complete customer transactions | Sell products while offline, accept tender and issue a receipt |
| Store / inventory operator | Maintain stock accuracy | Receive a purchase, count stock and transfer items between locations |
| F&B service staff | Capture and progress orders | Open a table/order, send items to preparation and settle the bill |
| Purchasing operator | Replenish goods | Create a purchase order, receive deliveries and record supplier costs |
| Bookkeeper / accountant | Maintain financial records | Review posted sales, reconcile payments and prepare accounting periods |

## 3. Proposed organizational vocabulary

The following definitions are provisional. They are intended to prevent application code from using words such as "branch", "location" and "warehouse" interchangeably.

| Concept | Working meaning | Questions to resolve |
|---|---|---|
| Workspace / Tenant | Technical data-isolation and subscription boundary for one customer environment | Is a workspace always one customer account, or can it contain multiple independent groups? |
| Organization / Group | A business group that may contain one or more legal companies | Is an explicit group entity necessary in the first version? |
| Company | A legal entity responsible for accounting, tax identity and legal documents | Can one workspace contain multiple companies? The draft assumes yes |
| Branch | An operating unit of a company, such as a retail outlet or restaurant | Can branches share stock and staff across companies? |
| Location | A physical or logical place where stock is held or an operation occurs | Can a warehouse serve several branches? |
| Terminal | A registered device installation used to perform work at a branch/location | Can a terminal be reassigned, and how is its offline identity retained? |
| User | A person or service identity that authenticates to AUREX | A user should not be the same thing as a company employee record |
| Membership | A user's association with a workspace or organization and its access scope | How are cross-company and temporary staff permissions granted? |

Important distinction: a **Company** is a legal/accounting boundary; a **Branch** is an operational boundary; a **Location** is a stock/physical boundary; a **Terminal** is a device boundary. Their identifiers and relationships should not be collapsed into a single branch identifier.

## 4. Candidate bounded contexts

| Context | Owns | Must not become responsible for |
|---|---|---|
| Identity & Access | Users, memberships, roles, permission policies and scoped access | Product or transaction business rules |
| Organization & Configuration | Workspace, organization, company, branch, location, terminal and business settings | Posting sales or stock movements |
| Catalog | Products, variants, services, units, barcodes, categories and F&B modifiers | Current stock quantity or sale totals |
| Pricing & Tax | Price books, price rules, discount policies and tax profiles | Editing historical transaction snapshots |
| Sales & Orders | Quotes, orders, sale lifecycle, invoice facts, returns and void/adjustment requests | Directly mutating inventory balances or accounting ledgers |
| Inventory | Stock movement ledger, stock balance projections, stocktakes, reservations and transfers | Supplier commercial terms or accounting journals |
| Procurement | Suppliers, purchase orders, goods receipts and supplier purchasing workflow | Owning the accounts-payable ledger |
| Payments & Settlement | Tenders, payment records, settlement, refunds, cash sessions and reconciliation inputs | Owning the general ledger |
| Accounting / Books | Chart of accounts, journals, posting rules, periods, receivables/payables and financial statements | Reconstructing operational state from mutable UI data |
| Compliance | Country/jurisdiction adapters, document submission, external status and regulatory references | Being the source of truth for sales or accounting facts |
| Audit & Operations | Actor, time, reason, correlation and immutable record of significant actions | Replacing domain-specific state machines |
| Reporting | Read models, aggregates and operational/financial reports | Writing back into authoritative business records |
| Sync & Integration | Outbox/inbox, transport, idempotency, external adapters and retry policy | Generic conflict resolution that ignores domain rules |

These contexts are logical boundaries, not a requirement to create one Gradle module per row. Start with explicit packages and contracts; split modules only when dependency direction or independent testing justifies it.

## 5. Important cross-context flows

### Sale completion

1. Sales validates the order and snapshots product description, unit price, discounts and tax inputs used for the sale.
2. Payments records the tender/capture outcome.
3. Inventory records the stock movement or reservation effect.
4. Accounting receives a posted business fact and creates the corresponding journal entries.
5. Compliance creates/submits the required external document where configured.
6. Audit records the actor and the important state transitions.
7. Sync publishes durable events when connectivity is available.

The final implementation must define which operations are one local database transaction and which are durable follow-up workflows. A payment request, stock mutation and accounting post must not be treated as one imaginary atomic network call.

### Goods receiving

1. Procurement records the goods receipt against a purchase order or approved receipt.
2. Inventory records the physical stock increase at a specific location.
3. Accounting receives the supplier-liability and inventory-cost facts according to the approved posting policy.
4. Audit and Sync preserve the trace and delivery status.

### Stock transfer

1. Inventory creates a transfer from a source location to a destination location.
2. The transfer has explicit states such as requested, dispatched, received and cancelled.
3. Source and destination movements remain traceable; a transfer must not be modelled as an unexplained quantity edit.

## 6. Cross-cutting invariants to preserve

- Financial values use exact decimal arithmetic and explicit currency/rounding policy. Never use Float or Double for money.
- Posted financial records are immutable. Corrections use reversals or compensating entries, not silent edits.
- Inventory changes are represented by traceable movements; a balance is a projection, not the only record of truth.
- Historical sales preserve the item description, unit, price, discount and tax facts used at the time of sale.
- Offline operations receive durable local identifiers and are safe to replay through an idempotent sync protocol.
- User identity, employee/personnel records and access membership are distinct concepts.
- Significant actions record actor, time, reason/context and correlation to the business document.
- Tenant/company/branch/location/terminal scope is explicit in queries and authorization rules.

## 7. Initial non-goals

These are proposed exclusions from the first product slice, not permanent prohibitions:

- Manufacturing execution, complex bill-of-materials planning and production scheduling.
- Payroll and full human-resources management.
- A proprietary payment network or payment processor.
- A marketplace or full e-commerce storefront.
- A universal tax engine for every jurisdiction at launch.
- Generic workflow automation before core business state transitions are stable.
- A mandatory cloud dependency for local checkout or business continuity.

## 8. Open decisions for owner review

1. Is the first commercial focus a single business with multiple outlets, a group with multiple legal entities, or both?
2. Should a workspace always map to one customer account, with an organization/group below it?
3. Can stock locations be shared across branches or companies?
4. Which workflows must continue fully offline, and which may queue for later processing?
5. Which operational workflows are in the first release: retail, F&B, or both?
6. Which countries/jurisdictions need compliance adapters in the first release?
7. What data is shared across companies, and what must remain legally or operationally isolated?

## 9. Related architecture work

- [ADR 0001: Domain-oriented modular architecture](adr/0001-domain-oriented-modular-architecture.md)
- [ADR 0002: Offline-first local continuity](adr/0002-offline-first-local-continuity.md)
- [ADR 0003: Decimal financial arithmetic](adr/0003-decimal-financial-arithmetic.md)
- [ADR 0005: Room 3 KMP persistence evaluation](adr/0005-room-kmp-persistence-evaluation.md)
- [ADR 0006: Multiplatform exact decimal implementation evaluation](adr/0006-decimal-implementation-evaluation.md)
