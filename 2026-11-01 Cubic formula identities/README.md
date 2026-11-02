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

$$t^3 + (y - x^2)\,t - xy = 0.$$

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
\sqrt[3]{\frac{xy}{2} + \frac{y + 2x^2}{6}\sqrt{\frac{4y - x^2}{3}}}
+ \sqrt[3]{\frac{xy}{2} - \frac{y + 2x^2}{6}\sqrt{\frac{4y - x^2}{3}}} = x
$$

or equivalently

$$
\boxed{\sqrt[3]{\frac{xy}{2} + \frac{y + 2x^2}{18}\sqrt{3(4y - x^2)}}
+ \sqrt[3]{\frac{xy}{2} - \frac{y + 2x^2}{18}\sqrt{3(4y - x^2)}} = x}
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
| 1 | 2 | $\sqrt[3]{1 + \tfrac{2}{9}\sqrt{21}} + \sqrt[3]{1 - \tfrac{2}{9}\sqrt{21}} = 1$ |
| 2 | 2 | $\sqrt[3]{2 + \tfrac{10}{9}\sqrt{3}} + \sqrt[3]{2 - \tfrac{10}{9}\sqrt{3}} = 2$ |

When $3(4y - x^2)$ is a perfect square, the identity is trivial. For example,
$x = 1,\ y = 1$ gives $\sqrt[3]{1} + \sqrt[3]{0} = 1$.
