# atan2 identities

Identities for the two-argument arctangent: half-angle forms, sums of
arctangents, and a way to split $\mathrm{atan2}(y, x)$ into a sum of two
ordinary arctangents.

*Xin-Xin* — handwritten notes from March 13, 2015, typed up.

The original pages: [page 1](handwritten-notes-page-1.jpg),
[page 2](handwritten-notes-page-2.jpg), [page 3](handwritten-notes-page-3.jpg)
and [page 4](handwritten-notes-page-4.jpg). Two close-ups of page 2 show the
halving formula more clearly: [close-up 1](handwritten-notes-page-2-closeup-1.jpg)
and [close-up 2](handwritten-notes-page-2-closeup-2.jpg).

Pages 1 and 2 list the identities. Pages 3 and 4 derive the ones that split
atan2 into two arctangents. Notes added while typing up are marked
**Correction** or **Note**. Every identity below, with its corrected
conditions, was checked numerically at 20,000 random points with
[`check_identities.py`](check_identities.py).

Throughout, $\mathrm{atan}$ is the arctangent with values in
$(-\tfrac{\pi}{2}, \tfrac{\pi}{2})$, $\mathrm{atan2}(y, x)$ is the angle of
the point $(x, y)$ in $(-\pi, \pi]$, and $\mathrm{sgn}(x)$ is $1$, $-1$ or $0$
when $x$ is positive, negative or zero.

## Definition

$$
\mathrm{atan2}(y, x) =
\begin{cases}
\mathrm{atan}\frac{y}{x}, & x > 0 \\
\mathrm{atan}\frac{y}{x} + \pi, & y \ge 0, x < 0 \\
\mathrm{atan}\frac{y}{x} - \pi, & y < 0, x < 0 \\
\tfrac{\pi}{2}, & y > 0, x = 0 \\
{-\tfrac{\pi}{2}}, & y < 0, x = 0
\end{cases}
$$

Splitting off the cases where one argument is zero:

$$
\mathrm{atan2}(y, x) =
\begin{cases}
\mathrm{atan}\frac{y}{x}, & x > 0, y \ne 0 \\
\mathrm{atan}\frac{y}{x} + \pi, & x < 0, y > 0 \\
\mathrm{atan}\frac{y}{x} - \pi, & x < 0, y < 0 \\
0, & x > 0, y = 0 \\
\pi, & x < 0, y = 0 \\
\tfrac{\pi}{2}, & x = 0, y > 0 \\
{-\tfrac{\pi}{2}}, & x = 0, y < 0
\end{cases}
$$

## Half-angle form

All but one case collapse into a single formula:

$$
\mathrm{atan2}(y, x) =
\begin{cases}
2 \mathrm{atan}\dfrac{y}{x + \sqrt{x^2 + y^2}}, & y \ne 0 \text{ or } x > 0 \\
\pi, & y = 0, x < 0
\end{cases}
$$

**Note.** This is the tangent half-angle formula. If $\theta$ is the angle of
$(x, y)$ and $r = \sqrt{x^2 + y^2}$, then
$\tan\frac{\theta}{2} = \frac{\sin\theta}{1 + \cos\theta} = \frac{y}{r + x}$.
The denominator is zero only when $y = 0$ and $x \le 0$.

Page 2 writes the same thing with atan2 on the right:

$$
\mathrm{atan2}(y, x) =
\begin{cases}
2 \mathrm{atan2}\left(y, x + \sqrt{x^2 + y^2}\right), & y \ne 0 \text{ or } x > 0 \\
\pi, & y = 0, x < 0
\end{cases}
$$

**Correction.** The notes give the first condition as $y \ne 0$ and $x > 0$
together, which leaves out points such as $x < 0$, $y > 0$ where the formula
still holds. The page 1 version above has the right condition: $y \ne 0$ or
$x > 0$.

## Sums of arctangents

$$
\mathrm{atan}(x) + \mathrm{atan}(y) = \mathrm{atan2}(x + y, 1 - xy) =
2 \mathrm{atan}\frac{x + y}{1 - xy + \sqrt{(x^2 + 1)(y^2 + 1)}}
$$

