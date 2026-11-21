# ADR 0006: Multiplatform Exact Decimal Implementation Evaluation

- **Status:** Proposed
- **Date:** 2026-11-21

## Context

ADR 0003 establishes that financial values must not use binary floating point and that shared financial rules need exact decimal arithmetic. AUREX must work across Kotlin Multiplatform targets, preserve decimal values through persistence and serialization, and make rounding policy explicit.

There is no single platform-provided decimal API shared by Kotlin Multiplatform. A library's use of `BigDecimal`, `NSDecimalNumber` or a JavaScript decimal engine does not automatically guarantee identical semantics across targets. The implementation must be evaluated by contract and tests, not by its API surface alone.

## Candidates identified

The following candidates are research inputs, not approved dependencies:

### 1. Kormium Decimal 0.1.0

- Maven coordinate: `io.github.kormium:decimal:0.1.0`.
- Apache-2.0 license.
- Pure common Kotlin implementation, no runtime dependencies.
- Documents BigDecimal-compatible parsing, formatting, scale behaviour and arithmetic, with a JVM differential-testing oracle and cross-platform golden tests.
- Division requires explicit scale and rounding; there is deliberately no default `/` operator.
- It documents value-based equality (rather than BigDecimal's scale-sensitive `equals`) and supports NaN/infinity as special values.

**Risks:** very early 0.x release with limited adoption. The special values and equality semantics need an explicit AUREX domain boundary and tests. The project's advertised test coverage is evidence to inspect, not a substitute for AUREX validation.

### 2. Kimplify Deci 0.3.0

- Maven coordinate: `org.kimplify:deci:0.3.0`.
- MIT license.
- Uses `BigDecimal` on JVM/Android, `NSDecimalNumber` on Apple platforms, and `decimal.js` on JS/Wasm.
- Includes serialization support and explicit division contexts.
- The documented `/` operator uses a default 20-fractional-digit HALF_UP context when no explicit context is passed.
- The current repository build uses Kotlin 2.4.0, AGP 9.2.1 and compile SDK 37.

**Risks:** different platform backends can have different edge conditions; the default division operator is not appropriate for financial business rules unless wrapped and prohibited. Its current repository toolchain is newer than AUREX's API 36 baseline, so compatibility must be verified before adoption.

### 3. IonsPin Kotlin Multiplatform BigNum 0.3.10

- Maven coordinate: `com.ionspin.kotlin:bignum:0.3.10`.
- Apache-2.0 license.
- Established KMP project with a larger community footprint than the newer candidates.
- Includes arbitrary precision `BigDecimal` and `BigInteger` support across KMP targets.

**Risks:** the latest stable release identified in the release history is from July 2024 and targets Kotlin 2.0.0. It may still work, but active compatibility with the current Kotlin 2.4.21 and Gradle toolchain must be demonstrated. Historical BigDecimal scale/rounding bug fixes make AUREX-specific edge testing essential.

## Proposed evaluation decision

Do not select a production implementation yet. Run a small isolated compatibility and correctness POC against at least Kormium Decimal and IonsPin BigNum. Include Deci if its required Android build metadata and API 36 consumer compatibility can be verified without upgrading the AUREX toolchain.

The POC should expose a narrow AUREX-owned decimal adapter so the third-party implementation does not become the public business API.

## Required semantic contract

The candidate must pass the same golden test vectors on every configured target:

1. Decimal text parsing and canonical/plain-string serialization without a Float/Double intermediate.
2. Exact addition, subtraction and multiplication with documented scale rules.
3. Division only through an explicit scale and rounding mode in financial pathways.
4. Positive and negative halfway cases for HALF_UP, HALF_DOWN and HALF_EVEN, plus CEILING, FLOOR, UP and DOWN.
5. Division by zero must fail deterministically; NaN and infinities must be rejected at the AUREX money boundary.
6. Compare/equality/hash semantics must be documented and consistent with the AUREX value-object contract.
7. Large/small magnitudes, scale changes, overflow and conversion boundaries.
8. Serialization must use decimal strings, not JSON floating-point numbers.
9. Android/JVM results must match. Add iOS, JS/Wasm and desktop JVM verification when those targets are introduced.
10. Dependency license, maintenance activity, toolchain compatibility and migration/exit cost must be reviewed.

## Domain boundary

The selected library type must not itself become the complete definition of money. AUREX should own:

- Currency identity and currency-specific fraction/rounding metadata.
- Money invariants and arithmetic rules.
- Per-operation rounding decisions for tax, discounts, unit pricing, settlement and accounting.
- Safe conversion to/from persistence and external formats.

Never assume that every currency has two fraction digits or that one rounding rule applies to all operations.

## Consequences

- No third-party decimal dependency is added to production code by this ADR.
- No financial transaction, price, tax or balance implementation should begin before the implementation choice and its golden-vector suite are accepted.
- The initial POC must not introduce a broad math module or a full money framework ahead of the required use cases.

## References

- [Kormium Decimal](https://github.com/kormium/decimal)
- [Kimplify Deci](https://github.com/Kimplify/Deci)
- [IonsPin Kotlin Multiplatform BigNum releases](https://github.com/ionspin/kotlin-multiplatform-bignum/releases)
- [IonsPin BigNum on Maven Central](https://central.sonatype.com/artifact/com.ionspin.kotlin/bignum)

## Related decisions

- [ADR 0003: Decimal financial arithmetic](0003-decimal-financial-arithmetic.md)
- [ADR 0004: Kotlin Multiplatform platform strategy](0004-kotlin-multiplatform-platform-strategy.md)
