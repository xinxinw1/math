# Cubic formula identities

A generator of numbers of the form

$$\sqrt[3]{a + b\sqrt{c}} + \sqrt[3]{a - b\sqrt{c}}$$

that equal a chosen number $x$.

*Xin-Xin*

## Idea

Build a cubic that has $x$ as a root, solve it with Cardano's formula, and set
the result equal to $x$.

## Building the cubic

Start from

$$(t - x)(t^2 + xt + y) = 0.$$

Expanding:

$$t^3 + xt^2 + yt - xt^2 - x^2t - xy = 0$$

$$t^3 + (y - x^2)t - xy = 0.$$

This is a depressed cubic $t^3 + pt + q = 0$ with

$$p = y - x^2, \qquad q = -xy.$$

## The discriminant term

Cardano's formula needs $\dfrac{q^2}{4} + \dfrac{p^3}{27}$:

$$
\begin{aligned}
\frac{q^2}{4} + \frac{p^3}{27}
&= \frac{y^2x^2}{4} + \frac{y^3 - 3y^2x^2 + 3yx^4 - x^6}{27} \\
&= \frac{27y^2x^2 + 4y^3 - 12y^2x^2 + 12yx^4 - 4x^6}{108} \\
&= \frac{4y^3 + 15y^2x^2 + 12yx^4 - 4x^6}{108}.
\end{aligned}
$$

To factor the numerator, split $15 = 7 + 8$ and $12 = -2 + 14$:

$$
\begin{aligned}
&= \frac{4y^3 + 7y^2x^2 - 2yx^4 + 8y^2x^2 + 14yx^4 - 4x^6}{108} \\
&= \frac{y(4y^2 + 7yx^2 - 2x^4) + 2x^2(4y^2 + 7yx^2 - 2x^4)}{108} \\
&= \frac{(y + 2x^2)(4y^2 + 7yx^2 - 2x^4)}{108} \\
&= \frac{(y + 2x^2)(4y^2 + 8yx^2 - yx^2 - 2x^4)}{108} \\
&= \frac{(y + 2x^2)\big(4y(y + 2x^2) - x^2(y + 2x^2)\big)}{108} \\
&= \frac{(y + 2x^2)^2(4y - x^2)}{108}.
\end{aligned}
$$

## Applying Cardano's formula

With $-\dfrac{q}{2} = \dfrac{xy}{2}$ and $\sqrt{108} = 6\sqrt{3}$:

$$
\begin{aligned}
u &= \sqrt[3]{\frac{xy}{2} + \sqrt{\frac{(y + 2x^2)^2(4y - x^2)}{108}}} \\
&= \sqrt[3]{\frac{xy}{2} + \frac{y + 2x^2}{6}\sqrt{\frac{4y - x^2}{3}}} \\
&= \sqrt[3]{\frac{xy}{2} + \frac{y + 2x^2}{18}\sqrt{3(4y - x^2)}}
\end{aligned}
$$

and

$$
\begin{aligned}
v &= \sqrt[3]{\frac{xy}{2} - \frac{y + 2x^2}{6}\sqrt{\frac{4y - x^2}{3}}} \\
&= \sqrt[3]{\frac{xy}{2} - \frac{y + 2x^2}{18}\sqrt{3(4y - x^2)}}.
\end{aligned}
$$

Then $t = u + v = x$.

## Result

$$
\sqrt[3]{\frac{xy}{2} + \frac{y + 2x^2}{6}\sqrt{\frac{4y - x^2}{3}}} +
\sqrt[3]{\frac{xy}{2} - \frac{y + 2x^2}{6}\sqrt{\frac{4y - x^2}{3}}} = x
$$

or equivalently

$$
\boxed{\sqrt[3]{\frac{xy}{2} + \frac{y + 2x^2}{18}\sqrt{3(4y - x^2)}} +
\sqrt[3]{\frac{xy}{2} - \frac{y + 2x^2}{18}\sqrt{3(4y - x^2)}} = x}
$$

