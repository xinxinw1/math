# Cubic formula identities

A generator of numbers of the form

$$\sqrt[3]{a + b\sqrt{c}} + \sqrt[3]{a - b\sqrt{c}}$$

that equal a chosen number $x$.

*Xin-Xin*

The derivation below is typed up from handwritten notes:
[page 1](handwritten-notes-page-1.jpg) and
[page 2](handwritten-notes-page-2.jpg).

## Building the cubic

Start from

$$(t - x)(t^2 + xt + y) = 0.$$

Expanding:

$$t^3 + xt^2 + yt - xt^2 - x^2t - xy = 0$$

$$t^3 + (y - x^2)t - xy = 0.$$

So

$$p = y - x^2, \qquad q = -xy.$$

## The discriminant term

$$
\begin{aligned}
\frac{q^2}{4} + \frac{p^3}{27}
&= \frac{y^2x^2}{4} + \frac{y^3 - 3y^2x^2 + 3yx^4 - x^6}{27} \\
&= \frac{27y^2x^2 + 4y^3 - 12y^2x^2 + 12yx^4 - 4x^6}{108} \\
&= \frac{4y^3 + 15y^2x^2 + 12yx^4 - 4x^6}{108} \\
&= \frac{4y^3 + 7y^2x^2 - 2yx^4 + 8y^2x^2 + 14yx^4 - 4x^6}{108} \\
&= \frac{y(4y^2 + 7yx^2 - 2x^4) + 2x^2(4y^2 + 7yx^2 - 2x^4)}{108} \\
&= \frac{(y + 2x^2)(4y^2 + 7yx^2 - 2x^4)}{108} \\
&= \frac{(y + 2x^2)(4y^2 + 8yx^2 - yx^2 - 2x^4)}{108} \\
&= \frac{(y + 2x^2)\big(4y(y + 2x^2) - x^2(y + 2x^2)\big)}{108} \\
&= \frac{(y + 2x^2)^2(4y - x^2)}{108}.
\end{aligned}
$$

## Applying Cardano's formula

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
\sqrt[3]{\frac{xy}{2} + \frac{y + 2x^2}{18}\sqrt{3(4y - x^2)}} +
\sqrt[3]{\frac{xy}{2} - \frac{y + 2x^2}{18}\sqrt{3(4y - x^2)}} = x
$$

The handwritten version of this last line has $+$ in the second cube root, a
slip for the $-$ in $v$ above.

## Follow-up

[Classifying cubic formula identities](../2026-11-01%20Classifying%20cubic%20formula%20identities/README.md)
rewrites the generator with integer coefficients, proves that it gives every
identity of this form, and works out the squarefree and complex cases, with a
Lean proof.
