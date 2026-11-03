# Sums of conjugate nested roots

For which integers $a$ and $b$, with $b$ squarefree, is

$$
S = \sqrt{a + \sqrt{b}} + \sqrt{a - \sqrt{b}}
$$

a nice number?

*Xin-Xin*

This builds on
[Denesting square roots revisited](../2026-11-03%201%20Denesting%20square%20roots%20revisited/README.md),
which shows when $\sqrt{x + \sqrt{y}}$ can be written as $\sqrt{p} + \sqrt{q}$.

Throughout, $b > 1$ is squarefree and $a \ge \sqrt{b}$, so that both nested
roots are real. ($b = 1$ is squarefree too, but then $\sqrt{b}$ is rational and
nothing is nested.)

## Answer

$S$ is never rational. The best it can be is a single square root
$\sqrt{n}$ of an integer, and that happens exactly when $b$ factors as

$$
b = uv \qquad \text{with integers } 1 \le u < v,
$$

and $a = \frac{u + v}{2}$. Then

$$
\boxed{\sqrt{a + \sqrt{b}} + \sqrt{a - \sqrt{b}} = \sqrt{2v}}
$$

and $u$ and $v$ are both odd. In particular, an even $b$ never works, and
an odd $b$ with $k$ prime factors works for exactly $2^{k-1}$ values of $a$,
one for each way to split $b$ into two factors.

For any other $a$, $S$ can't even be written as $\sqrt{p} + \sqrt{q}$ with
rational $p$ and $q$.

## Squaring the sum

The product of the two nested roots is

$$
\sqrt{a + \sqrt{b}}\sqrt{a - \sqrt{b}} = \sqrt{(a + \sqrt{b})(a - \sqrt{b})} = \sqrt{a^2 - b},
$$

so

$$
S^2 = (a + \sqrt{b}) + (a - \sqrt{b}) + 2\sqrt{a^2 - b} = 2a + 2\sqrt{a^2 - b}.
$$

Everything depends on whether $a^2 - b$ is a perfect square. A square root of
a nonnegative integer is either an integer or irrational, so there are two
cases.

## Case 1: a² − b is a square

Say $a^2 - b = c^2$ with $c \ge 0$ an integer. Then

$$
S^2 = 2a + 2c, \qquad S = \sqrt{2(a + c)}.
$$

Write $u = a - c$ and $v = a + c$. Then

$$
b = a^2 - c^2 = (a - c)(a + c) = uv,
$$

and $a = \frac{u + v}{2}$, $S = \sqrt{2v}$. A few things follow.

**Step 1.** $u$ and $v$ are positive. Since $a \ge \sqrt{b} > 0$ and
$a^2 - c^2 = b > 0$, $a > c \ge 0$, so $u = a - c > 0$.

**Step 2.** $u < v$. Otherwise $c = 0$ and $b = a^2$, which isn't squarefree
for $b > 1$.

**Step 3.** $u$ and $v$ are both odd. They differ by $2c$, so they have the same
parity. If both were even, $4$ would divide $b = uv$, but $b$ is squarefree.
So $b$ is a product of two odd numbers, and in particular $b$ is odd.

**Step 4.** $S$ is not rational. $S^2 = 2v$ is an integer, so if $S$ were
rational it would be an integer. But $2v$ with $v$ odd is divisible by 2 and
not by 4, so it isn't a perfect square.

Conversely, any factorization $b = uv$ with $1 \le u < v$ gives an $a$ that
works, with $c = \frac{v - u}{2}$. Both $u$ and $v$ are odd here, since $b$
must be odd, so $a$ and $c$ are integers.

Each nested root also denests on its own, by the formula from the previous doc
with $x = a$ and $\sqrt{x^2 - y} = c$:

$$
\sqrt{a \pm \sqrt{b}} = \sqrt{\frac{v}{2}} \pm \sqrt{\frac{u}{2}}.
$$

