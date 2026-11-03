import Mathlib

/-!
# When is `√(a + √b) + √(a - √b)` nice?

Write `S a b = √(a + √b) + √(a - √b)`. For real `b ≥ 0` and `a ≥ √b`:

* `S_sq`: `S a b ^ 2 = 2a + 2√(a ^ 2 - b)`.
* `S_of_factors`: if `0 ≤ u ≤ v`, then `S ((u + v) / 2) (u v) = √(2v)`.

For integers `a`, `b` with `b ≥ 0` and `a ≥ √b`:

* `sq_rat_iff`: `S a b ^ 2` is rational exactly when `a ^ 2 - b` is a square.
* `S_ne_rat`: if `b` is squarefree, `S a b` is not rational.
-/

namespace ConjugateSums

/-- `S a b = √(a + √b) + √(a - √b)`. -/
noncomputable def S (a b : ℝ) : ℝ :=
  Real.sqrt (a + Real.sqrt b) + Real.sqrt (a - Real.sqrt b)

theorem S_nonneg (a b : ℝ) : 0 ≤ S a b := by
  unfold S
  positivity

/-- `S a b ^ 2 = 2a + 2√(a² - b)`. -/
theorem S_sq {a b : ℝ} (hb : 0 ≤ b) (ha : Real.sqrt b ≤ a) :
    S a b ^ 2 = 2 * a + 2 * Real.sqrt (a ^ 2 - b) := by
  have hp : 0 ≤ a + Real.sqrt b := by linarith [Real.sqrt_nonneg b]
  have hq : 0 ≤ a - Real.sqrt b := by linarith
  have hpq : (a + Real.sqrt b) * (a - Real.sqrt b) = a ^ 2 - b := by
    linear_combination (-1 : ℝ) * Real.sq_sqrt hb
  have h : Real.sqrt (a + Real.sqrt b) * Real.sqrt (a - Real.sqrt b) =
      Real.sqrt (a ^ 2 - b) := by
    rw [← Real.sqrt_mul hp, hpq]
  unfold S
  rw [add_sq, Real.sq_sqrt hp, Real.sq_sqrt hq]
  linear_combination (2 : ℝ) * h

/-- With `b = uv` and `a = (u + v) / 2`, the sum is `√(2v)`. -/
theorem S_of_factors {u v : ℝ} (hu : 0 ≤ u) (huv : u ≤ v) :
    S ((u + v) / 2) (u * v) = Real.sqrt (2 * v) := by
  have hb : 0 ≤ u * v := mul_nonneg hu (le_trans hu huv)
  have hd : ((u + v) / 2) ^ 2 - u * v = ((v - u) / 2) ^ 2 := by ring
  have ha : Real.sqrt (u * v) ≤ (u + v) / 2 := by
    calc Real.sqrt (u * v) ≤ Real.sqrt (((u + v) / 2) ^ 2) :=
          Real.sqrt_le_sqrt (by nlinarith [sq_nonneg (v - u)])
      _ = (u + v) / 2 := Real.sqrt_sq (by linarith)
  rw [← Real.sqrt_sq (S_nonneg ((u + v) / 2) (u * v)), S_sq hb ha, hd,
    Real.sqrt_sq (by linarith)]
  congr 1
  ring

