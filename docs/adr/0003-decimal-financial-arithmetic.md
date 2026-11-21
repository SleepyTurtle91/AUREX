# ADR 0003: Decimal Financial Arithmetic

- **Status:** Accepted
- **Date:** 2026-11-21

## Context
Binary floating-point arithmetic cannot represent many decimal fractions exactly. Business calculations require explicit decimal precision and rounding behavior.

AUREX has selected Kotlin Multiplatform. The JVM type `java.math.BigDecimal` is not available as a common Kotlin Multiplatform API, so it cannot be exposed directly from shared domain contracts.

## Decision
1. Do not use Float or Double for financial values.
2. Model money through platform-neutral domain types with explicit currency, scale and rounding policy.
3. Use an exact decimal arithmetic implementation that is compatible with every target on which shared financial logic is compiled.
4. The specific KMP-compatible decimal library or implementation remains open and must be selected in a follow-up ADR before production financial calculations are implemented.
5. JVM-only adapters may use `java.math.BigDecimal`, provided it does not leak into `commonMain` APIs and conversions preserve exact values.
6. Avoid assuming that all currencies use two decimal places or that one rounding policy applies to every operation.

## Consequences
- Financial calculations require dedicated value objects and cross-platform tests.
- Conversion from external numeric formats must avoid lossy intermediate floating-point values.
- Rounding rules must be specified per business operation and jurisdiction.
- Serialization and persistence formats must preserve exact decimal values.
- Generic platform logic must not hardcode one country's cash-rounding or tax rules.

## Alternatives considered
- Double-based money calculations: rejected.
- JVM BigDecimal directly in shared common code: rejected because it is not a common KMP type.
- Integer minor units for all possible currencies and calculations: not selected as a universal representation because not all operations and currencies fit one fixed minor-unit assumption. It may be suitable for specific integrations and storage formats with explicit conversion rules.

## Related decisions
- [ADR 0004: Kotlin Multiplatform Platform Strategy](0004-kotlin-multiplatform-platform-strategy.md)