**Note.** The first equality holds for all real $x$ and $y$. The point
$(1 - xy, x + y)$ is the complex number $(1 + ix)(1 + iy)$, whose angle is the
sum of the two arctangents, and that sum stays inside $(-\pi, \pi)$. The second
equality is the half-angle form, using
$(1 - xy)^2 + (x + y)^2 = (x^2 + 1)(y^2 + 1)$.

## Arctangent of a quotient

For $x \ne 0$:

$$
\mathrm{atan}\frac{y}{x} = \mathrm{atan2}\left(\frac{y}{x}, 1\right) =
2 \mathrm{atan}\frac{y}{x + \mathrm{sgn}(x)\sqrt{x^2 + y^2}}
$$

Taking the other sign of the square root changes the result by $\pm\pi$:

$$
\mathrm{atan}\frac{y}{x} =
2 \mathrm{atan}\frac{y}{x - \mathrm{sgn}(x)\sqrt{x^2 + y^2}} +
\begin{cases}
\pi, & \frac{y}{x} > 0 \\
{-\pi}, & \frac{y}{x} < 0
\end{cases}
$$

**Note.** The second form also needs $y \ne 0$. When $y = 0$ its fraction is
$\frac{0}{0}$.

Dividing both arguments of atan2 by the same $a \ne 0$:

$$
\mathrm{atan2}\left(\frac{y}{a}, \frac{x}{a}\right) =
\begin{cases}
2 \mathrm{atan}\dfrac{y}{x + \mathrm{sgn}(a)\sqrt{x^2 + y^2}}, & y \ne 0 \text{ or } \frac{x}{a} > 0 \\
\pi, & y = 0, \frac{x}{a} < 0
\end{cases}
$$

Combining this with the sum formula, for $b_1 \ne 0$ and $b_2 \ne 0$:

$$
\mathrm{atan}\frac{a_1}{b_1} + \mathrm{atan}\frac{a_2}{b_2} =
\mathrm{atan2}\left(\frac{a_1 b_2 + a_2 b_1}{b_1 b_2}, \frac{b_1 b_2 - a_1 a_2}{b_1 b_2}\right)
$$

$$
= 2 \mathrm{atan}\frac{a_1 b_2 + a_2 b_1}{b_1 b_2 - a_1 a_2 +
\mathrm{sgn}(b_1 b_2)\sqrt{(a_1^2 + b_1^2)(a_2^2 + b_2^2)}}
$$

## Negation, doubling, sine and cosine

$$
-\mathrm{atan2}(-y, x) =
\begin{cases}
\mathrm{atan2}(y, x), & y \ne 0 \text{ or } x \ge 0 \\
{-\pi}, & y = 0, x < 0
\end{cases}
$$

$$
\mathrm{atan2}(y, x) =
\begin{cases}
-\mathrm{atan2}(-y, x), & y \ne 0 \text{ or } x \ge 0 \\
\pi, & y = 0, x < 0
\end{cases}
$$

$$
2 \mathrm{atan}(x) = \mathrm{atan2}(2x, 1 - x^2)
$$

$$
\sin(\mathrm{atan2}(y, x)) = \frac{y}{\sqrt{y^2 + x^2}} \qquad
\cos(\mathrm{atan2}(y, x)) = \frac{x}{\sqrt{y^2 + x^2}}
$$

$$
\mathrm{atan2}(y, x) = \mathrm{atan2}(ay, ax), \qquad a > 0
$$

Doubling the sum formula:

$$
2 \mathrm{atan2}(x + y, 1 - xy) =
\mathrm{atan2}(2x, 1 - x^2) + \mathrm{atan2}(2y, 1 - y^2)
$$

And a sum with the same first argument:

$$
\mathrm{atan2}(x, 1 - y) + \mathrm{atan2}(x, 1 + y) =
\mathrm{atan2}(2x, 1 - x^2 - y^2)
$$

**Note.** This holds everywhere except $x = 0$, $y = \pm 1$, where one term is
$\mathrm{atan2}(0, 0)$. As with the sum of arctangents, the right side is the
angle of the product $(1 - y + ix)(1 + y + ix)$.

