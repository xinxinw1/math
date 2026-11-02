import Mathlib

/-!
# The only squarefree identity `∛(a + √b) + ∛(a - √b) = x`

We prove that if `a` and `b` are nonzero integers with `b > 0` squarefree, and

  ∛(a + √b) + ∛(a - √b) = x

with `x` rational, then `(a, b, x)` is `(2, 5, 1)` or `(-2, 5, -1)`.

The argument never uses that the cube roots are real, so the main theorem
`eq_of_cube_roots` is stated for any field of characteristic zero: `s` plays the
role of `√b`, and `u`, `v` are any elements with `u ^ 3 = a + s` and
`v ^ 3 = a - s`. The real-number statement `real_cube_roots` is a corollary.

Proof outline (matching the README):

1. With `m = u * v`, cubing `u + v = x` gives `x ^ 3 = 2a + 3mx`, and
   `m ^ 3 = a ^ 2 - b`. So `m` is rational, hence an integer, and then `x` is an
   integer (`exists_int_of_cubic`).
2. `(u ^ 3 - v ^ 3) ^ 2 = 4b` gives `4b = (x ^ 2 - 4m) (x ^ 2 - m) ^ 2`.
3. Squarefreeness forces `x ^ 2 - m ∈ {±1, ±2}`, and positivity of `b` leaves
   only `x = ±1` (`int_classification`).
-/

namespace CubicIdentities

/-- A rational root of a monic integer cubic `t ^ 3 + c t + d` is an integer. -/
theorem exists_int_of_cubic {q : ℚ} {c d : ℤ} (h : q ^ 3 + c * q + d = 0) :
    ∃ n : ℤ, q = n := by
  have hnum : q * q.den = q.num := Rat.mul_den_eq_num q
  -- Clear denominators: `num ^ 3 + c num den ^ 2 + d den ^ 3 = 0`.
  have key : (q.num : ℚ) ^ 3 + c * q.num * (q.den : ℚ) ^ 2 + d * (q.den : ℚ) ^ 3 = 0 := by
    linear_combination (q.den : ℚ) ^ 3 * h
      - ((q.num : ℚ) ^ 2 + q.num * q * q.den + q ^ 2 * (q.den : ℚ) ^ 2
          + c * (q.den : ℚ) ^ 2) * hnum
  have keyZ : q.num ^ 3 + c * q.num * (q.den : ℤ) ^ 2 + d * (q.den : ℤ) ^ 3 = 0 := by
    exact_mod_cast key
  -- So `den ∣ num ^ 3`, and since `num` and `den` are coprime, `den = 1`.
  have hdvd : (q.den : ℤ) ∣ q.num ^ 3 :=
    ⟨-(c * q.num * q.den + d * (q.den : ℤ) ^ 2), by linear_combination keyZ⟩
  have hdvd' : q.den ∣ q.num.natAbs ^ 3 := by
    have := Int.natAbs_dvd_natAbs.mpr hdvd
    simpa [Int.natAbs_pow] using this
  have hden : q.den = 1 := (Nat.Coprime.pow_left 3 q.reduced).symm.eq_one_of_dvd hdvd'
  exact ⟨q.num, (Rat.coe_int_num_of_den_eq_one hden).symm⟩

