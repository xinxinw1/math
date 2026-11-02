# Investigating Antihydra

Notes from exploring the map a ↦ ⌊3a/2⌋, the Collatz-like map behind the
BB(6) "Antihydra" Turing machine, starting from the factorizations of 3^k + 1.

## What's proved here

`ThreePowPlusOne.lean` proves, using only core Lean 4 (no Mathlib), how many
factors of 2 divide 3^k + 1:

| Theorem | Statement |
|---|---|
| `three_pow_mod_eight` | 3^k mod 8 is 1 when k is even and 3 when k is odd |
| `odd_mod_eight` | k odd → 3^k + 1 ≡ 4 (mod 8) |
| `even_mod_eight` | k even → 3^k + 1 ≡ 2 (mod 8) |
| `odd_exact` | k odd → 4 ∣ 3^k + 1 and ¬ 8 ∣ 3^k + 1 (exactly 2²) |
| `even_exact` | k even → 2 ∣ 3^k + 1 and ¬ 4 ∣ 3^k + 1 (exactly 2¹) |
| `not_eight_dvd` | 8 never divides 3^k + 1 |

The key lemma is proved by induction on k: `Nat.pow_succ` rewrites 3^(k+1) as
3^k · 3, and `omega` (Lean's linear-arithmetic decision procedure) treats 3^k as
an opaque variable and finishes the argument mod 8.

## Checking the proof

See the [root README](../README.md) for installing Lean. Then, from this
directory:

```bash
lean ThreePowPlusOne.lean
```

The `lean-toolchain` file pins Lean 4.15.0, the version this proof has been
checked with. No output means every theorem checked.
