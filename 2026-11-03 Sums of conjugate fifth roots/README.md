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

[Complex fifth roots](#complex-fifth-roots) at the end does the same for
$\sqrt[5]{a + bi} + \sqrt[5]{a - bi}$. Until then, fifth roots are real.
Throughout, $a \ne 0$, since otherwise the two roots cancel and the sum is
$0$.

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

## Complex fifth roots

Now take $\sqrt[5]{a + bi} + \sqrt[5]{a - bi}$ with integers $a \ne 0$ and
$b \ne 0$, using *principal* fifth roots: the fifth root with argument in
$(-\tfrac{\pi}{5}, \tfrac{\pi}{5}]$, which is what calculators and most
programming languages return. Since $a \pm bi$ are complex conjugates off the
real axis, their principal fifth roots are conjugates too, $v = \bar u$, and the
sum $x = 2\mathrm{Re}(u)$ is real.

### Gaussian integers

**Theorem.** The sum is rational exactly when $a + bi = (p + qi)^5$ for
integers $p$ and $q$ with

$$
p > 0, \qquad 0 < |q| < p\tan\frac{\pi}{5} = p\sqrt{5 - 2\sqrt{5}} \approx 0.7265p,
$$

and then

$$
\boxed{\sqrt[5]{a + bi} + \sqrt[5]{a - bi} = 2p.}
$$

Expanding,

$$
a = p(p^4 - 10p^2q^2 + 5q^4), \qquad b = q(5p^4 - 10p^2q^2 + q^4).
$$

The sum is never a quadratic irrational.

**Proof.** Steps 1 to 3 of the first theorem used only algebra and two facts
about $m = uv$: it is real and its fifth power is an integer. Both still hold,
since $m = u\bar u = |u|^2$ and $m^5 = (a + bi)(a - bi) = a^2 + b^2$. So $m$
is an integer and $x = 2y$ is an even integer.

As in Step 4, $u$ and $v$ are $y \pm \sqrt{y^2 - m}$. Now $s = bi$, and the
difference formula gives

$$
-4b^2 = (2s)^2 = 4(y^2 - m)(x^4 - 3mx^2 + m^2)^2.
$$

The last factor isn't $0$, since $s \ne 0$. So $m - y^2$ is the square of the
rational number $\frac{b}{x^4 - 3mx^2 + m^2}$. It's an integer, so
$m - y^2 = q^2$ for an integer $q \ne 0$, and $u = y \pm qi$ is a Gaussian
integer. Write $p = y$, choosing the sign of $q$ so that $u = p + qi$.

Being principal, $u$ has $|\arg u| < \tfrac{\pi}{5}$. ($|\arg u| = \tfrac{\pi}{5}$
would make $u^5$ real, but $b \ne 0$.) That is the condition on $p$ and $q$.

Conversely, if $p$ and $q$ satisfy it, $p + qi$ is the principal fifth root of
$(p + qi)^5$ and $p - qi$ of its conjugate, so the sum is $2p$. Neither $a$ nor
$b$ is $0$: that would need $(p/q)^2$ or $(q/p)^2$ to be $5 \pm 2\sqrt{5}$,
which is irrational.

For the last claim, the proof in
[Not a quadratic irrational](#not-a-quadratic-irrational) carries over with
ℚ(*i*) in place of ℚ(*s*). It shows $u$ lies in ℚ(*i*), so $u = e + fi$ with
$e$ and $f$ rational, $v = \bar u$, and $x = 2e$. $\blacksquare$

The cube root version in
[Classifying cubic formula identities](../2026-11-01%20Classifying%20cubic%20formula%20identities/README.md#gaussian-integers)
has the same form, with $\tan\frac{\pi}{3} = \sqrt{3}$ in place of
$\tan\frac{\pi}{5}$.

Taking $\gcd(p, q) = 1$ skips scaled copies, since $u \to ru$ multiplies $a$
and $b$ by $r^5$ and the sum by $r$. Swapping the two terms handles $q < 0$, so
take $q > 0$.

| $u$ | Identity |
|---|---|
| $2 + i$ | $\sqrt[5]{-38 + 41i} + \sqrt[5]{-38 - 41i} = 4$ |
| $3 + i$ | $\sqrt[5]{-12 + 316i} + \sqrt[5]{-12 - 316i} = 6$ |
| $3 + 2i$ | $\sqrt[5]{-597 + 122i} + \sqrt[5]{-597 - 122i} = 6$ |
| $4 + i$ | $\sqrt[5]{404 + 1121i} + \sqrt[5]{404 - 1121i} = 8$ |
| $5 + i$ | $\sqrt[5]{1900 + 2876i} + \sqrt[5]{1900 - 2876i} = 10$ |
| $5 + 2i$ | $\sqrt[5]{-1475 + 4282i} + \sqrt[5]{-1475 - 4282i} = 10$ |
| $5 + 3i$ | $\sqrt[5]{-6100 + 2868i} + \sqrt[5]{-6100 - 2868i} = 10$ |
| $6 + i$ | $\sqrt[5]{5646 + 6121i} + \sqrt[5]{5646 - 6121i} = 12$ |

Each was checked numerically with principal roots. A search over
$0 < |a| \le 150$ and $0 < b \le 150$ found only the first row.

### Other choices of fifth roots

Each of $a \pm bi$ has five fifth roots. The conjugate pairs $\zeta^k u$ and
$\bar\zeta^k \bar u$, with $\zeta = e^{2\pi i/5}$, give sums
$2\mathrm{Re}(\zeta^k u)$ for $k = 0, \ldots, 4$. These are the five real roots
of $t^5 - 5mt^3 + 5m^2t - 2a$.

So $a + bi = (p + qi)^5$ with $q$ too large still gives a rational sum, just
not with principal roots. For example, $(1 + i)^5 = -4 - 4i$, and the
conjugate pair $1 \pm i$ gives

$$
(1 + i) + (1 - i) = 2,
$$

but $1 + i$ has argument $\frac{\pi}{4} > \frac{\pi}{5}$. The principal roots
give $\sqrt[5]{-4 - 4i} + \sqrt[5]{-4 + 4i} \approx 2.5201$, which is
irrational. Similarly $4 + 3i$ has $\frac{3}{4} > 0.7265$, and its principal
sum is about $8.1785$ rather than $8$.

### Negative squarefree radicands

Now take $\sqrt[5]{a + \sqrt{n}} + \sqrt[5]{a - \sqrt{n}}$ with $n < 0$
squarefree, $\sqrt{n} = i\sqrt{-n}$, principal fifth roots and a rational sum.
Unlike the real case, there is a solution, but it's hard to find:

$$
\boxed{\sqrt[5]{-22434 + \sqrt{-19}} + \sqrt[5]{-22434 - \sqrt{-19}} = 12.}
$$

Here the fifth roots are $6 \pm \sqrt{-19}$.

By the same argument as above, $u = y + \sqrt{d}$ with $x = 2y$ and
$d = y^2 - m < 0$. Writing $g = x^4 - 3mx^2 + m^2$ in terms of $y$ and $d$
gives the same coefficient as in the real case,

$$
g = 5y^4 + 10y^2d + d^2,
$$

and $n = g^2d$. Since $n$ is squarefree, $g = \pm 1$ and $n = d$. Write
$e = -d > 0$. Then

$$
5y^4 - 10y^2e + e^2 = \pm 1, \qquad e = 5y^2 \pm \sqrt{20y^4 \pm 1}.
$$

**Step 1.** The sign under the square root is $+$. $20y^4 - 1$ is $3$ more than
a multiple of $4$, so it isn't a square.

**Step 2.** $z^2 = 20y^4 + 1$. This says $(z, 2y^2)$ is a solution of the Pell
equation $X^2 - 5W^2 = 1$. Its solutions are
$(9, 4), (161, 72), (2889, 1292), \ldots$, each from the previous by
$(X, W) \to (9X + 20W, 4X + 9W)$. $W = 4$ isn't twice a square, but
$W = 72 = 2 \cdot 6^2$ is, giving $y = 6$ and $z = 161$.

**Step 3.** Then $e = 180 \pm 161$, which is $19$ or $341 = 11 \cdot 31$. Both
are squarefree, so $6 \pm \sqrt{-19}$ and $6 \pm \sqrt{-341}$ are fifth roots of
$a \pm \sqrt{n}$ with $g = 1$:

$$
(6 + \sqrt{-19})^5 = -22434 + \sqrt{-19}, \qquad
(6 + \sqrt{-341})^5 = 2759646 + \sqrt{-341}.
$$

**Step 4.** The principal-root condition is $\sqrt{e} < y\tan\frac{\pi}{5}$.
For $e = 19$ it holds, only just:

$$
\frac{\sqrt{19}}{6} \approx 0.72648 < 0.72654 \approx \tan\frac{\pi}{5}.
$$

For $e = 341$ it fails, and the principal sum is about $38.833$ instead of
$12$.

None of the first 60 Pell solutions after $W = 72$ is twice a square. The
equation $z^2 = 20y^4 + 1$ has only finitely many integer solutions, by
Siegel's theorem on integer points on curves, so there are only finitely many
identities of this kind. This doc doesn't prove that $y = 6$ is the only one.
