# Denesting square roots revisited

When $\sqrt{x \pm \sqrt{y}}$ can be written as $\sqrt{a} \pm \sqrt{b}$, and how
to find $a$ and $b$.

*Xin-Xin*

This builds on [Denesting square roots](../2015-03-15%20Denesting%20square%20roots/README.md),
which derives the formula. This doc states the formula first, checks it
directly, and shows that it gives the only possible denesting.

## The formula

For real numbers with $y \ge 0$ and $x \ge \sqrt{y}$:

$$
\boxed{\sqrt{x \pm \sqrt{y}} =
\sqrt{\frac{x + \sqrt{x^2 - y}}{2}} \pm
\sqrt{\frac{x - \sqrt{x^2 - y}}{2}}}
$$

Taking out the factor $\frac{1}{\sqrt{2}} = \frac{\sqrt{2}}{2}$ gives an
equivalent form:

$$
\sqrt{x \pm \sqrt{y}} =
\frac{\sqrt{2}}{2}\left(\sqrt{x + \sqrt{x^2 - y}} \pm \sqrt{x - \sqrt{x^2 - y}}\right)
$$

The formula always holds, but it only removes the nesting when $x^2 - y$ is a
perfect square. [Only one denesting](#only-one-denesting) shows that no other
choice of $a$ and $b$ can do better.

## Coefficients on the inner root

Expressions usually come with a coefficient on the inner root, as in
$\sqrt{7 + 4\sqrt{3}}$. Move it inside first: $4\sqrt{3} = \sqrt{16 \cdot 3} = \sqrt{48}$,
so $x = 7$ and $y = 48$. Then $x^2 - y = 49 - 48 = 1$, and

$$
\sqrt{7 + 4\sqrt{3}} = \sqrt{\frac{7 + 1}{2}} + \sqrt{\frac{7 - 1}{2}} = 2 + \sqrt{3}.
$$

In general, $\sqrt{x \pm c\sqrt{z}}$ with $c \ge 0$ uses $y = c^2 z$.

## Where it comes from

Look for $a$ and $b$ with $\sqrt{x \pm \sqrt{y}} = \sqrt{a} \pm \sqrt{b}$.
Squaring the right-hand side:

$$
(\sqrt{a} \pm \sqrt{b})^2 = a + b \pm 2\sqrt{ab} = (a + b) \pm \sqrt{4ab}
$$

so it's enough to have $a + b = x$ and $4ab = y$. Then $a$ and $b$ are the two
roots of

$$
t^2 - xt + \frac{y}{4} = 0,
$$

which are $\frac{x \pm \sqrt{x^2 - y}}{2}$. Take $a$ to be the larger one:

$$
a = \frac{x + \sqrt{x^2 - y}}{2}, \qquad b = \frac{x - \sqrt{x^2 - y}}{2}
$$

The 2015 notes give this derivation step by step.

## Checking the formula directly

The derivation shows what $a$ and $b$ must be. To see that they work, write
$d = \sqrt{x^2 - y}$. Then

$$
a + b = \frac{(x + d) + (x - d)}{2} = x,
\qquad
ab = \frac{x^2 - d^2}{4} = \frac{x^2 - (x^2 - y)}{4} = \frac{y}{4}.
$$

So $2\sqrt{ab} = 2\sqrt{y/4} = \sqrt{y}$, and

$$
(\sqrt{a} \pm \sqrt{b})^2 = a + b \pm 2\sqrt{ab} = x \pm \sqrt{y}.
$$

Taking square roots of both sides gives the formula, as long as every step is
allowed. That is what the conditions are for:

**Step 1.** $d$ is real. Since $0 \le \sqrt{y} \le x$, squaring gives $y \le x^2$.

**Step 2.** $a$ and $b$ are at least 0. Since $y \ge 0$, $d^2 = x^2 - y \le x^2$, so
$d \le x$. Then $b = \frac{x - d}{2} \ge 0$, and $a \ge b$.

**Step 3.** $\sqrt{ab}$ splits as $\sqrt{a}\sqrt{b}$. This needs $a, b \ge 0$, which
was just shown.

**Step 4.** Taking the square root undoes the square: $\sqrt{u^2} = u$ only when
$u \ge 0$. For the plus sign, $\sqrt{a} + \sqrt{b} \ge 0$ always. For the minus
sign, $\sqrt{a} - \sqrt{b} \ge 0$ because $a \ge b$. This is why $a$ has to be
the larger root: with the roles swapped, $\sqrt{(\sqrt{a} - \sqrt{b})^2}$ would
be $\sqrt{b} - \sqrt{a}$ instead.

## Only one denesting

Suppose $x$ and $y$ are rational, $\sqrt{y}$ is irrational, and

$$
\sqrt{x + \sqrt{y}} = \sqrt{a} + \sqrt{b}
$$

for some rational $a, b \ge 0$. Then $a + b = x$ and $4ab = y$, so $a$ and $b$
are exactly the numbers from the formula, and

$$
x^2 - y = (a + b)^2 - 4ab = (a - b)^2
$$

is the square of a rational number. So when $x^2 - y$ isn't a rational square,
$\sqrt{x + \sqrt{y}}$ can't be written as $\sqrt{a} + \sqrt{b}$ with rational
$a$ and $b$ at all.

**Proof.** Squaring both sides,

$$
x + \sqrt{y} = a + b + 2t, \qquad \text{where } t = \sqrt{a}\sqrt{b},
$$

so $\sqrt{y} = r + 2t$ with $r = a + b - x$ rational. Squaring again and using
$t^2 = ab$:

$$
y = r^2 + 4rt + 4ab.
$$

If $r \ne 0$, this solves for $t$:

$$
t = \frac{y - r^2 - 4ab}{4r},
$$

which is rational. Then $\sqrt{y} = r + 2t$ is rational too, a contradiction.
So $r = 0$, which means $a + b = x$. Then $\sqrt{y} = 2t$, and squaring gives
$y = 4t^2 = 4ab$. ∎

The same argument works for $\sqrt{x - \sqrt{y}} = \sqrt{a} - \sqrt{b}$: the
only change is the sign in front of $2t$.

A form like $p\sqrt{a} + q\sqrt{b}$ with rational $p, q \ge 0$ is no more
general, because $p\sqrt{a} = \sqrt{p^2 a}$.

## Examples

**Denests.** With $x = 3$ and $y = 8$, $x^2 - y = 1$, so $a = 2$ and $b = 1$:

$$
\sqrt{3 + \sqrt{8}} = \sqrt{2} + 1
$$

**Denests, minus sign.** With $x = 5$ and $y = 24$, $x^2 - y = 1$, so $a = 3$
and $b = 2$:

$$
\sqrt{5 - \sqrt{24}} = \sqrt{3} - \sqrt{2}
$$

**Uses the second form.** With $x = 2$ and $y = 3$, $x^2 - y = 1$, and the
second form gives

$$
\sqrt{2 + \sqrt{3}} = \frac{\sqrt{2}}{2}\left(\sqrt{3} + 1\right) = \frac{\sqrt{6} + \sqrt{2}}{2}.
$$

The first form gives the same value as $\sqrt{3/2} + \sqrt{1/2}$, which is
less tidy. In general, when $x$ and $\sqrt{x^2 - y}$ are integers with an odd
sum, the first form has fractions inside the roots and the second form doesn't.

This value is $2\cos 15°$. From the half-angle formula,
$2\cos 15° = \sqrt{2 + 2\cos 30°} = \sqrt{2 + \sqrt{3}}$, so the denesting
gives the familiar $\cos 15° = \frac{\sqrt{6} + \sqrt{2}}{4}$.

**Doesn't denest.** With $x = 2$ and $y = 2$, $x^2 - y = 2$ is not a rational
square. The formula still holds,

$$
\sqrt{2 + \sqrt{2}} =
\sqrt{\frac{2 + \sqrt{2}}{2}} + \sqrt{\frac{2 - \sqrt{2}}{2}},
$$

but the right-hand side is just as nested. By
[Only one denesting](#only-one-denesting), no rational $a$ and $b$ work. This
value is $2\cos 22.5°$.

## Lean proof

`Denesting.lean` formalizes the formula and the uniqueness result using
Mathlib.

> **Status:** not checked yet. Lean couldn't be installed in the environment
> where this was written.

| Theorem | Statement |
|---|---|
| `denest_add` | For real $y \ge 0$ and $x \ge \sqrt{y}$, the formula with the plus sign |
| `denest_sub` | The same, with the minus sign |
| `eq_of_denest` | If $x, y, a, b$ are rational, $a, b \ge 0$, $\sqrt{y}$ is irrational and $\sqrt{x + \sqrt{y}} = \sqrt{a} + \sqrt{b}$, then $a + b = x$ and $4ab = y$ |
| `sqrt_mul_sqrt` | The key step of the direct check: $\sqrt{a}\sqrt{b} = \sqrt{y}/2$ |
| `d_facts` | $d = \sqrt{x^2 - y}$ satisfies $d \ge 0$, $d^2 = x^2 - y$ and $d \le x$ |

`eq_of_denest` also assumes $x + \sqrt{y} \ge 0$. Without it, the left side is
a square root of a negative number, which Lean defines as 0, and then
$a = b = 0$ is a counterexample.

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
