# acot input places and evaluation

How many places the input to $\mathrm{acot}(x)$ needs, and how to add acot to
the method for whole expressions: its cheap bounds, tightening, places rule
and evaluation.

*Xin-Xin*

This builds on
[Input places for atan and atan2](../2026-11-03%20Input%20places%20for%20atan%20and%20atan2/README.md)
and [atan and atan2 in whole expressions](../2026-11-03%20atan%20and%20atan2%20in%20whole%20expressions/README.md),
and uses their notation and the atan evaluation procedure. Like the second,
it extends
[Precision for whole expressions](../2026-11-03%20Precision%20for%20whole%20expressions/README.md)
without changing it.

Everything here was checked in 60-digit arithmetic with
[`check_acot.py`](check_acot.py). It tests the places rule, the cheap
intervals and the evaluation error bound at random points, and prints the
numbers in the examples.

## The convention

This doc uses the odd convention:

$$
\mathrm{acot}(x) = \mathrm{atan}\left(\frac{1}{x}\right) \quad \text{for } x \ne 0,
\qquad \mathrm{acot}(0) = \frac{\pi}{2}.
$$

Its values are in $(-\tfrac{\pi}{2}, \tfrac{\pi}{2}]$, and it's odd except at
0: $\mathrm{acot}(-x) = -\mathrm{acot}(x)$ for $x \ne 0$. It is decreasing on
each side of 0, but jumps at 0: just left of 0 it is close to
$-\frac{\pi}{2}$, and just right of 0 close to $\frac{\pi}{2}$. That jump plays
the part that the cut plays for atan2. Near 0, the value depends on the sign
of $x$, so the rules have to pin that sign down.

The other common convention, with values in $(0, \pi)$, is continuous. It
differs only for $x < 0$, where it is $\mathrm{acot}(x) + \pi$.

## Summary

| Part | acot x |
|---|---|
| Input places | $\max(d + 1 - 2\max(0, \mathrm{siz}(0.99L_x) - 1), 3 - \mathrm{siz}(L_x))$; needs $L_x$ |
| Cheap interval | from acot of the ends of $x$'s interval, if it excludes 0 |
| Tightening | $x$, if its interval contains 0 |
| Evaluation | the atan procedure on $1/\tilde{x}$, or on $\tilde{x}$ with $\pm\frac{\pi}{2}$ |

## Input places

**Rule.** With a lower bound $L_x \le |x|$ on the true value,

$$d_x = \max(d + 1 - 2\max(0, \mathrm{siz}(0.99L_x) - 1), 3 - \mathrm{siz}(L_x)).$$

This is the atan rule, except that the lower bound isn't optional. Without
one, no number of places is enough, because $x$ could be on either side of the
jump. An exact $x$ needs no places.

**Example.** For $\mathrm{acot}(10\pi)$ rounded to 6 places, take $d = 8$:
$10\pi > 31$, and $\mathrm{siz}(0.99 \cdot 31) = 2$, so $10\pi$ needs
$8 + 1 - 2 = 7$ places, the same as for $\mathrm{atan}(10\pi)$.

**Why.** The minimum places, $3 - \mathrm{siz}(L_x)$, keep
$\varepsilon_x \le 0.01L_x$, so $\tilde{x}$ has the same sign as $x$, and every
$t$ between them has $|t| \ge 0.99L_x$. On that side of 0,
$\mathrm{acot}(t) = \mathrm{atan}(1/t)$, whose derivative is

$$
\frac{1}{1 + 1/t^2} \cdot \left(-\frac{1}{t^2}\right) = -\frac{1}{1 + t^2},
$$

