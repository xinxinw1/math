# Denesting square roots

A formula that rewrites $\sqrt{x \pm \sqrt{y}}$ as a sum or difference of two
square roots, as in

$$
\sqrt{3 + \sqrt{8}} = \sqrt{2} + 1.
$$

*Xin-Xin* — handwritten notes from March 15, 2015, typed up.

The original page: [page 1](handwritten-notes-page-1.jpg).

## Idea

Look for numbers $a$ and $b$ with $\sqrt{x + \sqrt{y}} = \sqrt{a} + \sqrt{b}$.
Squaring the right-hand side:

$$
\sqrt{x + \sqrt{y}} =
\sqrt{(\sqrt{a} + \sqrt{b})^2} =
\sqrt{a + 2\sqrt{ab} + b} =
\sqrt{a + b + \sqrt{4ab}}
$$

and in the same way for the minus sign:

$$
\sqrt{x - \sqrt{y}} =
\sqrt{(\sqrt{a} - \sqrt{b})^2} =
\sqrt{a - 2\sqrt{ab} + b} =
\sqrt{a + b - \sqrt{4ab}}
$$

So it's enough to have

$$
x = a + b \qquad (1)
$$

$$
y = 4ab \qquad (2)
$$

## Solving for a and b

From (1),

$$
b = x - a. \qquad (3)
$$

Substituting (3) into (2):

$$
\begin{aligned}
y &= 4a(x - a) \\
&= 4ax - 4a^2
\end{aligned}
$$

so $a$ is a root of a quadratic:

$$
\begin{aligned}
4a^2 - 4ax + y &= 0 \\
a^2 - ax + \tfrac14 y &= 0 \\
a &= \frac{x \pm \sqrt{x^2 - y}}{2}
\end{aligned}
$$

Then from (3):

$$
\begin{aligned}
b &= x - a \\
&= \frac{2x - (x \pm \sqrt{x^2 - y})}{2} \\
&= \frac{x \mp \sqrt{x^2 - y}}{2}
\end{aligned}
$$

The two signs just swap $a$ and $b$. Take the plus sign for $a$:

$$
a = \frac{x + \sqrt{x^2 - y}}{2}, \qquad b = \frac{x - \sqrt{x^2 - y}}{2}
$$

## Result

$$
\sqrt{x \pm \sqrt{y}} =
\sqrt{\frac{x + \sqrt{x^2 - y}}{2}} \pm
\sqrt{\frac{x - \sqrt{x^2 - y}}{2}}
$$

or, taking out the factor $\frac{1}{\sqrt{2}} = \frac{\sqrt{2}}{2}$,

$$
\sqrt{x \pm \sqrt{y}} =
\frac{\sqrt{2}}{2}\left(\sqrt{x + \sqrt{x^2 - y}} \pm \sqrt{x - \sqrt{x^2 - y}}\right)
$$

## When it applies

For real numbers, the formula holds when $y \ge 0$ and $x \ge \sqrt{y}$. Then
$x^2 \ge y$, so every square root in it is real, and $a \ge b \ge 0$.

Choosing the plus sign for $a$ is what makes the minus case work:
$\sqrt{(\sqrt{a} - \sqrt{b})^2}$ equals $\sqrt{a} - \sqrt{b}$ only when
$a \ge b$. Otherwise it is $\sqrt{b} - \sqrt{a}$.

The formula is always true, but it only removes the nesting when $x^2 - y$ is
a perfect square. Otherwise $a$ and $b$ still contain $\sqrt{x^2 - y}$.

## Examples

With $x = 3$ and $y = 8$, $x^2 - y = 1$, so $a = 2$ and $b = 1$:

$$
\sqrt{3 + \sqrt{8}} = \sqrt{2} + 1
$$

With $x = 5$ and $y = 24$, $x^2 - y = 1$, so $a = 3$ and $b = 2$:

$$
\sqrt{5 - \sqrt{24}} = \sqrt{3} - \sqrt{2}
$$