/-- For integers, `S a b ^ 2` is rational exactly when `a² - b` is a square. -/
theorem sq_rat_iff {a b : ℤ} (hb : 0 ≤ b) (ha : Real.sqrt b ≤ a) :
    (∃ q : ℚ, S a b ^ 2 = q) ↔ ∃ c : ℤ, 0 ≤ c ∧ a ^ 2 - b = c ^ 2 := by
  have hb' : (0 : ℝ) ≤ b := by exact_mod_cast hb
  have hS := S_sq hb' ha
  constructor
  · rintro ⟨q, hq⟩
    have hd0 : (0 : ℝ) ≤ (a : ℝ) ^ 2 - b := by
      nlinarith [Real.sq_sqrt hb', mul_self_le_mul_self (Real.sqrt_nonneg (b : ℝ)) ha]
    have hx : Real.sqrt ((a : ℝ) ^ 2 - b) ^ 2 = ((a ^ 2 - b : ℤ) : ℝ) := by
      rw [Real.sq_sqrt hd0]
      norm_cast
    by_cases hint : ∃ y : ℤ, Real.sqrt ((a : ℝ) ^ 2 - b) = y
    · obtain ⟨y, hy⟩ := hint
      refine ⟨|y|, abs_nonneg y, ?_⟩
      have h : ((a ^ 2 - b : ℤ) : ℝ) = ((|y| ^ 2 : ℤ) : ℝ) := by
        rw [← hx, hy]
        push_cast
        rw [sq_abs]
      exact_mod_cast h
    · exfalso
      have hirr := irrational_nrt_of_notint_nrt 2 (a ^ 2 - b) hx hint two_pos
      apply hirr.ne_rat ((q - 2 * a) / 2)
      have h : Real.sqrt ((a : ℝ) ^ 2 - b) = ((q : ℝ) - 2 * a) / 2 := by linarith
      rw [h]
      push_cast
      ring
  · rintro ⟨c, hc0, hc⟩
    refine ⟨2 * a + 2 * c, ?_⟩
    have h : Real.sqrt ((a : ℝ) ^ 2 - b) = c := by
      rw [show (a : ℝ) ^ 2 - b = (c : ℝ) ^ 2 by exact_mod_cast hc]
      exact Real.sqrt_sq (by exact_mod_cast hc0)
    rw [hS, h]
    push_cast
    ring

/-- For integers with `b` squarefree, `S a b` is never rational. -/
theorem S_ne_rat {a b : ℤ} (hb : 0 ≤ b) (hsf : Squarefree b)
    (ha : Real.sqrt b ≤ a) (q : ℚ) : S a b ≠ q := by
  intro hq
  have hb' : (0 : ℝ) ≤ b := by exact_mod_cast hb
  -- `S²` is rational, so `a² - b = c²`.
  obtain ⟨c, hc0, hc⟩ := (sq_rat_iff hb ha).mp ⟨q ^ 2, by rw [hq]; norm_cast⟩
  -- Then `S² = 2(a + c)` is an integer.
  have hsq : S a b ^ 2 = ((2 * (a + c) : ℤ) : ℝ) := by
    rw [S_sq hb' ha, show (a : ℝ) ^ 2 - b = (c : ℝ) ^ 2 by exact_mod_cast hc,
      Real.sqrt_sq (by exact_mod_cast hc0)]
    push_cast
    ring
  -- A rational square root of an integer is an integer, so `S = m`.
  have hint : ∃ m : ℤ, S a b = m := by
    by_contra hnot
    exact (irrational_nrt_of_notint_nrt 2 (2 * (a + c)) hsq hnot two_pos).ne_rat q hq
  obtain ⟨m, hm⟩ := hint
  have hm2 : m ^ 2 = 2 * (a + c) := by
    have h : (m : ℝ) ^ 2 = ((2 * (a + c) : ℤ) : ℝ) := by
      rw [← hm]
      exact hsq
    exact_mod_cast h
  -- `m` is even, say `m = 2k`, so `a + c = 2k²` and `4 ∣ b`.
  have h2 : Even (m ^ 2) := ⟨a + c, by rw [hm2]; ring⟩
  have hme : Even m := (Int.even_pow.mp h2).1
  obtain ⟨k, hk⟩ := hme
  have hs : 2 * (a + c) = 2 * (2 * k ^ 2) := by
    rw [← hm2, hk]
    ring
  have hs' : a + c = 2 * k ^ 2 := by linarith
  have h4 : (2 * 2 : ℤ) ∣ b :=
    ⟨(k ^ 2 - c) * k ^ 2, by linear_combination -hc + (a - c + 2 * k ^ 2) * hs'⟩
  have hu := hsf 2 h4
  rw [Int.isUnit_iff] at hu
  omega

end ConjugateSums
