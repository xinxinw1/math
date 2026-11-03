import Mathlib

/-!
# When is `√(a + bi) + √(a - bi)` nice?

For nonzero integers `a`, `b`, the sum of principal square roots is
`2 Re √(a + bi) = 2r`, where `c = √(a² + b²)`, `r = √((c + a) / 2)` and
`s = √((c - a) / 2)`.

* `parts`: `r² - s² = a`, `2rs = |b|` and `(2r)² = 2(a + c)`. So `r ± si`
  squares to `a + bi` (taking the sign of `b`) and has positive real part:
  it is the principal square root.
* `gaussian_sq`: `(p + qi)² = (p² - q²) + 2pq i`.
* `gaussian_of_int`: if `m / 2 + yi` squares to `a + bi` with `m`, `a`, `b`
  integers and `b ≠ 0`, then `m = 2p`, `y = q` and `a + bi = (p + qi)²` for
  integers `p`, `q`. So if the sum `m = 2r` is an integer, `a + bi` is the
  square of a Gaussian integer.
-/

namespace ComplexSums

open Complex

/-- With `c = √(a² + b²)`, `r = √((c + a)/2)` and `s = √((c - a)/2)`:
`r² - s² = a`, `2rs = |b|` and `(2r)² = 2(a + c)`. -/
theorem parts {a b c : ℝ} (hc : c = Real.sqrt (a ^ 2 + b ^ 2)) :
    Real.sqrt ((c + a) / 2) ^ 2 - Real.sqrt ((c - a) / 2) ^ 2 = a ∧
      2 * (Real.sqrt ((c + a) / 2) * Real.sqrt ((c - a) / 2)) = |b| ∧
      (2 * Real.sqrt ((c + a) / 2)) ^ 2 = 2 * (a + c) := by
  have hc2 : c ^ 2 = a ^ 2 + b ^ 2 := by
    rw [hc]
    exact Real.sq_sqrt (by positivity)
  have hca : |a| ≤ c := by
    rw [hc]
    exact Real.abs_le_sqrt (le_add_of_nonneg_right (sq_nonneg b))
  have h1 : 0 ≤ (c + a) / 2 := by
    have := neg_abs_le a
    linarith
  have h2 : 0 ≤ (c - a) / 2 := by
    have := le_abs_self a
    linarith
  refine ⟨?_, ?_, ?_⟩
  · rw [Real.sq_sqrt h1, Real.sq_sqrt h2]
    ring
  · have h : (c + a) / 2 * ((c - a) / 2) = (|b| / 2) ^ 2 := by
      linear_combination (1 / 4 : ℝ) * hc2 - (1 / 4 : ℝ) * sq_abs b
    rw [← Real.sqrt_mul h1, h, Real.sqrt_sq (by positivity)]
    ring
  · rw [mul_pow, Real.sq_sqrt h1]
    ring

/-- `(p + qi)² = (p² - q²) + 2pq i`. -/
theorem gaussian_sq (p q : ℤ) :
    ((p : ℂ) + q * I) ^ 2 = ((p ^ 2 - q ^ 2 : ℤ) : ℂ) + ((2 * p * q : ℤ) : ℂ) * I := by
  push_cast
  linear_combination (q : ℂ) ^ 2 * I_sq

/-- If `m / 2 + yi` squares to `a + bi`, that is `m² / 4 - y² = a` and
`m y = b`, with `m`, `a`, `b` integers and `b ≠ 0`, then `m = 2p`, `y = q` and
`a + bi = (p + qi)²` for integers `p` and `q`. -/
theorem gaussian_of_int {a b m : ℤ} {y : ℝ} (hb : b ≠ 0)
    (hre : (m : ℝ) ^ 2 / 4 - y ^ 2 = a) (him : (m : ℝ) * y = b) :
    ∃ p q : ℤ, m = 2 * p ∧ y = q ∧ a = p ^ 2 - q ^ 2 ∧ b = 2 * p * q := by
  have hm : (m : ℝ) ≠ 0 := by
    intro h0
    rw [h0, zero_mul] at him
    exact hb (by exact_mod_cast him.symm)
  -- `y = b / m` is rational.
  have hy : y = (b : ℝ) / m := by
    rw [eq_div_iff hm]
    linear_combination him
  -- `(2y)² = m² - 4a` is an integer, so `2y` is an integer `t`.
  have h2 : (2 * y) ^ 2 = ((m ^ 2 - 4 * a : ℤ) : ℝ) := by
    push_cast
    linear_combination (-4 : ℝ) * hre
  have ht : ∃ t : ℤ, 2 * y = t := by
    by_contra hnot
    exact (irrational_nrt_of_notint_nrt 2 (m ^ 2 - 4 * a) h2 hnot two_pos).ne_rat
      (2 * ((b : ℚ) / m)) (by rw [hy]; norm_cast)
  obtain ⟨t, ht⟩ := ht
  have hmt : m * t = 2 * b := by
    have h : ((m * t : ℤ) : ℝ) = ((2 * b : ℤ) : ℝ) := by
      push_cast
      rw [← ht]
      linear_combination 2 * him
    exact_mod_cast h
  have htm : t ^ 2 = m ^ 2 - 4 * a := by
    have h : ((t ^ 2 : ℤ) : ℝ) = ((m ^ 2 - 4 * a : ℤ) : ℝ) := by
      rw [← h2]
      push_cast
      rw [ht]
    exact_mod_cast h
  -- `mt = 2b` is even and `t² - m² = -4a`, so `m` and `t` are both even.
  have hmt_even : Even (m * t) := ⟨b, by rw [hmt]; ring⟩
  have hdiff : Even (t ^ 2 - m ^ 2) := ⟨-(2 * a), by rw [htm]; ring⟩
  have hiff : Even t ↔ Even m := by
    have := Int.even_sub.mp hdiff
    simpa [Int.even_pow] using this
  have hme : Even m := by
    rcases Int.even_mul.mp hmt_even with h | h
    · exact h
    · exact hiff.mp h
  have hte : Even t := hiff.mpr hme
  obtain ⟨p, hp⟩ := hme
  obtain ⟨q, hq⟩ := hte
  refine ⟨p, q, by rw [hp]; ring, ?_, ?_, ?_⟩
  · have h : (t : ℝ) = 2 * q := by
      rw [hq]
      push_cast
      ring
    linarith
  · have h4 : 4 * a = 4 * (p ^ 2 - q ^ 2) := by
      have h := htm
      rw [hp, hq] at h
      linear_combination h
    exact mul_left_cancel₀ four_ne_zero h4
  · have h4 : 2 * b = 2 * (2 * p * q) := by
      rw [← hmt, hp, hq]
      ring
    exact mul_left_cancel₀ two_ne_zero h4

end ComplexSums
