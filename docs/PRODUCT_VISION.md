# AUREX Product Vision

## Purpose
AUREX is a personal software ecosystem for managing the operational and financial life of businesses. It aims to connect point-of-sale activity, inventory, procurement, accounting and multi-branch oversight through shared business concepts and reliable data flows.

## Problem space
Small and growing businesses often operate disconnected tools for sales, stock, purchasing, finance and branch administration. This can produce duplicate data, delayed reconciliation, fragmented reporting and weak operational visibility.

AUREX aims to provide a coherent platform while allowing each capability to be deployed and adopted incrementally.

## Product principles
### One business truth, multiple workflows
Products, parties, branches, inventory, transactions and accounting records should have clear ownership and stable identifiers. Product experiences consume shared domain capabilities rather than maintaining incompatible copies of business rules.

### Local continuity
A temporary internet outage should not stop supported day-to-day work. Local persistence, durable queues and explicit synchronization state are essential.

### Financial trust
Amounts, tax, discounts, tenders, refunds and ledger postings must be deterministic, explainable and testable.

### Operational accountability
Important business changes should identify who or what initiated them, when they occurred, where they occurred and why they were permitted.

### Incremental ecosystem
Businesses should be able to begin with a focused workflow and adopt additional capabilities without replacing their entire system.

## Intended product families
- **AUREX Core:** shared domain contracts and platform capabilities.
- **AUREX POS:** sales and service operations for retail and F&B.
- **AUREX Books:** accounting and financial management.
- **AUREX Stock:** inventory, procurement and supplier workflows.
- **AUREX Cloud:** centralized administration and multi-branch oversight.
- **AUREX Sync:** reliable communication between local and remote nodes.

These are product concepts. Deployment boundaries and packaging remain open until validated.

## Initial target environment
The first implementation is expected to focus on Android-based SME operations, with a path to web-based administration and accounting. Malaysia is an important initial market context, but country-specific compliance must remain configurable and isolated from generic domain logic.

## Non-goals for the first milestone
- Rebuilding every legacy feature immediately.
- Designing a distributed microservice system before domain boundaries are understood.
- Making cloud connectivity mandatory for core local workflows.
- Supporting every industry at initial release.
- Claiming regulatory compliance before current requirements and test evidence are established.
