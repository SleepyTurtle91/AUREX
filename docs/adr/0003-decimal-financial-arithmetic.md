# ADR 0003: Decimal Financial Arithmetic

- **Status:** Accepted
- **Date:** 2026-11-21

## Context

Binary floating-point arithmetic cannot represent many decimal fractions exactly. Business calculations require explicit decimal precision and rounding behavior.

## Decision

Do not use Float or Double for financial values. Use exact decimal representations such as java.math.BigDecimal on the Kotlin/JVM implementation, with explicit scale, rounding mode and calculation policy. Currency context must be explicit.

## Consequences

- Financial calculations require dedicated value objects and tests.
- Conversion from external numeric formats must avoid lossy intermediate floating-point values.
- Rounding rules must be specified per business operation and jurisdiction.
- Generic platform logic must not hardcode one country's cash-rounding or tax rules.

## Alternatives considered

- Double-based money calculations: rejected.
- Integer minor units for all possible currencies and calculations: not selected as a universal representation because not all operations and currencies fit one fixed minor-unit assumption. It may be suitable for specific integrations and storage formats with explicit conversion rules.
