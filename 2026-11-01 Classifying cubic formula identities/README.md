# Classifying cubic formula identities

Which sums $\sqrt[3]{a + b\sqrt{c}} + \sqrt[3]{a - b\sqrt{c}}$ with integers
$a$, $b$ and $c$ are rational, and what they equal.

*Xin-Xin*

This builds on [Cubic formula identities](../2015-03-15%20Cubic%20formula%20identities/README.md),
which uses Cardano's formula to build such sums equal to any chosen $x$. This
doc rewrites that generator with integer coefficients, proves that it gives
every identity of this form, and works out the cases where the square root is
squarefree or imaginary.

## The generator

The 2015 notes apply Cardano's formula to $(t - x)(t^2 + xt + y) = 0$ and get

$$
\sqrt[3]{\frac{xy}{2} + \frac{y + 2x^2}{18}\sqrt{3(4y - x^2)}} +
\sqrt[3]{\frac{xy}{2} - \frac{y + 2x^2}{18}\sqrt{3(4y - x^2)}} = x.
$$

With real cube roots, this holds when $4y > x^2$. Then $t^2 + xt + y$ has no
real roots, so $x$ is the only real root of the cubic, and Cardano's formula
with real cube roots gives exactly that root. When $4y < x^2$, the square root
is of a negative number. That case is covered in
[Complex cube roots](#complex-cube-roots).

The coefficients usually need simplifying. For $x = 1$ and $y = 4$, the
formula gives $\tfrac{1}{3}\sqrt{45}$, which is $\sqrt{5}$:

$$\sqrt[3]{2 + \sqrt{5}} + \sqrt[3]{2 - \sqrt{5}} = 1.$$

## The integer form

Let $u$ and $v$ be the two cube roots, so $u + v = x$. In Cardano's formula,
their product is $uv = \dfrac{x^2 - y}{3}$. Call this $m$, so

$$y = x^2 - 3m.$$

Then $y + 2x^2 = 3(x^2 - m)$ and $4y - x^2 = 3(x^2 - 4m)$, and the generator
becomes

$$
\boxed{\sqrt[3]{\frac{x(x^2 - 3m)}{2} + \frac{x^2 - m}{2}\sqrt{x^2 - 4m}} +
\sqrt[3]{\frac{x(x^2 - 3m)}{2} - \frac{x^2 - m}{2}\sqrt{x^2 - 4m}} = x}
$$

for any $x$ and $m$ with $x^2 > 4m$, which is the same condition as
$4y > x^2$.

### Checking it directly

This form can be checked without Cardano's formula. Write $D = x^2 - 4m$.
Since $u + v = x$ and $uv = m$, the cube roots are the roots of
$s^2 - xs + m = 0$:

$$u = \frac{x + \sqrt{D}}{2}, \qquad v = \frac{x - \sqrt{D}}{2}.$$

Cubing, with $(\sqrt{D})^2 = D$:

$$
\begin{aligned}
u^3 &= \frac{x^3 + 3x^2\sqrt{D} + 3xD + D\sqrt{D}}{8} \\
&= \frac{x^3 + 3xD}{8} + \frac{3x^2 + D}{8}\sqrt{D} \\
&= \frac{x(x^2 - 3m)}{2} + \frac{x^2 - m}{2}\sqrt{D},
\end{aligned}
$$

and $v^3$ is the same with $-\sqrt{D}$. When $D > 0$, $u$ and $v$ are real, so
they are the real cube roots, and their sum is $x$.

So every identity from the generator is a perfect cube in disguise. For
example, with $\varphi = \tfrac{1 + \sqrt{5}}{2}$ the golden ratio:

$$\varphi^3 = 2 + \sqrt{5}, \qquad (1 + \sqrt{2})^3 = 7 + 5\sqrt{2}, \qquad
\varphi^6 = 9 + 4\sqrt{5}.$$

### Integer coefficients

For integers $x$ and $m$, the first term $\tfrac{x(x^2 - 3m)}{2}$ is an
integer unless $x$ is odd and $m$ is even. In the other cases the radical also
has an integer coefficient:

- If $x$ and $m$ are both odd, $x^2 - m$ is even.
- If $x$ is even, $x^2 - 4m$ is divisible by $4$, and the radical is
  $(x^2 - m)\sqrt{\tfrac{x^2 - 4m}{4}}$.

The identity is trivial when $x^2 - 4m$ is a perfect square, since then
nothing is irrational. For example, $x = 1$ and $m = 0$ give
$\sqrt[3]{1} + \sqrt[3]{0} = 1$.

Replacing $x$ with $rx$ and $m$ with $r^2m$ multiplies both terms under the
cube roots by $r^3$. For example, $x = 2$ and $m = -4$ give $8$ times the
identity for $x = 1$ and $m = -1$.

| $x$ | $m$ | Identity |
|---|---|---|
| 1 | $-1$ | $\sqrt[3]{2 + \sqrt{5}} + \sqrt[3]{2 - \sqrt{5}} = 1$ |
| 1 | $-3$ | $\sqrt[3]{5 + 2\sqrt{13}} + \sqrt[3]{5 - 2\sqrt{13}} = 1$ |
| 1 | $-11$ | $\sqrt[3]{17 + 18\sqrt{5}} + \sqrt[3]{17 - 18\sqrt{5}} = 1$ |
| 2 | $-1$ | $\sqrt[3]{7 + 5\sqrt{2}} + \sqrt[3]{7 - 5\sqrt{2}} = 2$ |
| 2 | $-2$ | $\sqrt[3]{10 + 6\sqrt{3}} + \sqrt[3]{10 - 6\sqrt{3}} = 2$ |
| 3 | $1$ | $\sqrt[3]{9 + 4\sqrt{5}} + \sqrt[3]{9 - 4\sqrt{5}} = 3$ |
| 4 | $2$ | $\sqrt[3]{20 + 14\sqrt{2}} + \sqrt[3]{20 - 14\sqrt{2}} = 4$ |

## Every identity has this form

The integer form doesn't just produce identities. Every identity of this shape
comes from it.

**Theorem.** Let $a$ and $N$ be integers with $a \ne 0$, and let $s$ be a
square root of $N$, real or imaginary. Let $u$ and $v$ be cube roots of
$a + s$ and $a - s$, any of the three cube roots of each. If $u + v = x$ is
rational, then $x$ and $m = uv$ are integers, and

$$a = \frac{x(x^2 - 3m)}{2}, \qquad 4N = (x^2 - m)^2(x^2 - 4m).$$

**Proof.**

**Step 1.** $x$ and $m$ are integers. Cubing $u + v = x$ gives

$$x^3 = u^3 + v^3 + 3uv(u + v) = 2a + 3mx.$$

If $x = 0$ then $u = -v$, so $a + s = -(a - s)$ and $a = 0$, which is
excluded. So $m = \tfrac{x^3 - 2a}{3x}$ is rational. Its cube
$m^3 = (a + s)(a - s) = a^2 - N$ is an integer, and a rational number whose
cube is an integer is an integer. Then $x$ is a rational root of the monic
integer polynomial $t^3 - 3mt - 2a$, so $x$ is an integer too.

**Step 2.** The two equations. The first is $x^3 = 2a + 3mx$ solved for $a$.
For the second, $(u - v)^2 = (u + v)^2 - 4uv = x^2 - 4m$ and
$u^2 + uv + v^2 = (u + v)^2 - uv = x^2 - m$, so

$$
4N = (2s)^2 = (u^3 - v^3)^2 = (u - v)^2(u^2 + uv + v^2)^2 =
(x^2 - 4m)(x^2 - m)^2. \qquad \blacksquare
$$

The proof is pure algebra, so it holds for every choice of cube roots.

**Real cube roots.** Take $s = b\sqrt{c}$ with $b \ne 0$ and $c > 0$ not a
perfect square, so $N = b^2c > 0$. The second equation forces
$D = x^2 - 4m > 0$, and taking square roots of $4b^2c = (x^2 - m)^2 D$ gives

$$b\sqrt{c} = \pm\frac{x^2 - m}{2}\sqrt{D}.$$

Changing the sign of $b$ only swaps the two cube roots. So the identity is the
integer form for these integers $x$ and $m$, with $D$ not a perfect square.

Together with the previous section, this gives a complete list: the identities
$\sqrt[3]{a + b\sqrt{c}} + \sqrt[3]{a - b\sqrt{c}} = x$ with integers
$a \ne 0$, $b \ne 0$ and $c > 0$ not a perfect square, real cube roots and $x$
rational are exactly the integer form, for integers $x \ne 0$ and $m$ with
$x^2 - 4m$ positive and not a perfect square, other than $x$ odd and $m$ even.
This is up to the sign of $b$ and how the radical is written, such as
$2\sqrt{13}$ or $\sqrt{52}$.

**Remark.** The sum can't be a quadratic irrational $e + f\sqrt{d}$ either.
Then $m = \tfrac{x^3 - 2a}{3x}$ would lie in the quadratic field generated by
$x$. A real cube root of an integer is either rational or of degree $3$, so $m$
is again an integer, and $x$ is a root of $t^3 - 3mt - 2a$. Its conjugate
$e - f\sqrt{d}$ would be a second real root. But this cubic has discriminant

$$-4(-3m)^3 - 27(-2a)^2 = 108(m^3 - a^2) = -108N < 0,$$

so it has only one real root.

## Squarefree radicands

Most identities above have a square factor under the square root, like
$\sqrt{52} = 2\sqrt{13}$. Asking for the radicand to be squarefree pins down a
single identity.

**Theorem.** Let $a$ and $n$ be integers with $a \ne 0$ and $n > 0$
squarefree, and take real cube roots. If

$$\sqrt[3]{a + \sqrt{n}} + \sqrt[3]{a - \sqrt{n}} = x$$

with $x$ rational, then $(a, n, x) = (2, 5, 1)$ or $(-2, 5, -1)$. That is, the
only such identity (up to sign) is

$$\sqrt[3]{2 + \sqrt{5}} + \sqrt[3]{2 - \sqrt{5}} = 1.$$

**Proof.** By the theorem above with $N = n$, $x$ and $m$ are integers with
$4n = g^2 D$, where $g = x^2 - m$ and $D = x^2 - 4m$. Since $n \ne 0$,
$g \ne 0$.

**Step 1.** $g$ is $\pm 1$ or $\pm 2$. If $g$ is even, then $n = (g/2)^2 D$,
and since $n$ is squarefree, $g/2 = \pm 1$. If $g$ is odd, then $4 \mid D$, so
$n = g^2 \cdot \tfrac{D}{4}$ and $g = \pm 1$.

**Step 2.** Only $x = \pm 1$ works. Substituting $m = x^2 - g$,

$$D = x^2 - 4m = 4g - 3x^2.$$

Since $n > 0$, $D > 0$, so $g > 0$ and $3x^2 < 4g \le 8$. Also $x \ne 0$, since
$a \ne 0$. So $x = \pm 1$. Then $D = 4g - 3$ is odd, which rules out $g = 1$
(that case needs $4 \mid D$). So $g = 2$, $m = -1$, $D = 5$,
$n = \tfrac{4 \cdot 5}{4} = 5$, and $a = \tfrac{x(x^2 - 3m)}{2} = 2x = \pm 2$.
$\blacksquare$

## Complex cube roots

When $x^2 < 4m$, the square root $\sqrt{x^2 - 4m}$ is imaginary. The cubic
then has three real roots, but Cardano's formula can only reach them through
complex numbers. This is the *casus irreducibilis*.

The integer form still works. Writing $\sqrt{x^2 - 4m} = i\sqrt{4m - x^2}$,

$$
\sqrt[3]{\frac{x(x^2 - 3m)}{2} + \frac{x^2 - m}{2} i\sqrt{4m - x^2}} +
\sqrt[3]{\frac{x(x^2 - 3m)}{2} - \frac{x^2 - m}{2} i\sqrt{4m - x^2}} = x,
$$

and the cube roots are the complex conjugates

$$u = \frac{x + i\sqrt{4m - x^2}}{2}, \qquad v = \frac{x - i\sqrt{4m - x^2}}{2}.$$

### Choosing the cube root

A complex number has three cube roots. Using the *principal* cube root (the one
with argument in $(-\tfrac{\pi}{3}, \tfrac{\pi}{3}]$, which is what calculators
and most programming languages return), the identity holds exactly when $u$
itself is principal, that is $|\arg u| < \tfrac{\pi}{3}$. For $x > 0$ this means

$$\frac{x^2}{4} < m < x^2.$$

The other choices of cube roots give the cubic's other two real roots. Let
$\omega = e^{2\pi i/3}$. Then $u + v = x$, while $\omega u + \bar\omega v$ and
$\bar\omega u + \omega v$ are the remaining roots.

In both cases below, $a \pm s$ are complex conjugates off the real axis, so
their principal cube roots are conjugates too: $v = \bar u$, and the sum
$x = 2\mathrm{Re}(u)$ is real. A principal cube root has
$|\arg u| < \tfrac{\pi}{3}$, so $x > 0$ and, from the condition above,
$m < x^2$.

### Gaussian integers

To get identities $\sqrt[3]{a + bi} + \sqrt[3]{a - bi} = x$ with integers $a$
and $b$ and no other radicals, take a Gaussian integer $u = p + qi$ with
$p > 0$ and $0 < q < p\sqrt{3}$. Then

$$a + bi = (p + qi)^3, \qquad a = p(p^2 - 3q^2), \qquad b = q(3p^2 - q^2),$$

and

$$\sqrt[3]{a + bi} + \sqrt[3]{a - bi} = 2p.$$

In terms of the integer form, $x = 2p$ and $m = p^2 + q^2$, and the
condition $q < p\sqrt{3}$ is the principal-root condition $m < x^2$ from above.
Since $\sqrt{3}$ is irrational, $p^2 \ne 3q^2$, so $a$ is never $0$.

These are all such identities with integers $a \ne 0$ and $b > 0$ and
rational $x$. (Swapping the two terms handles $b < 0$.) By the theorem with
$N = -b^2$, $x$ and $m$ are integers and $-4b^2 = (x^2 - m)^2 D$. So $-D$ is
the square of the rational number $\tfrac{2b}{x^2 - m}$. It's an integer, so
$-D = k^2$ for some integer $k$. The cube roots are the roots of
$s^2 - xs + m$, so $u = \tfrac{x \pm ik}{2}$. Since $x^2 + k^2 = 4m$, $x$ and
$k$ are both even: if both were odd, $x^2 + k^2$ would be $2$ more than a
multiple of $4$. So $u = p + qi$ with $x = 2p$, and $u$ is a Gaussian integer.
Being principal, it has $p > 0$ and $|q| < p\sqrt{3}$, and then
$b = q(3p^2 - q^2)$ has the same sign as $q$. In particular $x$ is always even.

Taking $\gcd(p, q) = 1$ skips scaled copies, since $u \to ru$ multiplies $a$
and $b$ by $r^3$ and $x$ by $r$.

| $u$ | Identity |
|---|---|
| $1 + i$ | $\sqrt[3]{-2 + 2i} + \sqrt[3]{-2 - 2i} = 2$ |
| $2 + i$ | $\sqrt[3]{2 + 11i} + \sqrt[3]{2 - 11i} = 4$ |
| $2 + 3i$ | $\sqrt[3]{-46 + 9i} + \sqrt[3]{-46 - 9i} = 4$ |
| $3 + i$ | $\sqrt[3]{18 + 26i} + \sqrt[3]{18 - 26i} = 6$ |
| $3 + 2i$ | $\sqrt[3]{-9 + 46i} + \sqrt[3]{-9 - 46i} = 6$ |
| $3 + 4i$ | $\sqrt[3]{-117 + 44i} + \sqrt[3]{-117 - 44i} = 6$ |
| $3 + 5i$ | $\sqrt[3]{-198 + 10i} + \sqrt[3]{-198 - 10i} = 6$ |
| $4 + i$ | $\sqrt[3]{52 + 47i} + \sqrt[3]{52 - 47i} = 8$ |
| $4 + 3i$ | $\sqrt[3]{-44 + 117i} + \sqrt[3]{-44 - 117i} = 8$ |
| $4 + 5i$ | $\sqrt[3]{-236 + 115i} + \sqrt[3]{-236 - 115i} = 8$ |

The $u = 2 + i$ row is Bombelli's example from 1572, one of the first
calculations to use complex numbers. It solves $t^3 = 15t + 4$, whose roots are
$4$ and $-2 \pm \sqrt{3}$. With $\omega$ as above,

$$\omega(2 + i) + \bar\omega(2 - i) = -2 - \sqrt{3}, \qquad
\bar\omega(2 + i) + \omega(2 - i) = -2 + \sqrt{3}.$$

### Negative squarefree radicands

Now take $\sqrt[3]{a + \sqrt{n}} + \sqrt[3]{a - \sqrt{n}} = x$ with $a \ne 0$,
$n < 0$ squarefree, $\sqrt{n} = i\sqrt{-n}$, principal cube roots and $x$
rational. Unlike the real case, there are infinitely many.

By the theorem with $N = n$, $x$ and $m$ are integers with $4n = g^2 D$, where
$g = x^2 - m$ and $D = x^2 - 4m$. So $D < 0$. Step 1 of the squarefree proof
used only that $n$ is squarefree, so again $g$ is $\pm 1$ or $\pm 2$. From the
principal-root condition, $x > 0$ and $m < x^2$, so $g > 0$. As before,
$D = 4g - 3x^2$, which leaves two families.

**Case g = 2.** Then $n = D = 8 - 3x^2$. If $x$ were even, $4$ would divide
$n$, so $x$ is odd, and $D < 0$ means $x \ge 3$. Here $m = x^2 - 2$ and

$$a = x(3 - x^2), \qquad n = 8 - 3x^2.$$

**Case g = 1.** Then $4 \mid D = 4 - 3x^2$, so $x = 2p$ is even, $m = x^2 - 1$
and

$$a = p(3 - 8p^2), \qquad n = 1 - 3p^2.$$

Conversely, each of these is an identity whenever $n$ is squarefree. Since
$x > 0$ and $\tfrac{x^2}{4} < m < x^2$, the principal cube roots are $u$ and
$v$, and $\tfrac{g}{2}\sqrt{D} = \sqrt{n}$ because $g > 0$ and
$g^2 D = 4n$.

| $x$ | Identity |
|---|---|
| 2 | $\sqrt[3]{-5 + \sqrt{-2}} + \sqrt[3]{-5 - \sqrt{-2}} = 2$ |
| 3 | $\sqrt[3]{-18 + \sqrt{-19}} + \sqrt[3]{-18 - \sqrt{-19}} = 3$ |
| 4 | $\sqrt[3]{-58 + \sqrt{-11}} + \sqrt[3]{-58 - \sqrt{-11}} = 4$ |
| 5 | $\sqrt[3]{-110 + \sqrt{-67}} + \sqrt[3]{-110 - \sqrt{-67}} = 5$ |
| 6 | $\sqrt[3]{-207 + \sqrt{-26}} + \sqrt[3]{-207 - \sqrt{-26}} = 6$ |

The values of $n$ are squarefree for every $x$ from $2$ to $17$. The first
failure is $x = 18$, where $n = -242 = -2 \cdot 11^2$.

## Lean proof

`CubicIdentities.lean` formalizes the main theorem and the squarefree theorem
using Mathlib.

> **Status:** checked with no errors or warnings on <https://live.lean-lang.org/#project=mathlib-stable>
> using its stable release (Lean v4.35.0 with Mathlib).

| Theorem | Statement |
|---|---|
| `int_params_of_cube_roots` | The main theorem, over any field of characteristic 0: if $s^2 = N$, $u^3 = a + s$, $v^3 = a - s$ and $u + v = x$ is rational, with $a \ne 0$, then $x$ and $uv$ are integers satisfying its two equations |
| `eq_of_cube_roots` | The squarefree theorem over any field of characteristic 0: if moreover $N > 0$ is squarefree, then $(a, N, x) = (\pm 2, 5, \pm 1)$ |
| `real_cube_roots` | The squarefree theorem over ℝ with $s = \sqrt{N}$ |
| `cube_of_root` | If $r^2 = x^2 - 4m$, then $\left(\tfrac{x + r}{2}\right)^3 = \tfrac{x(x^2 - 3m)}{2} + \tfrac{x^2 - m}{2}r$, the direct check of the integer form |
| `golden_identity` | $\left(\tfrac{1 \pm \sqrt{5}}{2}\right)^3 = 2 \pm \sqrt{5}$, so the identity really holds |
| `exists_int_of_cubic` | A rational root of $t^3 + ct + d$ with integer $c, d$ is an integer |
| `int_classification` | The integer case analysis in the squarefree proof |

The complex cube root results aren't formalized.

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
