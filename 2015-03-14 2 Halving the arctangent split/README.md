# Halving the arctangent split

Writes $\mathrm{atan2}(b, a)$ as twice another atan2, by halving each of the
two arctangents in the split $\mathrm{atan2}(b, a) = \mathrm{atan}(x) +
\mathrm{atan}(y)$ and rewriting everything in terms of $a$ and $b$.

*Xin-Xin* — handwritten notes from March 14, 2015, typed up.

This builds on
[atan2 identities](../2015-03-13%201%20atan2%20identities/README.md), and
uses its notation and its split of atan2 into two arctangents.

The original pages: [page 1](handwritten-notes-page-1.jpg) and
[page 2](handwritten-notes-page-2.jpg).

Notes added while typing up are marked **Note**. Every step below was checked
numerically at random points with [`check_identities.py`](check_identities.py).

## Halving each arctangent

Start from the sum formula:

$$
\mathrm{atan}(x) + \mathrm{atan}(y) = \mathrm{atan2}(x + y, 1 - xy)
$$

Each arctangent is twice the arctangent of a half-angle tangent, so

$$
\mathrm{atan2}(x + y, 1 - xy) =
2 \mathrm{atan}\left(\frac{x}{1 + \sqrt{1 + x^2}}\right) +
2 \mathrm{atan}\left(\frac{y}{1 + \sqrt{1 + y^2}}\right)
$$

Applying the sum formula again to the two half-angle tangents:

$$
\begin{aligned}
\mathrm{atan2}(x + y, 1 - xy)
&= 2 \mathrm{atan2}\left(\frac{x}{1 + \sqrt{1 + x^2}} + \frac{y}{1 + \sqrt{1 + y^2}},
1 - \frac{x}{1 + \sqrt{1 + x^2}} \cdot \frac{y}{1 + \sqrt{1 + y^2}}\right) \\
&= 2 \mathrm{atan2}\left(x\left(1 + \sqrt{1 + y^2}\right) + y\left(1 + \sqrt{1 + x^2}\right),
\left(1 + \sqrt{1 + x^2}\right)\left(1 + \sqrt{1 + y^2}\right) - xy\right) \\
&= 2 \mathrm{atan2}(h, k)
\end{aligned}
$$

The second step multiplies both arguments by the positive number
$(1 + \sqrt{1 + x^2})(1 + \sqrt{1 + y^2})$. Here

$$
h = x + y + x\sqrt{1 + y^2} + y\sqrt{1 + x^2}
$$

$$
k = 1 - xy + \sqrt{1 + x^2} + \sqrt{1 + y^2} + \sqrt{(1 + x^2)(1 + y^2)}
$$

## In terms of a and b

Let $x + y = b$ and $1 - xy = a$, as in the first doc. Then

$$
\begin{aligned}
b^2 &= x^2 + 2xy + y^2 \\
a^2 &= 1 - 2xy + x^2 y^2 \\
a^2 + b^2 &= 1 + x^2 + y^2 + x^2 y^2 = (1 + x^2)(1 + y^2)
\end{aligned}
$$

so

$$
\sqrt{a^2 + b^2} = \sqrt{(1 + x^2)(1 + y^2)}
$$

From the first doc,

$$
x = \frac{b + \sqrt{b^2 + 4a - 4}}{2} \qquad y = \frac{b - \sqrt{b^2 + 4a - 4}}{2}
$$

Squaring:

$$
\begin{aligned}
x^2 &= \frac{b^2 + 2b\sqrt{b^2 + 4a - 4} + b^2 + 4a - 4}{4} \\
&= \frac{2b^2 + 4a - 4 + 2b\sqrt{b^2 + 4a - 4}}{4} \\
&= \frac{b^2 + 2a - 2 + b\sqrt{b^2 + 4a - 4}}{2}
\end{aligned}
$$

$$
y^2 = \frac{b^2 + 2a - 2 - b\sqrt{b^2 + 4a - 4}}{2}
$$

So

$$
\sqrt{1 + x^2} = \sqrt{\frac{b^2 + 2a + b\sqrt{b^2 + 4a - 4}}{2}} \qquad
\sqrt{1 + y^2} = \sqrt{\frac{b^2 + 2a - b\sqrt{b^2 + 4a - 4}}{2}}
$$

## Sum and difference of the square roots

Squaring the sum and taking the square root again:

$$
\begin{aligned}
\sqrt{1 + x^2} + \sqrt{1 + y^2}
&= \sqrt{\frac{(b^2 + 2a + b\sqrt{b^2 + 4a - 4}) + (b^2 + 2a - b\sqrt{b^2 + 4a - 4})}{2} +
2\sqrt{\frac{(b^2 + 2a)^2 - b^2(b^2 + 4a - 4)}{4}}} \\
&= \sqrt{b^2 + 2a + \sqrt{b^4 + 4ab^2 + 4a^2 - b^4 - 4ab^2 + 4b^2}} \\
&= \sqrt{b^2 + 2a + \sqrt{4a^2 + 4b^2}} \\
&= \sqrt{b^2 + 2a + 2\sqrt{a^2 + b^2}}
\end{aligned}
$$

The difference works the same way, with its sign taken from the difference of
the two radicands:

$$
\begin{aligned}
\sqrt{1 + x^2} - \sqrt{1 + y^2}
&= \mathrm{sgn}\left(\frac{(b^2 + 2a + b\sqrt{b^2 + 4a - 4}) - (b^2 + 2a - b\sqrt{b^2 + 4a - 4})}{2}\right)
\sqrt{b^2 + 2a - 2\sqrt{a^2 + b^2}} \\
&= \mathrm{sgn}\left(b\sqrt{b^2 + 4a - 4}\right) \sqrt{b^2 + 2a - 2\sqrt{a^2 + b^2}} \\
&= \mathrm{sgn}(b) \sqrt{b^2 + 2a - 2\sqrt{a^2 + b^2}}
\end{aligned}
$$