## Halving

$$
\frac{1}{2} \mathrm{atan2}\left(y, \frac{x^2 - y^2}{2x}\right) =
\begin{cases}
\mathrm{atan2}(y, x), & x > 0 \\
\mathrm{atan2}\left(y, -\frac{y^2}{x}\right), & x < 0, y \ne 0 \\
\tfrac{\pi}{2}, & x < 0, y = 0
\end{cases}
$$

**Correction.** The notes have $x \ge 0$ in the first case, but the left side
divides by zero when $x = 0$. They also have no separate case for $y = 0$,
$x < 0$, where the second case gives $\mathrm{atan2}(0, 0)$.

**Note.** Why it works: for $x > 0$, multiplying both arguments by $2x$ gives
$\mathrm{atan2}(2xy, x^2 - y^2)$, which is twice the angle of $(x, y)$. For
$x < 0$ and $y > 0$, multiplying both arguments of
$\mathrm{atan2}(y, -\frac{y^2}{x})$ by $-\frac{x}{y} > 0$ gives
$\mathrm{atan2}(-x, y)$. That is the angle of $(x, y)$ minus
$\frac{\pi}{2}$, which is what halving gives here. The case $y < 0$ is the same
with $\frac{\pi}{2}$ added instead.

## Arctangents of complex conjugates

$$
\mathrm{atan}(a + bi) + \mathrm{atan}(a - bi) =
\begin{cases}
\mathrm{atan2}(a, 1 + b) + \mathrm{atan2}(a, 1 - b), & a \ne 0 \\
0, & a = 0
\end{cases}
$$

$$
= \begin{cases}
\mathrm{atan2}(2a, 1 - a^2 - b^2), & a \ne 0 \\
0, & a = 0
\end{cases}
$$

**Note.** The $a = 0$, $|b| > 1$ case lies on the branch cuts of the complex
arctangent, so its value there depends on the convention used.

## Splitting atan2 into two arctangents

These identities are derived on pages 3 and 4, below.

$$
\mathrm{atan2}(y, x) =
\mathrm{atan}\left(\frac{y + \sqrt{y^2 + 4x - 4}}{2}\right) +
\mathrm{atan}\left(\frac{y - \sqrt{y^2 + 4x - 4}}{2}\right)
$$

This holds when $y^2 + 4x - 4 \ge 0$. The notes add that it's "true for
$y^2 + 4x - 4 < 0$ as well", with complex arctangents. Then the two arguments
are complex conjugates, and the previous section applies.

**Note.** In the complex case, $y = 0$ with $x < 0$ puts both arguments on the
branch cuts, so there the result depends on the convention.

Rewritten with real functions only:

$$
\mathrm{atan2}(y, x) =
\mathrm{atan2}\left(\frac{y}{2}, \frac{2 + \sqrt{4 - 4x - y^2}}{2}\right) +
\mathrm{atan2}\left(\frac{y}{2}, \frac{2 - \sqrt{4 - 4x - y^2}}{2}\right),
\qquad 4 - 4x - y^2 \ge 0
$$

$$
\begin{aligned}
\mathrm{atan2}(y, x) = {} & \frac{1}{2} \mathrm{atan2}\left(y + \sqrt{y^2 + 4x - 4},
\frac{4 - y^2 - 2x - y\sqrt{y^2 + 4x - 4}}{2}\right) + {} \\
& \frac{1}{2} \mathrm{atan2}\left(y - \sqrt{y^2 + 4x - 4},
\frac{4 - y^2 - 2x + y\sqrt{y^2 + 4x - 4}}{2}\right),
\qquad 4 - 4x - y^2 \le 0
\end{aligned}
$$

**Note.** Both forms hold wherever $\mathrm{atan2}(y, x)$ is defined. In the
first form a term becomes $\mathrm{atan2}(0, 0)$ only when $y = 0$ and
$\sqrt{4 - 4x - y^2} = 2$, which means $(x, y) = (0, 0)$.

## Derivation of the arctangent split (page 3)

Start from the sum formula:

