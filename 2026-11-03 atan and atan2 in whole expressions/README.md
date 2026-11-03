# atan and atan2 in whole expressions

How to add $\mathrm{atan}(x)$ and $\mathrm{atan2}(y, x)$ to the method that
works out the places for every part of an expression, including how to
evaluate them.

*Xin-Xin*

This extends
[Precision for whole expressions](../2026-11-03%20Precision%20for%20whole%20expressions/README.md)
without changing it. Each section below says which part of that doc it adds
to: the cheap bounds of pass 1, the tightening step, the rules of pass 2, and
the evaluation of pass 3. The notation is the same: $d$ is a node's places,
$T = 10^{-d}$ the budget, and a value is good to $d$ places if it is within
$10^{-d}$ of the true value.

It also uses:

- [Input places for atan and atan2](../2026-11-03%20Input%20places%20for%20atan%20and%20atan2/README.md)
  for the places rules.
- [atan2 identities revisited](../2026-11-03%20atan2%20identities%20revisited/README.md)
  for the cut, the half-angle form, and the stable way to compute atan2.
- [Functions by series](../2026-11-02%204%20Functions%20by%20series/README.md)
  for the stopping test and the error analysis of the series, following its
  logarithm section.

The procedures and examples were checked in 60-digit arithmetic with
[`check_additions.py`](check_additions.py). It tests the evaluation error
bounds, the cheap intervals and whole nodes at random points, and prints the
numbers in the examples.

## Summary

| Part | atan x | atan2(y, x) |
|---|---|---|
| Cheap interval | ends from atan of the ends of $x$'s interval | corners of the box, or $[-3.1416, 3.1416]$ near the cut |
| Tightening | none | $y$, if $\ell_x \le 0$ and $y$'s interval contains 0 |
| Places for children | the atan rule | the atan2 rule, for each inexact child |
| Evaluation | reciprocal, two halvings, then a series | scale, then one atan |

## Pass 1: cheap bounds

