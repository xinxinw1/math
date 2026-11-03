# Sums of conjugate complex roots

For which nonzero integers $a$ and $b$ is

$$
S = \sqrt{a + bi} + \sqrt{a - bi}
$$

a nice number?

*Xin-Xin*

This builds on
[Sums of conjugate nested roots](../2026-11-03%202%20Sums%20of%20conjugate%20nested%20roots/README.md),
which asks the same question for $\sqrt{a \pm \sqrt{b}}$ with $b$ squarefree.
Here the inner root is replaced by $bi = \sqrt{-b^2}$, a square root of a
negative square, and the answer changes: $S$ can now be an integer.

Throughout, $\sqrt{z}$ is the principal square root, the one with positive real
part, and $c = \sqrt{a^2 + b^2} = |a + bi|$.

## Answer

$$
\boxed{S = \sqrt{2(a + c)}}
$$

always, and there are three levels of niceness.

**Level 1.** $S$ is an integer exactly when $a + bi$ is the square of a
Gaussian integer:

$$
a + bi = (p + qi)^2, \qquad a = p^2 - q^2, \qquad b = 2pq,
$$

for nonzero integers $p$ and $q$ with $|p| \ne |q|$. Then $S = 2|p|$. In
particular, $b$ must be even. $S$ is rational only when it is an integer.

**Level 2.** $S = \sqrt{n}$ for an integer $n$ exactly when $a^2 + b^2 = c^2$,
that is, $|a|$, $|b|$ and $c$ form a Pythagorean triple. Then $n = 2(a + c)$.

**Level 3.** Otherwise $S$ stays nested: it can't be written as
$\sqrt{p} + \sqrt{q}$ with rational $p$ and $q$.

## The principal square root

Let

$$
r = \sqrt{\frac{c + a}{2}}, \qquad s = \sqrt{\frac{c - a}{2}}.
$$

These are real, because $c \ge |a|$. Then

$$
r^2 - s^2 = \frac{(c + a) - (c - a)}{2} = a,
\qquad
2rs = 2\sqrt{\frac{c^2 - a^2}{4}} = \sqrt{b^2} = |b|.
$$

So for $b > 0$,

$$
(r + si)^2 = r^2 - s^2 + 2rsi = a + bi.
$$

For $b < 0$, $(r - si)^2 = a + bi$ instead. Since $b \ne 0$, $c > |a|$, so
$r > 0$, and this is the principal square root:

$$
\sqrt{a \pm bi} = \sqrt{\frac{c + a}{2}} \pm i\sqrt{\frac{c - a}{2}}
$$

for $b > 0$. This is the formula from
[Denesting square roots revisited](../2026-11-03%201%20Denesting%20square%20roots%20revisited/README.md)
with $x = a$ and $y = -b^2$, so that $\sqrt{y} = bi$ and $x^2 - y = c^2$.

The two roots are complex conjugates, so the imaginary parts cancel in the sum:

$$
S = 2r = 2\sqrt{\frac{c + a}{2}} = \sqrt{2(a + c)}.
$$

Here $b \ne 0$ matters. For $b = 0$ and $a < 0$, both roots would be
$i\sqrt{|a|}$, and the sum $2i\sqrt{|a|}$ wouldn't be real.

## Level 1: integers

Suppose $S = m$ is an integer. Write the principal root as

$$
\sqrt{a + bi} = \frac{m}{2} + yi,
$$

where $y = \pm s$ is real. Squaring and comparing real and imaginary parts:

$$
\frac{m^2}{4} - y^2 = a, \qquad my = b.
$$

**Step 1.** $y$ is rational. $m \ne 0$, since otherwise $b = my = 0$. So
$y = b/m$.

**Step 2.** $2y$ is an integer $t$. From the real part,
$(2y)^2 = m^2 - 4a$ is an integer, and $2y$ is rational. A rational number
whose square is an integer is an integer.

**Step 3.** $m$ and $t$ are both even. From the imaginary part, $mt = 2b$ is
even, so one of $m$ and $t$ is even. From the real part,
$t^2 - m^2 = -4a$ is even, so $m$ and $t$ have the same parity.

**Step 4.** Write $m = 2p$ and $t = 2q$. Then $y = q$, and

$$
a = \frac{m^2}{4} - y^2 = p^2 - q^2, \qquad b = my = 2pq.
$$

So $a + bi = (p + qi)^2$, and $S = m = 2p$. Here $p > 0$ because $S = 2r > 0$.
Since $a$ and $b$ are nonzero, $p$ and $q$ are nonzero and $|p| \ne |q|$.

Conversely, if $a + bi = (p + qi)^2$, then $\pm(p + qi)$ are the square roots,
the principal one has real part $|p|$, and $S = 2|p|$.

## Level 2: square roots of integers

$S^2 = 2a + 2c$ is rational exactly when $c$ is. Since $c^2 = a^2 + b^2$ is an
integer, $c$ is rational exactly when it is an integer, which means
$a^2 + b^2 = c^2$ is a Pythagorean triple (with the signs of $a$ and $b$
ignored).