$$
\mathrm{atan}(x) + \mathrm{atan}(y) = \mathrm{atan2}(x + y, 1 - xy)
$$

Let $x + y = b$ and $1 - xy = a$. Then $y = b - x$, so

$$
1 - x(b - x) = a
$$

$$
x^2 - bx + 1 - a = 0
$$

$$
x = \frac{b \pm \sqrt{b^2 - 4(1 - a)}}{2} = \frac{b \pm \sqrt{b^2 + 4a - 4}}{2}
$$

and $y = b - x$ takes the other sign. Taking $+$ for $x$ and $-$ for $y$:

$$
\mathrm{atan2}(b, a) =
\mathrm{atan}\left(\frac{b + \sqrt{b^2 + 4a - 4}}{2}\right) +
\mathrm{atan}\left(\frac{b - \sqrt{b^2 + 4a - 4}}{2}\right)
$$

Next, double both sides using $2 \mathrm{atan}(x) = \mathrm{atan2}(2x, 1 - x^2)$:

$$
2 \mathrm{atan2}(x + y, 1 - xy) =
\mathrm{atan2}(2x, 1 - x^2) + \mathrm{atan2}(2y, 1 - y^2)
$$

$$
\mathrm{atan2}(x + y, 1 - xy) =
\frac{1}{2} \mathrm{atan2}(2x, 1 - x^2) + \frac{1}{2} \mathrm{atan2}(2y, 1 - y^2)
$$

With $x$ and $y$ as above, $2x$ and $2y$ are $b \pm \sqrt{b^2 + 4a - 4}$, and

$$
\begin{aligned}
1 - x^2 \text{ or } 1 - y^2
&= 1 - \frac{b^2 \pm 2b\sqrt{b^2 + 4a - 4} + b^2 + 4a - 4}{4} \\
&= 1 - \frac{2b^2 + 4a - 4 \pm 2b\sqrt{b^2 + 4a - 4}}{4} \\
&= \frac{4 - 2b^2 - 4a + 4 \mp 2b\sqrt{b^2 + 4a - 4}}{4} \\
&= \frac{4 - b^2 - 2a \mp b\sqrt{b^2 + 4a - 4}}{2}
\end{aligned}
$$

So

$$
\begin{aligned}
\mathrm{atan2}(b, a) = {} & \frac{1}{2} \mathrm{atan2}\left(b + \sqrt{b^2 + 4a - 4},
\frac{4 - b^2 - 2a - b\sqrt{b^2 + 4a - 4}}{2}\right) + {} \\
& \frac{1}{2} \mathrm{atan2}\left(b - \sqrt{b^2 + 4a - 4},
\frac{4 - b^2 - 2a + b\sqrt{b^2 + 4a - 4}}{2}\right)
\end{aligned}
$$

## Derivation of the real form (page 4)

The angle-sum rule suggests (the notes mark this step with a question mark)

$$
\mathrm{atan2}(a, 1 + b) + \mathrm{atan2}(a, 1 - b) =
\mathrm{atan2}\left(a(1 - b) + a(1 + b), (1 + b)(1 - b) - a \cdot a\right)
$$

which simplifies to

$$
\mathrm{atan2}(a, 1 + b) + \mathrm{atan2}(a, 1 - b) = \mathrm{atan2}(2a, 1 - a^2 - b^2)
$$

Let $y = 2a$ and $x = 1 - a^2 - b^2$. Then $a = \frac{y}{2}$ and
$x = 1 - \frac{y^2}{4} - b^2$, so

$$
b^2 = 1 - \frac{y^2}{4} - x = \frac{4 - 4x - y^2}{4}
$$

$$
b = \frac{\sqrt{4 - 4x - y^2}}{2}
$$

Substituting back:

$$
\mathrm{atan2}(y, x) =
\mathrm{atan2}\left(\frac{y}{2}, \frac{2 + \sqrt{4 - 4x - y^2}}{2}\right) +
\mathrm{atan2}\left(\frac{y}{2}, \frac{2 - \sqrt{4 - 4x - y^2}}{2}\right)
$$

Next: [Halving the arctangent split](../2015-03-14%202%20Halving%20the%20arctangent%20split/README.md).