Two new rows for the table in
[Cheap bounds](../2026-11-03%20Precision%20for%20whole%20expressions/README.md#cheap-bounds).
Here $w = 10^{-5}$.

| Node | Cheap interval |
|---|---|
| $\mathrm{atan}(x)$ | $[\max(a_1 - w, -1.5708), \min(a_2 + w, 1.5708)]$, where $a_1$ and $a_2$ are $\mathrm{atan}(\ell)$ and $\mathrm{atan}(h)$ to 5 places |
| $\mathrm{atan2}(y, x)$ | the smallest value at the four corners of $[\ell_x, h_x] \times [\ell_y, h_y]$ minus $w$, to the largest plus $w$, each corner to 5 places, if $\ell_x > 0$, $\ell_y > 0$ or $h_y < 0$; otherwise $[-3.1416, 3.1416]$ |

For atan, if $\ell > 0$, the lower end can also be raised to
$\frac{1}{2}\min(\ell, 1)$, and if $h < 0$, the upper end lowered to
$-\frac{1}{2}\min(|h|, 1)$.

### Arctangent

atan is increasing, so its values on $[\ell, h]$ fill
$[\mathrm{atan}(\ell), \mathrm{atan}(h)]$. The ends are computed to 5 places
by the [procedure below](#evaluating-atan), so each is within $w$ of the
true value, as in the square root row. Every arctangent is between
$-\frac{\pi}{2}$ and $\frac{\pi}{2}$, so the ends can be clipped to
$\pm 1.5708$.

The extra lower bound matters when a parent needs one, such as a divisor. For
a tiny argument, the 5-place ends round to 0 and the interval contains 0. But
the sign of $\mathrm{atan}(x)$ is the sign of $x$, and for $t \ge 0$:

- **If t is at most 1,** atan is concave there, so $\mathrm{atan}(t) \ge \frac{\pi}{4}t \ge \frac{t}{2}$.
- **If t is above 1,** $\mathrm{atan}(t) > \frac{\pi}{4} > \frac{1}{2}$.

So $|\mathrm{atan}(x)| \ge \frac{1}{2}\min(L_x, 1)$, with no tightening.

### Two-argument arctangent

If $\ell_x > 0$, the box is in the right half-plane. If $\ell_y > 0$ or
$h_y < 0$, it is in the upper or lower half-plane. Any of these keeps the box
off the cut and the origin. Then the angles of its points form an interval
whose ends are the angles of two corners: a convex shape that avoids the origin
is seen from the origin within an angle less than $\pi$, and its extreme
directions are at its corners. Off the cut, atan2 turns that angle into an
interval of values without a jump.

Otherwise the box may touch the cut, where atan2 jumps between about $\pi$
and $-\pi$, and the only safe interval is all of $(-\pi, \pi]$. A parent that
needs a lower bound then triggers tightening of the atan2 node, and its own
tightening of $y$, below, usually settles it.

## Tightening

[Tightening by evaluation](../2026-11-03%20Precision%20for%20whole%20expressions/README.md#tightening-by-evaluation)
lists the children that need a lower bound above 0. Add:

- **The y of an atan2,** unless $\ell_x > 0$.

This is tightening for sign, not size. The atan2 rule needs $L_y$, or $x > 0$:
without either, the true angle could be near $\pi$ or near $-\pi$, depending on
the sign of $y$. See
[the cut](../2026-11-03%20Input%20places%20for%20atan%20and%20atan2/README.md#the-cut-and-the-origin).

Tightening $x$ as well is optional. If $y$'s lower bound comes out small and
$x$'s interval contains 0, tightening $x$ can raise
$M = \max(L_x, L_y)$, which saves places in every child. It only helps if
$x$ isn't itself close to 0.

atan needs no tightening. Its rule works without a lower bound, and one only
saves places.

## Pass 2: places

Two new rows for the table in
[Rules for each operation](../2026-11-03%20Precision%20for%20whole%20expressions/README.md#rules-for-each-operation):

| Node | Places for its children |
|---|---|
| $\mathrm{atan}(x)$ | $d + 1$, or with $L_x$: $\max(d + 1 - 2\max(0, \mathrm{siz}(0.99L_x) - 1), 3 - \mathrm{siz}(L_x))$ |
| $\mathrm{atan2}(y, x)$ | each inexact child: $d + 2 - \mathrm{siz}(0.99M)$, at least the minimum places $3 - \mathrm{siz}(L)$ of each lower bound used |

Here $M$ is the larger of $L_x$ and $L_y$, among those that exist. The atan2
row applies when $L_y$ exists, or when $\ell_x > 0$, and tightening has made
one of these true.

Notes:

- **The minimum places of y** matter even when $M$ comes from $x$. They keep
  $\tilde{y}$ on the same side of 0 as $y$, so the computed angle is on the
  same side of the cut as the true one.
- **One exact child** doesn't let the other take fewer places. Giving it the
  whole budget saves only $\log 2$, which the rule's rounding absorbs.
- **Large arguments** can make the atan rule ask for few places, or a negative
  number of places, which means rounding to tens, hundreds and so on. That's
  allowed: $\mathrm{rnd}(1234, -2) = 1200$.

## Pass 3: evaluating atan

The arctangent series converges slowly near 1, so first move the argument
to a small one, as in the logarithm section of Functions by series. Use the
[half-angle form](../2026-11-03%20atan2%20identities%20revisited/README.md#the-half-angle-form)
twice.

**Rule.** To evaluate $\mathrm{atan}(\tilde{x})$ for a node with $d$ places,
with $p = d + 2$:

**Reciprocal.** If $|\tilde{x}| > 1$, compute $w = 1/\tilde{x}$ to $p$
places, and use
$\mathrm{atan}(\tilde{x}) = \mathrm{sgn}(\tilde{x}) \cdot \frac{\pi}{2} - \mathrm{atan}(w)$.
Otherwise $w = \tilde{x}$.

**Halve twice.** Starting from $v = w$, twice compute

$$
s = \sqrt{1 + v^2}, \qquad v \leftarrow \frac{v}{1 + s},
$$

each to $p$ places, rounded or cut off. $v^2$ is exact. Then
$\mathrm{atan}(w) = 4\mathrm{atan}(v)$, with $|v| \le 0.21$ and
$v^2 \le 0.045$.

**Series.** Starting from $P_0 = t_0 = v$, for each $n \ge 1$ compute

$$
P_n = P_{n-1} \cdot v^2, \qquad t_n = \frac{(-1)^n P_n}{2n + 1},
$$

each to $p_n = d + 1 + 2\mathrm{siz}(n)$ places, and add the terms as you
go.

**Stop** after the first term with
$\mathrm{siz}(\tilde{t}_N) \le -(d + 1)$, including that term, as in the
[series rule](../2026-11-02%204%20Functions%20by%20series/README.md#the-series-rule).

**Combine.** $4 \cdot (\text{sum})$, or
$\mathrm{sgn}(\tilde{x}) \cdot \frac{\pi}{2} - 4 \cdot (\text{sum})$ with
$\frac{\pi}{2}$ to $p$ places.

The result is within $0.18T$ of $\mathrm{atan}(\tilde{x})$. That's more than the $T/10$ of computing to $d + 1$ places, but
it is inside the $T/2$ left after the input error, which is all the method
needs.

**Example.** For $\mathrm{atan}(10\pi)$ rounded to 6 places, take $d = 8$. The
atan rule gives $10\pi$ to 7 places: $\tilde{x} = 31.4159265$. Then
$p = 10$.

**Reciprocal.** $w = 1/31.4159265$, to 10 places, is $0.0318309887$.

**Halve twice.** The first halving gives $v = 0.0159114649$ and the second
$v = 0.0079552290$.

**Series.** With $p_n = 11$ places, and stopping after the first term with
$\mathrm{siz} \le -9$:

| $n$ | $\tilde{P}_n$ | $\tilde{t}_n$ | $\mathrm{siz}(\tilde{t}_n)$ |
|---|---|---|---|
| 0 | $0.0079552290$ | $0.0079552290$ | $-2$ |
| 1 | $0.00000050345$ | $-0.00000016782$ | $-6$ |
| 2 | $0.00000000003$ | $0.00000000001$ | $-10$ |

The sum is $0.00795506119$.

**Combine.** $1.5707963268 - 4 \cdot 0.00795506119 = 1.53897608204$, which
rounds to $1.538976$. The true value of $\mathrm{atan}(10\pi)$ is
$1.5389760821\ldots$

**Why.** Every rounding at $p$ places has error at most
$u = 10^{-p} = 0.01T$. The errors are:

| Source | Error at most |
|---|---|
| $\frac{\pi}{2}$ | $u = 0.01T$ |
| $w$ | $u$, carried with weight 1: $0.01T$ |
| first halving | $1.26u$, carried with weight 2: $0.026T$ |
| second halving | $1.26u$, carried with weight 4: $0.051T$ |
| series rounding | $4 \cdot 1.35 \cdot 0.01T = 0.054T$ |
| series tail | $4 \cdot 0.045 \cdot 0.12T < 0.022T$ |

The total is under $0.18T$. The weights come from three facts:

- **Halving shrinks errors.** The map $g(v) = \frac{v}{1 + \sqrt{1 + v^2}}$ has
  $g'(v) = \frac{1}{\sqrt{1 + v^2}(1 + \sqrt{1 + v^2})} \le \frac{1}{2}$, so an
  error in $v$ is at most halved by each later halving.
- **Combining multiplies by 4.** The derivative of atan is at most 1, so an
  error in the final $v$ reaches $4\mathrm{atan}(v)$ multiplied by at most 4.
  An error in $w$ is halved twice and then multiplied by 4, for weight 1.
- **Each halving adds 1.26u.** The division adds $u$. An error in $s$ moves
  $\frac{v}{1 + s}$ by at most $\frac{|v|}{(1 + s)^2} \le \frac{1.01}{4}$ times
  as much, since $s \ge 1$, which adds $0.26u$.

The series rows follow the
[logarithm](../2026-11-02%204%20Functions%20by%20series/README.md#logarithms)
analysis with $v^2$ in place of $z^2$. Each rounding error of size $u_n$ adds
at most $(1.048/3 + 1)u_n < 1.35u_n$ to the sum, using
$\frac{1}{1 - v^2} \le 1.048$, and $\sum u_n = 0.01T$ with
$p_n = d + 1 + 2\mathrm{siz}(n)$. The sum is then multiplied by 4. The
terms alternate and shrink, so the tail is at most the next term, which is at
most $v^2|t_N|$, and $|t_N| < 0.1T + 0.02T$.

The bounds on $v$: $|w| \le 1$, since rounding $1/\tilde{x}$ can't push it past
1, but atan2 below calls this with $|w|$ up to just over 1. With $|w| \le 1.01$,
the first halving gives at most $\tan(\frac{1}{2}\mathrm{atan}(1.01)) < 0.42$,
and the second at most $\tan(\frac{1}{4}\mathrm{atan}(1.01)) < 0.21$.

Two halvings is a balance. One leaves $v$ up to $0.42$, so the series needs
more than twice as many terms. Three cost a third square root and division,
for terms that would mostly fall below the stopping size anyway.

## Pass 3: evaluating atan2

Use the stable form from the revisited doc, rearranged so that every division
is by a number at least $r$.

**Rule.** To evaluate $\mathrm{atan2}(\tilde{y}, \tilde{x})$ for a node with
$d$ places, with $p = d + 2$:

**On the cut.** If $\tilde{y} = 0$ and $\tilde{x} < 0$, the value is $\pi$.
The places rule makes this happen only when $y$ is exactly 0.

**Scale.** Multiply $\tilde{x}$ and $\tilde{y}$ by $10^s$, with
$s = 1 - \mathrm{siz}(\max(|\tilde{x}|, |\tilde{y}|))$, so that the larger is
between 1 and 10. This moves the decimal point, so it is exact, and it
doesn't change the angle.

**Radius.** Compute $r = \sqrt{\tilde{x}^2 + \tilde{y}^2}$ to $p$ places. The
sum of squares is exact.

**Quotient and angle.**

$$
\mathrm{atan2}(\tilde{y}, \tilde{x}) =
\begin{cases}
2\mathrm{atan}(q), \quad q = \dfrac{\tilde{y}}{r + \tilde{x}}, & \tilde{x} \ge 0 \\
\mathrm{sgn}(\tilde{y}) \cdot \pi - 2\mathrm{atan}(q), \quad q = \dfrac{\tilde{y}}{r - \tilde{x}}, & \tilde{x} < 0
\end{cases}
$$

with $q$ and $\pi$ to $p$ places, and $\mathrm{atan}(q)$ by the procedure
above with $d + 1$ in place of $d$.

The result is within $0.1T$ of $\mathrm{atan2}(\tilde{y}, \tilde{x})$, the
same as computing to $d + 1$ places.

**Where the second case comes from.** The revisited doc gives
$2\mathrm{atan}\frac{r - x}{y}$ for $x < 0$. Its argument is the reciprocal of
$\frac{y}{r - x}$, since $(r - x)(r + x) = y^2$, and
$\mathrm{atan}(t) = \mathrm{sgn}(t) \cdot \frac{\pi}{2} - \mathrm{atan}(\frac{1}{t})$
for $t \ne 0$. That gives the second case, which divides by $r - x \ge r$
instead of by $y$. So evaluation needs only the sign of $\tilde{y}$, which the
places rule guarantees matches $y$, not a lower bound on its size. In both
cases $|q| \le 1$, up to rounding.

**Why.** After scaling, $r \ge 1$. In both cases $q$ is
$\frac{\tilde{y}}{r \pm \tilde{x}}$ with $r \pm \tilde{x} \ge r$, so moving
$r$ by $u$ moves $q$ by at most $\frac{|\tilde{y}|}{r^2}u \le u$. And moving
$q$ moves the angle by at most twice as much, since the derivative of atan is
at most 1. So, with $u = 10^{-p} = 0.01T$:

| Source | Error at most |
|---|---|
| $r$ | $2u = 0.02T$ |
| $q$ | $2u = 0.02T$ |
| $\mathrm{atan}(q)$, with $d + 1$ | $2 \cdot 0.18 \cdot 0.1T = 0.036T$ |
| $\pi$ | $u = 0.01T$ |

The total is under $0.09T$.

Without the scaling, $r$ could be tiny, and then small errors in $r$ would
move $q$ a lot. Scaling by a power of 10 fixes that for free.

## Example

### atan2(sin(π − 0.00001), −1) to 8 places

This point is $10^{-5}$ above the negative x-axis, so its angle is just below
$\pi$, and a small error in the sign of the sine would put it near $-\pi$
instead. Take $d = 10$ for the top node.

**Bounds.** The $x$ child is the exact number $-1$, so $\ell_x \le 0$. The
sine's cheap interval is $[-1, 1]$, which contains 0, so tighten it. To 5
places the sine comes out as $0.000010$, so it is in $[0, 0.00002]$, which
doesn't exclude 0. To 10 places it is $0.00001000000$, so it is in
$[0.0000099999, 0.0000100001]$. So $L_y = 0.0000099999$, of size $-5$, and
$L_x = 1$.

The box $[-1, -1] \times [0.0000099999, 0.0000100001]$ is in the upper
half-plane, so the atan2 node's cheap interval comes from its corners:
$[3.14157, 3.14159]$.

**Places.** $M = \max(1, 0.0000099999) = 1$, and $\mathrm{siz}(0.99) = 0$.

| Node | Asks | For |
|---|---|---|
| atan2, with 10 places | $\max(10 + 2 - 0, 3 + 5) = 12$ | the sine; $-1$ is exact |
| $\sin(\ldots)$, with 12 places | $12 + 1 = 13$ | its argument |
| $\pi - 0.00001$, with 13 places | $13$, since $0.00001$ is exact | $\pi$ |

Being $10^{-5}$ from the cut costs nothing here. $M$ comes from $x$, so the
sine needs no more places than if the point were far from the cut. Its minimum
places, 8, are what pin its sign, and the rule asks for 12 anyway.

**Evaluate.** $\pi$ to 13 places is $3.1415926535898$, so the argument is
$3.1415826535898$. Its sine to 13 places is
$\tilde{y} = 0.0000100000000$.

For the atan2, scale by $10^0$, since $|\tilde{x}| = 1$ is already the
larger. $\tilde{x} < 0$, so the second case applies, and the angle comes out
as $3.14158265359000$, which rounds to $3.14158265$. The true value is
$3.1415826535897\ldots$

The correct-rounding check passes: $3.14158265359$ is about
$1.4 \times 10^{-9}$ from the boundary $3.141582655$, more than
$10^{-d} = 10^{-10}$.

## Corner cases

These add to the
[corner cases](../2026-11-03%20Precision%20for%20whole%20expressions/README.md#corner-cases)
of the main doc.

### y exactly 0

$\mathrm{atan2}(0, x)$ is 0 for $x > 0$ and $\pi$ for $x < 0$, but tightening
an exact 0 never excludes 0, so it would hit the cap. When pass 1 finds an
exact 0 for $y$, replace the node with the exact 0 if $\ell_x > 0$, or with
the constant $\pi$ if $h_x < 0$. If $x$'s interval contains 0, tighten $x$
for its sign.

### The origin

$\mathrm{atan2}(0, 0)$ is undefined. If both children are exactly 0, or
tightening can't move either interval off 0, report it like
[an exact singularity](../2026-11-03%20Precision%20for%20whole%20expressions/README.md#exact-singularities).

### Angles that only matter up to 2π

$\sin(\mathrm{atan2}(y, x))$ and $\cos(\mathrm{atan2}(y, x))$ don't jump at
the cut, but the atan2 rule doesn't know that, and still tightens $y$. If $y$
is close to 0, that costs evaluations for nothing, and if $y$ is exactly 0
with $x$'s sign unknown, it fails. Rewrite these symbolically first:
$\sin(\mathrm{atan2}(y, x)) = \frac{y}{r}$ and
$\cos(\mathrm{atan2}(y, x)) = \frac{x}{r}$, with $r = \sqrt{x^2 + y^2}$.

### Cheap bounds for atan of a tiny argument

For an argument like $10^{-20}$, the 5-place ends of the atan interval are 0.
The bound $|\mathrm{atan}(x)| \ge \frac{1}{2}\min(L_x, 1)$ from pass 1
gives a lower bound without evaluating anything. Without it, a parent that
divides by $\mathrm{atan}(x)$ would trigger tightening.