the same size as the derivative of atan. So
[the atan proof](../2026-11-03%20Input%20places%20for%20atan%20and%20atan2/README.md#arctangent)
applies word for word: Theorem 4 with
$A = \frac{1}{1 + (0.99L_x)^2} \le 1$.

The minimum places do the same job as for atan2's $y$. They are what keep
$\tilde{x}$ on the right side of the jump, and they are the only reason the
rule needs $L_x$.

## Pass 1: cheap bounds

A new row for the table in
[Cheap bounds](../2026-11-03%20Precision%20for%20whole%20expressions/README.md#cheap-bounds),
with $w = 10^{-5}$:

| Node | Cheap interval |
|---|---|
| $\mathrm{acot}(x)$, $\ell > 0$ | $[\max(a_h - w, \frac{1}{2}\min(\frac{1}{h}, 1)), \min(a_\ell + w, 1.5708)]$ |
| $\mathrm{acot}(x)$, $h < 0$ | $[\max(a_h - w, -1.5708), \min(a_\ell + w, -\frac{1}{2}\min(\frac{1}{\lvert\ell\rvert}, 1))]$ |
| $\mathrm{acot}(x)$, $\ell \le 0 \le h$ | tighten $x$ first |

Here $a_\ell$ and $a_h$ are $\mathrm{acot}(\ell)$ and $\mathrm{acot}(h)$ to 5
places, by the procedure in [Pass 3](#pass-3-evaluation).

**Why.** On each side of 0, acot is decreasing, so its values on $[\ell, h]$
fill $[\mathrm{acot}(h), \mathrm{acot}(\ell)]$. The 5-place ends are within
$w$ of the true ones. The extra bounds keep the interval away from 0 when $x$
is large, where $\mathrm{acot}(x) \approx \frac{1}{x}$ rounds to 0 at 5 places.
For $x > 0$, $\mathrm{acot}(x) = \mathrm{atan}(1/x)$, and the
[atan bound](../2026-11-03%20atan%20and%20atan2%20in%20whole%20expressions/README.md#arctangent)
$\mathrm{atan}(t) \ge \frac{1}{2}\min(t, 1)$ gives
$\mathrm{acot}(x) \ge \mathrm{acot}(h) \ge \frac{1}{2}\min(\frac{1}{h}, 1)$.
For $x < 0$, use oddness.

So a parent that divides by an acot never has to tighten it. Its interval
always excludes 0, once $x$'s does.

## Tightening

[Tightening by evaluation](../2026-11-03%20Precision%20for%20whole%20expressions/README.md#tightening-by-evaluation)
gets one more entry:

- **The argument of an acot,** if its interval contains 0.

As for atan2's $y$, this is tightening for sign. Both the places rule and the
cheap interval need to know which side of the jump $x$ is on.

## Pass 2: places

A new row for the table in
[Rules for each operation](../2026-11-03%20Precision%20for%20whole%20expressions/README.md#rules-for-each-operation):

| Node | Places for its child |
|---|---|
| $\mathrm{acot}(x)$ | $\max(d + 1 - 2\max(0, \mathrm{siz}(0.99L_x) - 1), 3 - \mathrm{siz}(L_x))$ |

After tightening, $L_x$ always exists, so the row always applies.

## Pass 3: evaluation

Use the atan procedure from
[atan and atan2 in whole expressions](../2026-11-03%20atan%20and%20atan2%20in%20whole%20expressions/README.md#pass-3-evaluating-atan),
with a different first step and last step. As there, $p = d + 2$.

**Start.** If $|\tilde{x}| \ge 1$, compute $w = 1/\tilde{x}$ to $p$ places.
Otherwise, $w = \tilde{x}$. Either way $|w| \le 1$.

**Halve twice, then sum the series,** exactly as in the atan procedure, to get
a sum $S$ with $\mathrm{atan}(w) \approx 4S$.

**Combine.**

$$
\mathrm{acot}(\tilde{x}) =
\begin{cases}
4S, & |\tilde{x}| \ge 1 \\
\mathrm{sgn}(\tilde{x}) \cdot \frac{\pi}{2} - 4S, & |\tilde{x}| < 1
\end{cases}
$$

with $\frac{\pi}{2}$ to $p$ places.

**Why.** For $|\tilde{x}| \ge 1$, $\mathrm{acot}(\tilde{x}) = \mathrm{atan}(w)$
by the convention. For $0 < |\tilde{x}| < 1$, the identity
$\mathrm{atan}(t) + \mathrm{atan}(\frac{1}{t}) = \mathrm{sgn}(t) \cdot \frac{\pi}{2}$
for $t \ne 0$ gives
$\mathrm{acot}(\tilde{x}) = \mathrm{sgn}(\tilde{x}) \cdot \frac{\pi}{2} - \mathrm{atan}(\tilde{x})$.

The [error table](../2026-11-03%20atan%20and%20atan2%20in%20whole%20expressions/README.md#pass-3-evaluating-atan)
for atan carries over row for row. One of $w$ and $\frac{\pi}{2}$ is rounded,
as there, and the halvings and series are the same. So the result is within
$0.18T$ of $\mathrm{acot}(\tilde{x})$, inside the
$T/2$ left after the input error.

$\tilde{x}$ is never 0 here. Tightening and the minimum places keep it on the
same side of 0 as $x$, and an exact 0 is handled in pass 1, below.

**Example.** For $\mathrm{acot}(10\pi)$ rounded to 6 places, with $d = 8$,
$\tilde{x} = 31.4159265$, so $w = 1/\tilde{x} = 0.0318309887$, to 10 places.
From there the halvings and series are the same as in
[the atan example](../2026-11-03%20atan%20and%20atan2%20in%20whole%20expressions/README.md#pass-3-evaluating-atan),
with sum $S = 0.00795506119$. So $\mathrm{acot}(\tilde{x}) = 4S = 0.03182024476$,
which rounds to $0.031820$. The true value is $0.0318202446\ldots$

## Example

### acot(sin(π + 0.00001)) to 8 places

$\sin(\pi + 0.00001) \approx -0.00001$, just left of 0, so the answer is just
above $-\frac{\pi}{2}$. If the sign of the sine came out wrong, the result
would be near $+\frac{\pi}{2}$, off by about 3. Take $d = 10$ for the top node.

**Bounds.** The sine's cheap interval is $[-1, 1]$, which contains 0, so
tighten it. To 5 places the sine comes out as $-0.000010$, so it is in
$[-0.00002, 0]$, which doesn't exclude 0. To 10 places it is
$-0.00001000000$, so it is in $[-0.0000100001, -0.0000099999]$. So
$L_x = 0.0000099999$, of size $-5$. The acot's cheap interval is then
$[-1.5708, -1.57078]$.

**Places.** $\mathrm{siz}(0.99 \cdot 0.0000099999) = -5$, so the first part of
the rule is $10 + 1 - 0 = 11$, and the minimum places are $3 + 5 = 8$.

| Node | Asks | For |
|---|---|---|
| acot, with 10 places | $\max(11, 8) = 11$ | the sine |
| $\sin(\ldots)$, with 11 places | $11 + 1 = 12$ | its argument |
| $\pi + 0.00001$, with 12 places | $12$, since $0.00001$ is exact | $\pi$ |

**Evaluate.** $\pi$ to 12 places is $3.141592653590$, so the argument is
$3.141602653590$. Its sine to 12 places is $\tilde{x} = -0.000010000000$.

$|\tilde{x}| < 1$, so $w = \tilde{x}$, and the result is
$-\frac{\pi}{2} - 4S = -1.5707863267950$, which rounds to $-1.57078633$. The
true value is $-1.5707863267948\ldots$

The correct-rounding check passes: the computed value is about
$1.8 \times 10^{-9}$ from the boundary $-1.570786325$, more than
$10^{-d} = 10^{-10}$.

## Corner cases

### x exactly 0

$\mathrm{acot}(0) = \frac{\pi}{2}$ by the convention, but tightening an exact
0 never excludes 0. When pass 1 finds an exact 0 as the argument, replace the
node with the constant $\frac{\pi}{2}$.

### x close to 0 but not provably nonzero

If tightening reaches its cap, $x$ is 0 or within about $10^{-80}$ of it, and
the method can't tell which side of the jump it is on. The answer could be
near $\frac{\pi}{2}$ or near $-\frac{\pi}{2}$. Report it like
[an exact singularity](../2026-11-03%20Precision%20for%20whole%20expressions/README.md#exact-singularities),
even if the true value is exactly 0. A value computed only to finitely many
places can't show that $\mathrm{acot}(0) = \frac{\pi}{2}$ applies. Symbolic
simplification can catch cases such as $\mathrm{acot}(\sin \pi)$ before the
passes start.

### Large x

For large $|x|$, the rule asks for few places, possibly a negative number,
as for atan. The value is close to $\frac{1}{x}$, and its cheap interval stays
away from 0 thanks to the bound $\frac{1}{2}\min(\frac{1}{h}, 1)$.
