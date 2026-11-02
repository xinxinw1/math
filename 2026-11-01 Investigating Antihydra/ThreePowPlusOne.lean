/-
  The power of 2 dividing 3^k + 1.

  * k odd  → 4 ∣ 3^k + 1 and ¬ 8 ∣ 3^k + 1   (exactly 2²)
  * k even → 2 ∣ 3^k + 1 and ¬ 4 ∣ 3^k + 1   (exactly 2¹)

  Uses only Lean 4 core (no Mathlib). `omega` treats `3^k` as an opaque
  atom, so after the key lemma everything is linear arithmetic.
-/

/-- Powers of 3 mod 8 alternate: 1 for even exponents, 3 for odd ones. -/
theorem three_pow_mod_eight (k : Nat) :
    (3 ^ k % 8 = 1 ∧ k % 2 = 0) ∨ (3 ^ k % 8 = 3 ∧ k % 2 = 1) := by
  induction k with
  | zero => left; decide
  | succ k ih =>
    rw [Nat.pow_succ]   -- 3^(k+1) = 3^k * 3
    omega

/-- For odd k, 3^k + 1 ≡ 4 (mod 8). -/
theorem odd_mod_eight (k : Nat) (hk : k % 2 = 1) : (3 ^ k + 1) % 8 = 4 := by
  have := three_pow_mod_eight k
  omega

/-- For even k, 3^k + 1 ≡ 2 (mod 8). -/
theorem even_mod_eight (k : Nat) (hk : k % 2 = 0) : (3 ^ k + 1) % 8 = 2 := by
  have := three_pow_mod_eight k
  omega

/-- For odd k, exactly 2² divides 3^k + 1. -/
theorem odd_exact (k : Nat) (hk : k % 2 = 1) :
    4 ∣ 3 ^ k + 1 ∧ ¬ 8 ∣ 3 ^ k + 1 := by
  have := three_pow_mod_eight k
  omega

/-- For even k, exactly 2¹ divides 3^k + 1. -/
theorem even_exact (k : Nat) (hk : k % 2 = 0) :
    2 ∣ 3 ^ k + 1 ∧ ¬ 4 ∣ 3 ^ k + 1 := by
  have := three_pow_mod_eight k
  omega

/-- 3^k + 1 is never divisible by 8. -/
theorem not_eight_dvd (k : Nat) : ¬ 8 ∣ 3 ^ k + 1 := by
  have := three_pow_mod_eight k
  omega