Adding the two, the $\sqrt{u/2}$ terms cancel and
$2\sqrt{v/2} = \sqrt{2v}$ is left.

## Case 2: a² − b is not a square

Then $\sqrt{a^2 - b}$ is irrational, and so is $S^2$. Since $S \ge 0$,

$$
S = \sqrt{x + \sqrt{y}} \qquad \text{with } x = 2a \text{ and } y = 4(a^2 - b).
$$

Here $\sqrt{y}$ is irrational and $x^2 - y = 4b$ isn't a rational square,
because $b > 1$ is squarefree. By the uniqueness result in the previous doc,
$S$ can't be written as $\sqrt{p} + \sqrt{q}$ with rational $p, q \ge 0$. It
stays nested.

## Examples

| $b$ | $b = u \cdot v$ | $a$ | $S$ |
|---|---|---|---|
| 2 | none with $u, v$ odd | — | never nice |
| 3 | $1 \cdot 3$ | 2 | $\sqrt{6}$ |
| 5 | $1 \cdot 5$ | 3 | $\sqrt{10}$ |
| 6 | none with $u, v$ odd | — | never nice |
| 7 | $1 \cdot 7$ | 4 | $\sqrt{14}$ |
| 15 | $1 \cdot 15$ | 8 | $\sqrt{30}$ |
| 15 | $3 \cdot 5$ | 4 | $\sqrt{10}$ |
| 105 | $1 \cdot 105$ | 53 | $\sqrt{210}$ |
| 105 | $3 \cdot 35$ | 19 | $\sqrt{70}$ |
| 105 | $5 \cdot 21$ | 13 | $\sqrt{42}$ |
| 105 | $7 \cdot 15$ | 11 | $\sqrt{30}$ |

A brute-force search over every squarefree $b < 200$ and every $a < 400$
found exactly the pairs this predicts.

The first row with an answer connects to the previous doc:
$\sqrt{2 \pm \sqrt{3}} = \frac{\sqrt{6} \pm \sqrt{2}}{2}$, and adding the two
gives $\sqrt{6}$.

A non-example: $b = 15$, $a = 5$. Then $a^2 - b = 10$ isn't a square, and
$S = \sqrt{10 + 2\sqrt{10}}$ doesn't denest.

## Negative b

With principal complex square roots, the same answer holds for negative
squarefree $b$, and $a$ can be any integer. The two nested roots are complex
conjugates, so $S = 2\mathrm{Re}\sqrt{a + i\sqrt{|b|}}$ is real, and it still
squares to $2a + 2\sqrt{a^2 - b}$. The factorization $b = uv$ now has $u < 0 < v$.
For example, $b = -1 = (-1) \cdot 1$ gives $a = 0$ and

$$
\sqrt{i} + \sqrt{-i} = \sqrt{2}.
$$

The Lean proof below only covers $b \ge 0$.

## Lean proof

`ConjugateSums.lean` formalizes the main steps using Mathlib. `S a b` is
defined as $\sqrt{a + \sqrt{b}} + \sqrt{a - \sqrt{b}}$.

> **Status:** not checked yet. Lean couldn't be installed in the environment
> where this was written.

| Theorem | Statement |
|---|---|
| `S_sq` | For real $b \ge 0$ and $a \ge \sqrt{b}$, $S^2 = 2a + 2\sqrt{a^2 - b}$ |
| `S_of_factors` | For real $0 \le u \le v$, $S$ at $a = \frac{u + v}{2}$ and $b = uv$ is $\sqrt{2v}$ |
| `sq_rat_iff` | For integers with $b \ge 0$ and $a \ge \sqrt{b}$, $S^2$ is rational exactly when $a^2 - b = c^2$ for an integer $c \ge 0$ |
| `S_ne_rat` | For integers with $b \ge 0$ squarefree and $a \ge \sqrt{b}$, $S$ is not rational |

The factorization into odd $u < v$ (Steps 1 to 3) and Case 2 are not
formalized.

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
