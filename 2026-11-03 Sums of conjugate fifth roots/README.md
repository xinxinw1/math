# Sums of conjugate fifth roots

For which integers $a$ and $n$, with $n > 0$ squarefree, is

$$
\sqrt[5]{a + \sqrt{n}} + \sqrt[5]{a - \sqrt{n}}
$$

a nice number?

*Xin-Xin*

This is the fifth-root version of
[Classifying cubic formula identities](../2026-11-01%20Classifying%20cubic%20formula%20identities/README.md)
and follows the same steps. For cube roots there is exactly one such identity,
$\sqrt[3]{2 + \sqrt{5}} + \sqrt[3]{2 - \sqrt{5}} = 1$. For fifth roots there
are none.

Throughout, fifth roots are real. $a \ne 0$, since otherwise the two roots
cancel and the sum is $0$.

## Answer

With $n > 1$ squarefree, the sum is **never rational**. It isn't a quadratic
irrational $e + f\sqrt{d}$ either. ($n = 1$ is squarefree too, but then
$\sqrt{n}$ is rational and nothing is nested. $a + 1$ and $a - 1$ can't both be
fifth powers unless $a = 0$.)

If the square root may have a coefficient, so the radical is $b\sqrt{c}$, then
rational sums do exist. Every one comes from expanding a fifth power: for
integers $y \ne 0$ and $d > 1$ not a perfect square,

$$
(y + \sqrt{d})^5 = (y^5 + 10y^3d + 5yd^2) + (5y^4 + 10y^2d + d^2)\sqrt{d},
$$

so with $a = y^5 + 10y^3d + 5yd^2$ and $g = 5y^4 + 10y^2d + d^2$,

$$
\boxed{\sqrt[5]{a + g\sqrt{d}} + \sqrt[5]{a - g\sqrt{d}} = 2y.}
$$

The smallest example is $(1 + \sqrt{2})^5 = 41 + 29\sqrt{2}$:

$$
\sqrt[5]{41 + 29\sqrt{2}} + \sqrt[5]{41 - 29\sqrt{2}} = 2.
$$

The coefficient $g$ is at least $d^2 \ge 4$, so it is never $1$. That is why
the squarefree case has no solutions.

## The power sum

Let $u$ and $v$ be the two fifth roots, so $u^5 = a + s$ and $v^5 = a - s$,
where $s$ is the square root. Write

$$
x = u + v, \qquad m = uv.
$$

The power sums $p_k = u^k + v^k$ satisfy $p_k = xp_{k-1} - mp_{k-2}$, starting
from $p_0 = 2$ and $p_1 = x$. This gives

$$
\begin{aligned}
p_2 &= x^2 - 2m, \\
p_3 &= x^3 - 3mx, \\
p_4 &= x^4 - 4mx^2 + 2m^2, \\
p_5 &= x^5 - 5mx^3 + 5m^2x.
\end{aligned}
$$

Since $p_5 = u^5 + v^5 = 2a$,

$$
x^5 - 5mx^3 + 5m^2x = 2a.
$$

For the difference, $u - v = \pm\sqrt{x^2 - 4m}$ and

$$
u^4 + u^3v + u^2v^2 + uv^3 + v^4 = p_4 + mp_2 + m^2 = x^4 - 3mx^2 + m^2,
$$

so

$$
2s = u^5 - v^5 = (u - v)(x^4 - 3mx^2 + m^2).
$$

## Every identity has this form

**Theorem.** Let $a$ and $N$ be integers with $a \ne 0$ and $N > 0$ not a
perfect square, and let $s = \sqrt{N}$. Take real fifth roots $u$ and $v$ of
$a + s$ and $a - s$. If $x = u + v$ is rational, then $x$ is an even integer
$2y$, and

$$
u = y + \sqrt{d}, \qquad v = y - \sqrt{d}
$$

for an integer $d > 1$ that isn't a perfect square.

**Proof.**

**Step 1.** $m$ is an integer. If $x = 0$ then $u = -v$, so $a + s = -(a - s)$
and $a = 0$, which is excluded. So $x \ne 0$, and the power sum equation

$$
5x \cdot m^2 - 5x^3 \cdot m + (x^5 - 2a) = 0
$$

says $m$ is a root of a quadratic with rational coefficients. So $m$ is
rational or has degree $2$. But $m^5 = (a + s)(a - s) = a^2 - N$ is an
integer. Because $5$ is prime, $t^5 - r$ is irreducible over ℚ whenever the
integer $r$ isn't a fifth power. So a real fifth root of an integer is either
rational or has degree $5$, never $2$. So $m$ is rational, and a rational number
whose fifth power is an integer is an integer.

**Step 2.** $x$ is an integer. It is a rational root of the monic integer
polynomial $t^5 - 5mt^3 + 5m^2t - 2a$.

**Step 3.** $x$ is even. If $x$ is odd, then modulo $2$

$$
x^4 - 5mx^2 + 5m^2 \equiv 1 + m + m^2 = 1 + m(m + 1) \equiv 1,
$$

because $m(m + 1)$ is even. So $x(x^4 - 5mx^2 + 5m^2) = 2a$ would be odd,
which is impossible.

