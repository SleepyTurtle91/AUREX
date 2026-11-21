# ADR 0002: Offline-First Local Continuity

- **Status:** Accepted
- **Date:** 2026-11-21

## Context
AUREX is intended for SME operations where reliable internet access cannot be assumed. Core local workflows should continue during network interruption.

## Decision
Design supported operational workflows around durable local persistence. Remote synchronization is asynchronous where business and regulatory constraints permit. Retryable operations must be idempotent and have observable delivery state.

## Consequences
- Local persistence and migration quality are critical.
- Outbox/inbox or equivalent durable delivery mechanisms will be required.
- Conflict resolution must be specific to each domain.
- Local success and remote synchronization success must be represented separately.
- Some operations may legitimately require connectivity; those exceptions must be explicit.

## Alternatives considered
- Cloud-only transactional operation: rejected for core offline workflows.
- Best-effort network calls without durable queue: rejected due to data-loss risk.