So in the form $\sqrt[3]{a + b\sqrt{c}} + \sqrt[3]{a - b\sqrt{c}}$:

$$a = \frac{xy}{2}, \qquad b = \frac{y + 2x^2}{18}, \qquad c = 3(4y - x^2).$$

## When it holds over the reals

The identity holds with real cube roots when $4y > x^2$. Then
$t^2 + xt + y$ has no real roots, so $x$ is the only real root of the cubic,
and Cardano's formula with real cube roots gives exactly that root.

If $4y < x^2$, the square root is of a negative number (the *casus
irreducibilis*), and the formula needs complex cube roots.

## Examples

| $x$ | $y$ | Identity |
|---|---|---|
| 1 | 4 | $\sqrt[3]{2 + \sqrt{5}} + \sqrt[3]{2 - \sqrt{5}} = 1$ |
| 1 | 10 | $\sqrt[3]{5 + 2\sqrt{13}} + \sqrt[3]{5 - 2\sqrt{13}} = 1$ |
| 1 | 34 | $\sqrt[3]{17 + 18\sqrt{5}} + \sqrt[3]{17 - 18\sqrt{5}} = 1$ |
| 2 | 7 | $\sqrt[3]{7 + 5\sqrt{2}} + \sqrt[3]{7 - 5\sqrt{2}} = 2$ |
| 2 | 10 | $\sqrt[3]{10 + 6\sqrt{3}} + \sqrt[3]{10 - 6\sqrt{3}} = 2$ |
| 3 | 6 | $\sqrt[3]{9 + 4\sqrt{5}} + \sqrt[3]{9 - 4\sqrt{5}} = 3$ |
| 4 | 10 | $\sqrt[3]{20 + 14\sqrt{2}} + \sqrt[3]{20 - 14\sqrt{2}} = 4$ |

The formula's $b$ and $c$ often simplify. In the first example it gives
$b = \tfrac{1}{3}$ and $c = 45$, and $\tfrac{1}{3}\sqrt{45} = \sqrt{5}$.

When $3(4y - x^2)$ is a perfect square, the identity is trivial. For example,
$x = 1,\ y = 1$ gives $\sqrt[3]{1} + \sqrt[3]{0} = 1$.

Replacing $x$ with $kx$ and $y$ with $k^2y$ multiplies $a$ and $b\sqrt{c}$ by
$k^3$, so for example $x = 2,\ y = 16$ gives $8$ times the first identity.

## Integer identities

A cleaner way to get identities with integer coefficients is to parametrize by
the product of the two cube roots instead of by $y$.

Let $u$ and $v$ be the two cube roots, so $u + v = x$. In Cardano's formula,
$uv = -\dfrac{p}{3} = \dfrac{x^2 - y}{3}$. Call this $m$, so

$$y = x^2 - 3m.$$

Substituting into the generator, $y + 2x^2 = 3(x^2 - m)$ and
$4y - x^2 = 3(x^2 - 4m)$, so

$$a = \frac{xy}{2} = \frac{x(x^2 - 3m)}{2}, \qquad
b\sqrt{c} = \sqrt{\frac{(y + 2x^2)^2(4y - x^2)}{108}}
= \frac{x^2 - m}{2}\sqrt{x^2 - 4m}.$$

This gives

$$
\sqrt[3]{\frac{x(x^2 - 3m)}{2} + \frac{x^2 - m}{2}\sqrt{x^2 - 4m}} +
\sqrt[3]{\frac{x(x^2 - 3m)}{2} - \frac{x^2 - m}{2}\sqrt{x^2 - 4m}} = x
$$

for any $x$ and $m$ with $x^2 > 4m$ (equivalent to $4y > x^2$).

The coefficients are integers when $x$ and $m$ are integers and either