**Step 4.** The form of $u$ and $v$. Write $x = 2y$ and $d = y^2 - m$. Then $u$
and $v$ are the roots of $t^2 - 2yt + m$, which are $y \pm \sqrt{d}$. From the
difference formula, $4N = (2s)^2 = 4d(x^4 - 3mx^2 + m^2)^2$, so $d > 0$. If $d$
were a perfect square, $u$ would be an integer and so would $u^5 = a + s$, but
$s$ is irrational. $\blacksquare$

Expanding $(y + \sqrt{d})^5$ then gives the boxed formula, with
$s = g\sqrt{d}$. Changing the sign of $s$ only swaps $u$ and $v$.

Conversely, every integer $y \ne 0$ and $d > 1$ not a perfect square gives an
identity. Both $y + \sqrt{d}$ and $y - \sqrt{d}$ are real, so they are the real
fifth roots of $a + g\sqrt{d}$ and $a - g\sqrt{d}$.

If $a$ may be a half-integer, odd $x$ is allowed too, with $u$ and $v$ of the
form $\frac{x \pm \sqrt{D}}{2}$. The golden ratio
$\varphi = \frac{1 + \sqrt{5}}{2}$ has $\varphi^5 = \frac{11 + 5\sqrt{5}}{2}$, so

$$
\sqrt[5]{\frac{11 + 5\sqrt{5}}{2}} + \sqrt[5]{\frac{11 - 5\sqrt{5}}{2}} = 1.
$$

For cube roots, the half-integer case still gives integer $a$, which is where
$\sqrt[3]{2 + \sqrt{5}} + \sqrt[3]{2 - \sqrt{5}} = 1$ comes from:
$\varphi^3 = 2 + \sqrt{5}$. Step 3 is what rules it out for fifth roots.

## Squarefree radicands

**Theorem.** Let $a$ and $n$ be integers with $a \ne 0$ and $n > 1$
squarefree. Then $\sqrt[5]{a + \sqrt{n}} + \sqrt[5]{a - \sqrt{n}}$ is not
rational.

**Proof.** If it were, the theorem above with $N = n$ gives
$\sqrt{n} = g\sqrt{d}$, so $n = g^2d$. Since $n$ is squarefree, $g^2 = 1$. But
$d \ge 2$, so

$$
g = 5y^4 + 10y^2d + d^2 \ge d^2 \ge 4. \qquad \blacksquare
$$

## Not a quadratic irrational

**Theorem.** With $a$, $N$, $u$ and $v$ as in the first theorem, if $x = u + v$
is a quadratic irrational, it is in fact rational. So $x$ is either rational or
has degree at least $3$.

**Proof.** Suppose $x$ has degree at most $2$. The quadratic relation for $m$
from Step 1 has coefficients in ℚ(*x*), so $m$ has degree at most $4$ over ℚ.
As before, a real fifth root of an integer has degree $1$ or $5$, so $m$ is an
integer.

Then $u$ is a root of $t^2 - xt + m$, which has coefficients in ℚ(*x*), so $u$
has degree at most $4$ over ℚ.

Now $u$ is a root of $t^5 - (a + s)$, which has coefficients in ℚ(*s*). By the
same fact about prime exponents, now over the field ℚ(*s*), this polynomial is
irreducible over ℚ(*s*) unless $a + s$ is a fifth power there. So $u$ has
degree $1$ or $5$ over ℚ(*s*), and degree $2$ or $10$ over ℚ. Degree at most
$4$ leaves only $u$ in ℚ(*s*).

So $u = e + f\sqrt{N}$ with $e$ and $f$ rational. Its conjugate
$e - f\sqrt{N}$ is real and its fifth power is $a - s$, so it is $v$. Then
$x = u + v = 2e$ is rational. $\blacksquare$

Combined with the squarefree theorem, the sum with $n > 1$ squarefree has
degree at least $3$.

## Examples

| $y$ | $d$ | Identity |
|---|---|---|
| 1 | 2 | $\sqrt[5]{41 + 29\sqrt{2}} + \sqrt[5]{41 - 29\sqrt{2}} = 2$ |
| 1 | 3 | $\sqrt[5]{76 + 44\sqrt{3}} + \sqrt[5]{76 - 44\sqrt{3}} = 2$ |
| 1 | 6 | $\sqrt[5]{241 + 101\sqrt{6}} + \sqrt[5]{241 - 101\sqrt{6}} = 2$ |
| 2 | 3 | $\sqrt[5]{362 + 209\sqrt{3}} + \sqrt[5]{362 - 209\sqrt{3}} = 4$ |
| 2 | 5 | $\sqrt[5]{682 + 305\sqrt{5}} + \sqrt[5]{682 - 305\sqrt{5}} = 4$ |
| 3 | 2 | $\sqrt[5]{843 + 589\sqrt{2}} + \sqrt[5]{843 - 589\sqrt{2}} = 6$ |

Each was checked numerically to 40 digits.

A search over every squarefree $1 < n < 400$ and $0 < |a| \le 300$ looked for
sums satisfying a polynomial of degree at most $2$ with small integer
coefficients, and found none, as the theorems predict.