/-- The integer part of the argument (Steps 3 and 4 in the README). -/
theorem int_classification {a b k n : ℤ} (ha : a ≠ 0) (hb : 0 < b) (hsq : Squarefree b)
    (e1 : k ^ 3 = 2 * a + 3 * n * k) (e3 : 4 * b = (k ^ 2 - 4 * n) * (k ^ 2 - n) ^ 2) :
    (a = 2 ∧ b = 5 ∧ k = 1) ∨ (a = -2 ∧ b = 5 ∧ k = -1) := by
  obtain ⟨c, hc⟩ : ∃ c, c = k ^ 2 - n := ⟨_, rfl⟩
  have hn : n = k * k - c := by rw [hc]; ring
  have e3' : 4 * b = (4 * c - 3 * (k * k)) * (c * c) := by rw [e3, hc]; ring
  have e1' : k * k * k = 2 * a + 3 * n * k := by linear_combination e1
  -- Step 3: `c` is `±1` or `±2`.
  have hc4 : c = 1 ∨ c = -1 ∨ c = 2 ∨ c = -2 := by
    rcases Int.even_or_odd c with ⟨j, hj⟩ | ⟨j, hj⟩
    · -- `c = 2j`, so `b = j ^ 2 (4c - 3k ^ 2)` and `j` is a unit.
      have hb' : b = j * j * (4 * c - 3 * (k * k)) :=
        mul_left_cancel₀ (by norm_num : (4 : ℤ) ≠ 0) (by rw [e3', hj]; ring)
      have hu : IsUnit j := hsq j ⟨4 * c - 3 * (k * k), hb'⟩
      rcases Int.isUnit_iff.mp hu with h | h <;> omega
    · -- `c` is odd, so `c ^ 2` is coprime to `4` and divides `b`.
      have h2 : IsCoprime c 2 := ⟨1, -j, by rw [hj]; ring⟩
      have h4 : IsCoprime (c * c) (2 * 2) := (h2.mul_left h2).mul_right (h2.mul_left h2)
      have hdvd : c * c ∣ b * (2 * 2) := ⟨4 * c - 3 * (k * k), by linear_combination e3'⟩
      have hu : IsUnit c := hsq c (h4.dvd_of_dvd_mul_right hdvd)
      rcases Int.isUnit_iff.mp hu with h | h <;> omega
  clear e1 e3 hc
  -- Step 4: `b > 0` rules out `c < 0` and forces `|k| ≤ 1`.
  rcases hc4 with rfl | rfl | rfl | rfl
  · have hk1 : k ≤ 1 := by nlinarith
    have hk2 : -1 ≤ k := by nlinarith
    interval_cases k <;> omega
  · exfalso; nlinarith [mul_self_nonneg k]
  · have hk1 : k ≤ 1 := by nlinarith
    have hk2 : -1 ≤ k := by nlinarith
    interval_cases k <;> omega
  · exfalso; nlinarith [mul_self_nonneg k]

/-- **Main theorem**, over any field of characteristic zero. Here `s` stands for
`√b`, and `u`, `v` for any cube roots of `a + s` and `a - s`. -/
theorem eq_of_cube_roots {K : Type*} [Field K] [CharZero K] {a b : ℤ} {x : ℚ} {s u v : K}
    (ha : a ≠ 0) (hb : 0 < b) (hsq : Squarefree b)
    (hs : s ^ 2 = b) (hu : u ^ 3 = a + s) (hv : v ^ 3 = a - s) (hx : u + v = x) :
    (a = 2 ∧ b = 5 ∧ x = 1) ∨ (a = -2 ∧ b = 5 ∧ x = -1) := by
  -- Polynomial identities in `K`.
  have h1 : (x : K) ^ 3 = 2 * a + 3 * (u * v) * x := by
    rw [← hx]; linear_combination hu + hv
  have h2 : (u * v) ^ 3 = (a : K) ^ 2 - b := by
    linear_combination v ^ 3 * hu + (a + s) * hv - hs
  have h3 : 4 * (b : K) = ((u + v) ^ 2 - 4 * (u * v)) * ((u + v) ^ 2 - u * v) ^ 2 := by
    linear_combination -4 * hs - (u ^ 3 - v ^ 3 + 2 * s) * hu + (u ^ 3 - v ^ 3 + 2 * s) * hv
  -- `x ≠ 0`, since otherwise `a = 0`.
  have hx0 : x ≠ 0 := by
    rintro rfl
    simp only [Rat.cast_zero] at h1
    have h : ((2 * a : ℤ) : K) = 0 := by push_cast; linear_combination -h1
    have h' : 2 * a = 0 := by exact_mod_cast h
    omega
  have hxK : (x : K) ≠ 0 := by exact_mod_cast hx0
  -- Step 1: `m = u v` is rational ...
  have hm' : u * v = (((x ^ 3 - 2 * a) / (3 * x) : ℚ) : K) := by
    push_cast
    rw [eq_div_iff (mul_ne_zero (by norm_num) hxK)]
    linear_combination -h1
  obtain ⟨m, hm⟩ : ∃ m : ℚ, u * v = m := ⟨_, hm'⟩
  have hm3 : m ^ 3 = (a : ℚ) ^ 2 - b := by
    have : ((m ^ 3 : ℚ) : K) = (((a : ℚ) ^ 2 - b : ℚ) : K) := by
      push_cast; rw [← hm]; exact h2
    exact_mod_cast this
  -- ... and its cube is an integer, so it is an integer.
  obtain ⟨n, rfl⟩ := exists_int_of_cubic (q := m) (c := 0) (d := b - a ^ 2)
    (by push_cast; linear_combination hm3)
  push_cast at hm
  -- Then `x` is a rational root of `t ^ 3 - 3 n t - 2 a`, so an integer.
  have hx3 : x ^ 3 = 2 * a + 3 * n * x := by
    have : ((x ^ 3 : ℚ) : K) = ((2 * a + 3 * n * x : ℚ) : K) := by
      push_cast; rw [← hm]; exact h1
    exact_mod_cast this
  obtain ⟨k, rfl⟩ := exists_int_of_cubic (q := x) (c := -3 * n) (d := -2 * a)
    (by push_cast; linear_combination hx3)
  push_cast at hx
  -- Step 2: the integer equations.
  have e1 : k ^ 3 = 2 * a + 3 * n * k := by exact_mod_cast hx3
  have e3 : 4 * b = (k ^ 2 - 4 * n) * (k ^ 2 - n) ^ 2 := by
    have : ((4 * b : ℤ) : K) = (((k ^ 2 - 4 * n) * (k ^ 2 - n) ^ 2 : ℤ) : K) := by
      push_cast; rw [← hx, ← hm]; exact h3
    exact_mod_cast this
  -- Steps 3 and 4.
  rcases int_classification ha hb hsq e1 e3 with ⟨rfl, rfl, rfl⟩ | ⟨rfl, rfl, rfl⟩
  · left; norm_num
  · right; norm_num

/-- **Real version.** If `a ≠ 0`, `b > 0` is squarefree, `u` and `v` are the real
cube roots of `a + √b` and `a - √b`, and `u + v` is rational, then
`(a, b, u + v)` is `(2, 5, 1)` or `(-2, 5, -1)`. -/
theorem real_cube_roots {a b : ℤ} {x : ℚ} {u v : ℝ}
    (ha : a ≠ 0) (hb : 0 < b) (hsq : Squarefree b)
    (hu : u ^ 3 = a + Real.sqrt b) (hv : v ^ 3 = a - Real.sqrt b) (hx : u + v = x) :
    (a = 2 ∧ b = 5 ∧ x = 1) ∨ (a = -2 ∧ b = 5 ∧ x = -1) :=
  eq_of_cube_roots ha hb hsq (Real.sq_sqrt (by exact_mod_cast hb.le)) hu hv hx

/-- The identity itself: `∛(2 + √5) + ∛(2 - √5) = 1`, with cube roots
`(1 + √5) / 2` and `(1 - √5) / 2`. -/
theorem golden_identity :
    ((1 + Real.sqrt 5) / 2) ^ 3 = 2 + Real.sqrt 5 ∧
    ((1 - Real.sqrt 5) / 2) ^ 3 = 2 - Real.sqrt 5 ∧
    (1 + Real.sqrt 5) / 2 + (1 - Real.sqrt 5) / 2 = 1 := by
  have h5 : Real.sqrt 5 ^ 2 = 5 := Real.sq_sqrt (by norm_num)
  refine ⟨?_, ?_, ?_⟩
  · linear_combination (3 + Real.sqrt 5) / 8 * h5
  · linear_combination (3 - Real.sqrt 5) / 8 * h5
  · ring

end CubicIdentities