- $x$ and $m$ are both odd, so $x^2 - 3m$ and $x^2 - m$ are even, or
- $x$ is even, so $x^2 - 3m$ is even and $x^2 - 4m$ is divisible by $4$, which
  lets $\tfrac{1}{2}\sqrt{x^2 - 4m} = \sqrt{\tfrac{x^2 - 4m}{4}}$.

The identity is nontrivial when $x^2 - 4m$ is not a perfect square.

| $x$ | $m$ | Identity |
|---|---|---|
| 1 | $-1$ | $\sqrt[3]{2 + \sqrt{5}} + \sqrt[3]{2 - \sqrt{5}} = 1$ |
| 1 | $-3$ | $\sqrt[3]{5 + 2\sqrt{13}} + \sqrt[3]{5 - 2\sqrt{13}} = 1$ |
| 2 | $-1$ | $\sqrt[3]{7 + 5\sqrt{2}} + \sqrt[3]{7 - 5\sqrt{2}} = 2$ |
| 3 | $1$ | $\sqrt[3]{9 + 4\sqrt{5}} + \sqrt[3]{9 - 4\sqrt{5}} = 3$ |

### Why these cube roots simplify

Since $u + v = x$ and $uv = m$, the cube roots are the roots of
$s^2 - xs + m = 0$:

$$u = \frac{x + \sqrt{x^2 - 4m}}{2}, \qquad v = \frac{x - \sqrt{x^2 - 4m}}{2}.$$

So every identity from the generator is a perfect cube in disguise. For example,
with $\varphi = \tfrac{1 + \sqrt{5}}{2}$ the golden ratio:

$$\varphi^3 = 2 + \sqrt{5}, \qquad (1 + \sqrt{2})^3 = 7 + 5\sqrt{2}, \qquad
\varphi^6 = 9 + 4\sqrt{5}.$$

## Complex cube roots

When $x^2 < 4m$ (equivalently $4y < x^2$), the square root $\sqrt{x^2 - 4m}$ is
imaginary. The cubic then has three real roots, but Cardano's formula can only
reach them through complex numbers. This is the *casus irreducibilis*.

The integer formula still works. Writing $\sqrt{x^2 - 4m} = i\sqrt{4m - x^2}$,

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

### Generating $\sqrt[3]{a + bi} + \sqrt[3]{a - bi} = x$

To get identities with integers $a$ and $b$ and no other radicals, take a
Gaussian integer $u = p + qi$ with $p > 0$ and $0 < q < p\sqrt{3}$. Then

$$a + bi = (p + qi)^3, \qquad a = p(p^2 - 3q^2), \qquad b = q(3p^2 - q^2),$$

and

$$\sqrt[3]{a + bi} + \sqrt[3]{a - bi} = 2p.$$

In terms of the integer formula, $x = 2p$ and $m = p^2 + q^2$, and the
condition $q < p\sqrt{3}$ is the principal-root condition $m < x^2$ from above.
Since $\sqrt{3}$ is irrational, $p^2 \ne 3q^2$, so $a$ is never $0$.

These are all such identities with integers $a$, $b$ and $x$ (with $b \ne 0$).
The cube root $u = \tfrac{x + ik}{2}$, where $k = \sqrt{4m - x^2}$, has
$\mathrm{Im}(u^3) = \tfrac{k(3x^2 - k^2)}{8}$. From $x^3 = 2a + 3mx$,
$m = \tfrac{x^3 - 2a}{3x}$ is rational, so $k^2$ is rational and $b \ne 0$ forces $k$ to be rational and $u$ to lie in $\mathbb{Q}(i)$. Being
a cube root of the Gaussian integer $a + bi$, $u$ is an algebraic integer, so
$u \in \mathbb{Z}[i]$. In particular $x$ is always even.

Taking $\gcd(p, q) = 1$ skips scaled copies, since $u \to ku$ multiplies $a$
and $b$ by $k^3$ and $x$ by $k$.

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
