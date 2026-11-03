import Mathlib

/-!
# atan2 identities

Mathlib's `Complex.arg z` is `atan2(z.im, z.re)`, the angle of `z` in `(-π, π]`.
-/

open Complex Real

namespace Atan2

/-- In the right half-plane, the angle is an ordinary arctangent. -/
theorem arg_eq_arctan {z : ℂ} (h : 0 < z.re) : arg z = Real.arctan (z.im / z.re) := by
  have habs : |arg z| < π / 2 := abs_arg_lt_pi_div_two_iff.mpr (Or.inl h)
  rw [abs_lt] at habs
  rw [← tan_arg, Real.arctan_tan habs.1 habs.2]

/-- `atan x` is the angle of `1 + x i`. -/
theorem arg_one_add_mul_I (x : ℝ) : arg (1 + x * I) = Real.arctan x := by
  rw [arg_eq_arctan (z := 1 + x * I) (by simp)]
  simp

theorem one_add_mul_I_ne_zero (x : ℝ) : (1 + x * I : ℂ) ≠ 0 := by
  intro h0
  have := congrArg Complex.re h0
  simp at this

/-- The sum of two arctangents is the angle of a product. -/
theorem arctan_add_arctan (x y : ℝ) :
    Real.arctan x + Real.arctan y = arg ((1 + x * I) * (1 + y * I)) := by
  have hmem : arg (1 + x * I) + arg (1 + y * I) ∈ Set.Ioc (-π) π := by
    rw [arg_one_add_mul_I, arg_one_add_mul_I]
    constructor <;>
      linarith [Real.neg_pi_div_two_lt_arctan x, Real.arctan_lt_pi_div_two x,
        Real.neg_pi_div_two_lt_arctan y, Real.arctan_lt_pi_div_two y, Real.pi_pos]
  rw [arg_mul (one_add_mul_I_ne_zero x) (one_add_mul_I_ne_zero y) hmem,
    arg_one_add_mul_I, arg_one_add_mul_I]

/-- Splitting `atan2(b, a)`: if `x + y = c b` and `1 - x y = c a` for some `c > 0`,
then `atan x + atan y = atan2(b, a)`. -/
theorem arctan_add_arctan_eq_arg {x y a b c : ℝ} (hc : 0 < c)
    (hb : x + y = c * b) (ha : 1 - x * y = c * a) :
    Real.arctan x + Real.arctan y = arg (a + b * I) := by
  rw [arctan_add_arctan]
  have h : (1 + x * I) * (1 + y * I) = (c : ℂ) * (a + b * I) := by
    apply Complex.ext
    · simp only [mul_re, mul_im, add_re, add_im, one_re, one_im, ofReal_re, ofReal_im,
        I_re, I_im]
      linear_combination ha
    · simp only [mul_re, mul_im, add_re, add_im, one_re, one_im, ofReal_re, ofReal_im,
        I_re, I_im]
      linear_combination hb
  rw [h, arg_real_mul _ hc]

/-- The half-angle form: `atan2(y, x) = 2 atan(y / (x + r))` when `x + r > 0`,
that is, when `(x, y)` is not on the closed negative x-axis. -/
theorem half_angle (x y : ℝ) (h : 0 < x + Real.sqrt (x ^ 2 + y ^ 2)) :
    arg (x + y * I) = 2 * Real.arctan (y / (x + Real.sqrt (x ^ 2 + y ^ 2))) := by
  have hs2 : Real.sqrt (x ^ 2 + y ^ 2) ^ 2 = x ^ 2 + y ^ 2 := Real.sq_sqrt (by positivity)
  set s := Real.sqrt (x ^ 2 + y ^ 2) with hs
  set w : ℂ := ((x + s : ℝ) : ℂ) + y * I with hwdef
  have hwre : w.re = x + s := by
    rw [hwdef]
    simp only [add_re, mul_re, ofReal_re, ofReal_im, I_re, I_im]
    ring
  have hwim : w.im = y := by
    rw [hwdef]
    simp only [add_im, mul_im, ofReal_re, ofReal_im, I_re, I_im]
    ring
  have hw : arg w = Real.arctan (y / (x + s)) := by
    rw [arg_eq_arctan (z := w) (by rw [hwre]; exact h), hwre, hwim]
  have hw0 : w ≠ 0 := by
    intro h0
    have := congrArg Complex.re h0
    rw [hwre, zero_re] at this
    linarith
  -- (z + r)² = 2 (x + r) z
  have hsq : w * w = ((2 * (x + s) : ℝ) : ℂ) * (x + y * I) := by
    rw [hwdef]
    apply Complex.ext
    · simp only [mul_re, mul_im, add_re, add_im, ofReal_re, ofReal_im, I_re, I_im]
      linear_combination hs2
    · simp only [mul_re, mul_im, add_re, add_im, ofReal_re, ofReal_im, I_re, I_im]
      ring
  have hmem : arg w + arg w ∈ Set.Ioc (-π) π := by
    rw [hw]
    constructor <;>
      linarith [Real.neg_pi_div_two_lt_arctan (y / (x + s)),
        Real.arctan_lt_pi_div_two (y / (x + s)), Real.pi_pos]
  have h2 : (0 : ℝ) < 2 * (x + s) := by linarith
  have key := arg_mul hw0 hw0 hmem
  rw [hsq, arg_real_mul _ h2] at key
  rw [key, hw]
  ring

end Atan2
