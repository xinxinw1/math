import Mathlib

/-!
# Denesting `√(x ± √y)`

For real `y ≥ 0` and `x ≥ √y`, with `d = √(x ^ 2 - y)`,

  √(x + √y) = √((x + d) / 2) + √((x - d) / 2)
  √(x - √y) = √((x + d) / 2) - √((x - d) / 2)

(`denest_add`, `denest_sub`). Conversely, if `x` and `y` are rational, `√y` is
irrational and `√(x + √y) = √a + √b` with rational `a, b ≥ 0`, then
`a + b = x` and `4ab = y` (`eq_of_denest`). So `x ^ 2 - y = (a - b) ^ 2` must be
the square of a rational number.
-/

namespace Denesting

/-- The common core of `denest_add` and `denest_sub`, with `d` standing for
`√(x ^ 2 - y)`: the product of the two square roots is `√y / 2`. -/
theorem sqrt_mul_sqrt {x y d : ℝ} (hy : 0 ≤ y) (hd0 : 0 ≤ d)
    (hd2 : d ^ 2 = x ^ 2 - y) (hdx : d ≤ x) :
    Real.sqrt ((x + d) / 2) * Real.sqrt ((x - d) / 2) = Real.sqrt y / 2 := by
  have hs : Real.sqrt y ^ 2 = y := Real.sq_sqrt hy
  rw [← Real.sqrt_mul (show 0 ≤ (x + d) / 2 by linarith) ((x - d) / 2)]
  have h : (x + d) / 2 * ((x - d) / 2) = (Real.sqrt y / 2) ^ 2 := by
    linear_combination (-1 / 4 : ℝ) * hd2 - (1 / 4 : ℝ) * hs
  rw [h, Real.sqrt_sq (by positivity)]

/-- Facts about `d = √(x ^ 2 - y)` used by both formulas. -/
theorem d_facts {x y : ℝ} (hy : 0 ≤ y) (hx : Real.sqrt y ≤ x) :
    0 ≤ Real.sqrt (x ^ 2 - y) ∧
      Real.sqrt (x ^ 2 - y) ^ 2 = x ^ 2 - y ∧
      Real.sqrt (x ^ 2 - y) ≤ x := by
  have hx0 : 0 ≤ x := le_trans (Real.sqrt_nonneg y) hx
  have hxy : y ≤ x ^ 2 := by
    nlinarith [Real.sq_sqrt hy, mul_self_le_mul_self (Real.sqrt_nonneg y) hx]
  refine ⟨Real.sqrt_nonneg _, Real.sq_sqrt (by linarith), ?_⟩
  calc Real.sqrt (x ^ 2 - y) ≤ Real.sqrt (x ^ 2) := Real.sqrt_le_sqrt (by linarith)
    _ = x := Real.sqrt_sq hx0

/-- `√(x + √y) = √((x + √(x² - y)) / 2) + √((x - √(x² - y)) / 2)`. -/
theorem denest_add {x y : ℝ} (hy : 0 ≤ y) (hx : Real.sqrt y ≤ x) :
    Real.sqrt (x + Real.sqrt y) =
      Real.sqrt ((x + Real.sqrt (x ^ 2 - y)) / 2) +
        Real.sqrt ((x - Real.sqrt (x ^ 2 - y)) / 2) := by
  obtain ⟨hd0, hd2, hdx⟩ := d_facts hy hx
  have hab := sqrt_mul_sqrt hy hd0 hd2 hdx
  have ha : 0 ≤ (x + Real.sqrt (x ^ 2 - y)) / 2 := by linarith
  have hb : 0 ≤ (x - Real.sqrt (x ^ 2 - y)) / 2 := by linarith
  have key : x + Real.sqrt y =
      (Real.sqrt ((x + Real.sqrt (x ^ 2 - y)) / 2) +
        Real.sqrt ((x - Real.sqrt (x ^ 2 - y)) / 2)) ^ 2 := by
    rw [add_sq, Real.sq_sqrt ha, Real.sq_sqrt hb]
    linear_combination (-2 : ℝ) * hab
  rw [key, Real.sqrt_sq (by positivity)]