**Note.** The last step drops the factor $\sqrt{b^2 + 4a - 4}$ from the sign.
When that root is zero, $x = y$ and the difference is $0$. The square root
on the right is also $0$ then, so the result still holds.

## The two arguments

The cross terms in $h$:

$$
\begin{aligned}
x\sqrt{1 + y^2} + y\sqrt{1 + x^2}
&= \frac{b + \sqrt{b^2 + 4a - 4}}{2}\sqrt{1 + y^2} +
\frac{b - \sqrt{b^2 + 4a - 4}}{2}\sqrt{1 + x^2} \\
&= \frac{b}{2}\left(\sqrt{1 + x^2} + \sqrt{1 + y^2}\right) -
\frac{\sqrt{b^2 + 4a - 4}}{2}\left(\sqrt{1 + x^2} - \sqrt{1 + y^2}\right) \\
&= \frac{b}{2}\sqrt{b^2 + 2a + 2\sqrt{a^2 + b^2}} -
\frac{\sqrt{b^2 + 4a - 4}}{2} \mathrm{sgn}(b) \sqrt{b^2 + 2a - 2\sqrt{a^2 + b^2}}
\end{aligned}
$$

Adding $x + y = b$:

$$
h = \frac{2b + b\sqrt{b^2 + 2a + 2\sqrt{a^2 + b^2}} -
\mathrm{sgn}(b)\sqrt{b^2 + 4a - 4}\sqrt{b^2 + 2a - 2\sqrt{a^2 + b^2}}}{2}
$$

and

$$
k = a + \sqrt{b^2 + 2a + 2\sqrt{a^2 + b^2}} + \sqrt{a^2 + b^2}
$$

## Result

$$
\mathrm{atan2}(b, a) = 2 \mathrm{atan2}(h, k)
$$

with $h$ and $k$ as above:

$$
\mathrm{atan2}(b, a) = 2 \mathrm{atan2}\left(
\frac{2b + bP - \mathrm{sgn}(b)\sqrt{b^2 + 4a - 4}\sqrt{b^2 + 2a - 2\sqrt{a^2 + b^2}}}{2},
a + P + \sqrt{a^2 + b^2}\right)
$$

where $P = \sqrt{b^2 + 2a + 2\sqrt{a^2 + b^2}}$. The notes write $P$ out in
full in both places.

This holds whenever $b^2 + 4a - 4 \ge 0$, which is when $x$ and $y$ are real.

## Notes

The rest of this doc was added while typing up the notes.

**When x and y aren't real.** Keep $P$ as above and write
$r = \sqrt{a^2 + b^2}$. The two
radicands in the $\mathrm{sgn}(b)$ term are related by

$$
\left(b^2 + 2a - 2r\right)\left(b^2 + 2a + 2r\right) = (b^2 + 2a)^2 - 4(a^2 + b^2) =
b^2\left(b^2 + 4a - 4\right)
$$

so for $b \ne 0$, $b^2 + 2a - 2r$ has the same sign as $b^2 + 4a - 4$. When
$b^2 + 4a - 4 < 0$, both square roots in the result are square roots of
negative numbers. Read as principal complex square roots, their product is
$i \cdot i = -1$ times the real square root of the product of the radicands.
With that reading the result holds for every $(b, a)$ except $b = 0$, $a < 0$.
There both square roots in $k$ are zero, so the right side is
$2 \mathrm{atan2}(0, 0)$.

**Removing the inner square root.** The same relation gives

$$
\sqrt{b^2 + 2a - 2r} = \frac{|b|\sqrt{b^2 + 4a - 4}}{P}
$$

when $b^2 + 4a - 4 \ge 0$, so

$$
\mathrm{sgn}(b)\sqrt{b^2 + 4a - 4}\sqrt{b^2 + 2a - 2r} = \frac{b(b^2 + 4a - 4)}{P}
$$

The complex reading above gives the same value when $b^2 + 4a - 4 < 0$. Using
$P^2 - (b^2 + 4a - 4) = 2r - 2a + 4$, the first argument becomes

$$
h = \frac{b(2P + P^2 - b^2 - 4a + 4)}{2P} = \frac{b(P + r - a + 2)}{P}
$$

and the result simplifies to

$$
\mathrm{atan2}(b, a) = 2 \mathrm{atan2}\left(\frac{b(P + r - a + 2)}{P}, a + P + r\right)
$$

with only real square roots. It holds for every $(b, a)$ except $b = 0$,
$a \le 0$.

**It's the half-angle form in disguise.** The ratio of the two arguments is

$$
\frac{h}{k} = \frac{b(P + r - a + 2)}{P(a + P + r)} = \frac{b}{a + r}
$$

because cross-multiplying leaves $(r - a + 2)(a + r) = r^2 - a^2 + 2a + 2r =
b^2 + 2a + 2r = P^2$. Both $k$ and $a + r$ are positive except when $b = 0$,
$a \le 0$, so

$$
\mathrm{atan2}(b, a) = 2 \mathrm{atan2}\left(b, a + \sqrt{a^2 + b^2}\right)
$$

which is the half-angle form from the first doc. That fits: halving
$\mathrm{atan}(x)$ and $\mathrm{atan}(y)$ separately and adding gives half of
their sum, which is half of $\mathrm{atan2}(b, a)$.
