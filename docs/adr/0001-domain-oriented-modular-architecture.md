# ADR 0001: Domain-Oriented Modular Architecture

- **Status:** Accepted
- **Date:** 2026-11-21

## Context
AUREX is an ecosystem expected to include POS, accounting, stock, synchronization and cloud capabilities. A monolithic codebase with uncontrolled cross-feature dependencies would make shared business behavior difficult to reason about and test.

## Decision
Use domain-oriented modular architecture with explicit inward dependency direction. Begin with a conceptual domain map and introduce physical modules only when boundaries and ownership are understood.

Domain rules must not depend on UI, Android, database or network frameworks. Shared/core contracts must not depend on feature implementations.

## Consequences
- Business rules can be tested independently.
- Multiple products can reuse approved capabilities.
- Module boundaries require deliberate governance.
- Avoid creating modules solely to satisfy an abstract diagram.
- Cross-feature orchestration needs an explicit application-level owner.

## Alternatives considered
- Single unstructured application module: rejected due to dependency and ownership risks.
- Immediate microservices: rejected as premature operational complexity.