/-- `√(x - √y) = √((x + √(x² - y)) / 2) - √((x - √(x² - y)) / 2)`. -/
theorem denest_sub {x y : ℝ} (hy : 0 ≤ y) (hx : Real.sqrt y ≤ x) :
    Real.sqrt (x - Real.sqrt y) =
      Real.sqrt ((x + Real.sqrt (x ^ 2 - y)) / 2) -
        Real.sqrt ((x - Real.sqrt (x ^ 2 - y)) / 2) := by
  obtain ⟨hd0, hd2, hdx⟩ := d_facts hy hx
  have hab := sqrt_mul_sqrt hy hd0 hd2 hdx
  have ha : 0 ≤ (x + Real.sqrt (x ^ 2 - y)) / 2 := by linarith
  have hb : 0 ≤ (x - Real.sqrt (x ^ 2 - y)) / 2 := by linarith
  have hle : Real.sqrt ((x - Real.sqrt (x ^ 2 - y)) / 2) ≤
      Real.sqrt ((x + Real.sqrt (x ^ 2 - y)) / 2) :=
    Real.sqrt_le_sqrt (by linarith)
  have key : x - Real.sqrt y =
      (Real.sqrt ((x + Real.sqrt (x ^ 2 - y)) / 2) -
        Real.sqrt ((x - Real.sqrt (x ^ 2 - y)) / 2)) ^ 2 := by
    rw [sub_sq, Real.sq_sqrt ha, Real.sq_sqrt hb]
    linear_combination (2 : ℝ) * hab
  rw [key, Real.sqrt_sq (sub_nonneg.mpr hle)]

/-- The only possible denesting: if `x`, `y`, `a`, `b` are rational, `√y` is
irrational and `√(x + √y) = √a + √b`, then `a + b = x` and `4ab = y`. -/
theorem eq_of_denest {x y a b : ℚ} (hy : 0 ≤ y)
    (hirr : Irrational (Real.sqrt y)) (ha : 0 ≤ a) (hb : 0 ≤ b)
    (hxy : 0 ≤ (x : ℝ) + Real.sqrt y)
    (h : Real.sqrt ((x : ℝ) + Real.sqrt y) = Real.sqrt a + Real.sqrt b) :
    a + b = x ∧ 4 * a * b = y := by
  have ha' : (0 : ℝ) ≤ a := by exact_mod_cast ha
  have hb' : (0 : ℝ) ≤ b := by exact_mod_cast hb
  have hy' : (0 : ℝ) ≤ y := by exact_mod_cast hy
  -- Square both sides: `x + √y = a + b + 2t` with `t = √a √b`.
  have h2 : Real.sqrt ((x : ℝ) + Real.sqrt y) ^ 2 =
      (Real.sqrt (a : ℝ) + Real.sqrt b) ^ 2 := by rw [h]
  rw [Real.sq_sqrt hxy, add_sq, Real.sq_sqrt ha', Real.sq_sqrt hb'] at h2
  have h1 : (x : ℝ) + Real.sqrt y =
      a + b + 2 * (Real.sqrt (a : ℝ) * Real.sqrt b) := by
    linear_combination h2
  have ht : (Real.sqrt (a : ℝ) * Real.sqrt b) ^ 2 = a * b := by
    rw [mul_pow, Real.sq_sqrt ha', Real.sq_sqrt hb']
  have hs : Real.sqrt (y : ℝ) ^ 2 = y := Real.sq_sqrt hy'
  set t := Real.sqrt (a : ℝ) * Real.sqrt b
  -- So `√y = r + 2t` with `r = a + b - x` rational.
  have h1' : Real.sqrt (y : ℝ) = ((a : ℝ) + b - x) + 2 * t := by
    linear_combination h1
  by_cases hr : (a : ℝ) + b - x = 0
  · -- `r = 0`: then `√y = 2t`, so `y = 4t² = 4ab`.
    have e1 : (a : ℝ) + b = x := by linarith
    have e2 : 4 * (a : ℝ) * b = y := by
      linear_combination (-4 : ℝ) * ht + hs -
        (Real.sqrt (y : ℝ) + ((a : ℝ) + b - x) + 2 * t) * h1' -
        ((a : ℝ) + b - x + 4 * t) * hr
    exact ⟨by exact_mod_cast e1, by exact_mod_cast e2⟩
  · -- `r ≠ 0`: squaring `√y = r + 2t` makes `t`, and so `√y`, rational.
    exfalso
    have h4 : 4 * ((a : ℝ) + b - x) * t = y - ((a : ℝ) + b - x) ^ 2 - 4 * a * b := by
      linear_combination hs -
        (Real.sqrt (y : ℝ) + ((a : ℝ) + b - x) + 2 * t) * h1' - 4 * ht
    have ht' : t = (y - ((a : ℝ) + b - x) ^ 2 - 4 * a * b) / (4 * ((a : ℝ) + b - x)) := by
      rw [eq_div_iff (mul_ne_zero four_ne_zero hr)]
      linear_combination h4
    refine hirr.ne_rat
      ((a + b - x) + 2 * ((y - (a + b - x) ^ 2 - 4 * a * b) / (4 * (a + b - x)))) ?_
    rw [h1', ht']
    push_cast
    ring

end Denesting