Level 1 is a special case. Every Gaussian square gives a Pythagorean triple,
$(p^2 - q^2)^2 + (2pq)^2 = (p^2 + q^2)^2$, but not every triple comes from a
Gaussian square in this order. $3 + 4i = (2 + i)^2$, but $4 + 3i$ isn't a
Gaussian square, because $b = 3$ is odd.

## Level 3: everything else

If $a^2 + b^2$ isn't a square, $S^2 = 2a + 2c$ is irrational. Since $S > 0$,

$$
S = \sqrt{x + \sqrt{y}} \qquad \text{with } x = 2a \text{ and } y = 4(a^2 + b^2).
$$

Here $\sqrt{y} = 2c$ is irrational and $x^2 - y = -4b^2$ is negative, so it
isn't the square of a rational number. By the uniqueness result in
[Denesting square roots revisited](../2026-11-03%201%20Denesting%20square%20roots%20revisited/README.md),
$S$ can't be written as $\sqrt{p} + \sqrt{q}$ with rational $p, q \ge 0$.

## Examples

| $a + bi$ | $c$ | Expression | Why |
|---|---|---|---|
| $3 + 4i$ | 5 | $\sqrt{3 + 4i} + \sqrt{3 - 4i} = 4$ | $(2 + i)^2$ |
| $-3 + 4i$ | 5 | $\sqrt{-3 + 4i} + \sqrt{-3 - 4i} = 2$ | $(1 + 2i)^2$ |
| $5 + 12i$ | 13 | $\sqrt{5 + 12i} + \sqrt{5 - 12i} = 6$ | $(3 + 2i)^2$ |
| $-5 + 12i$ | 13 | $\sqrt{-5 + 12i} + \sqrt{-5 - 12i} = 4$ | $(2 + 3i)^2$ |
| $8 + 6i$ | 10 | $\sqrt{8 + 6i} + \sqrt{8 - 6i} = 6$ | $(3 + i)^2$ |
| $4 + 3i$ | 5 | $\sqrt{4 + 3i} + \sqrt{4 - 3i} = \sqrt{18} = 3\sqrt{2}$ | Pythagorean, $b$ odd |
| $12 + 5i$ | 13 | $\sqrt{12 + 5i} + \sqrt{12 - 5i} = \sqrt{50} = 5\sqrt{2}$ | Pythagorean, $b$ odd |
| $6 + 8i$ | 10 | $\sqrt{6 + 8i} + \sqrt{6 - 8i} = \sqrt{32} = 4\sqrt{2}$ | Pythagorean, not a Gaussian square |
| $1 + i$ | $\sqrt{2}$ | $\sqrt{1 + i} + \sqrt{1 - i} = \sqrt{2 + 2\sqrt{2}}$ | stays nested |
| $1 + 2i$ | $\sqrt{5}$ | $\sqrt{1 + 2i} + \sqrt{1 - 2i} = \sqrt{2 + 2\sqrt{5}}$ | stays nested |

$6 + 8i$ shows that $b$ being even isn't enough. It is $2(3 + 4i)$, and 2
isn't a Gaussian square.

A brute-force check over all $|a|, |b| \le 60$ agreed with the formula for $S$
and with Level 1.

## Comparison with the previous doc

Writing $bi = \sqrt{-b^2}$ turns this into the question of the previous doc,
$\sqrt{a + \sqrt{b'}} + \sqrt{a - \sqrt{b'}}$, with $b' = -b^2$. Its "Negative
b" section already had the formula $S = \sqrt{2a + 2\sqrt{a^2 - b'}}$. The
difference is that $b'$ is now a negative square instead of squarefree. In the
previous doc, squarefreeness forced the factors $u$ and $v$ to be odd, and
that ruled out integer values of $S$. Here nothing does, and integer values
come from Gaussian squares.

## Lean proof

`ComplexSums.lean` formalizes the main steps using Mathlib.

> **Status:** not checked yet. Lean couldn't be installed in the environment
> where this was written.

| Theorem | Statement |
|---|---|
| `parts` | With $c = \sqrt{a^2 + b^2}$, $r$ and $s$ as above: $r^2 - s^2 = a$, $2rs = \lvert b \rvert$ and $(2r)^2 = 2(a + c)$ |
| `gaussian_sq` | $(p + qi)^2 = (p^2 - q^2) + 2pqi$ |
| `gaussian_of_int` | If $m^2/4 - y^2 = a$ and $my = b$ with $m, a, b$ integers and $b \ne 0$, then $m = 2p$, $y = q$, $a = p^2 - q^2$ and $b = 2pq$ for integers $p, q$ (Steps 1 to 4) |

`parts` shows that $r \pm si$ squares to $a + bi$ and has positive real part.
That it is the principal square root as Mathlib defines it (through
`Complex.cpow`) isn't formalized, and neither are Levels 2 and 3.

To check it, see the [root README](../README.md) for installing Lean. Then,
from this directory:

```bash
lake exe cache get
```

```bash
lake build
```

`lake exe cache get` downloads prebuilt Mathlib files, which saves building
Mathlib from source.
