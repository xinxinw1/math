# Discrete function identities

Formulas for $\max$, $\min$ and a three-way "if" function that use only
arithmetic, absolute value and sign, with no case splits.

*Xin-Xin* — handwritten notes from March 15, 2015, typed up.

The original pages: [page 1](handwritten-notes-page-1.jpg) and
[page 2](handwritten-notes-page-2.jpg).

Throughout, $\mathrm{sgn}(x)$ is $1$, $-1$ or $0$ when $x$ is positive,
negative or zero.

## Max

The definition:

$$
\max(x, y) =
\begin{cases}
x, & x \ge y \\
y, & x < y
\end{cases}
$$

Comparing with zero has a simple formula, because $|x| = x$ when $x \ge 0$ and
$|x| = -x$ when $x < 0$:

$$
\max(x, 0) = \frac{x + |x|}{2} =
\begin{cases}
x, & x \ge 0 \\
0, & x < 0
\end{cases}
$$

Adding $y$ to both sides:

$$
\max(x, 0) + y =
\begin{cases}
x + y, & x \ge 0 \\
y, & x < 0
\end{cases}
$$

Now replace $x$ with $x - y$:

$$
\max(x - y, 0) + y =
\begin{cases}
x, & x - y \ge 0 \\
y, & x - y < 0
\end{cases} =
\begin{cases}
x, & x \ge y \\
y, & x < y
\end{cases} =
\max(x, y)
$$

So

$$
\max(x, y) = \frac{x - y + |x - y|}{2} + y = \frac{x + y + |x - y|}{2}
$$

## Shifting both arguments

Adding the same $a$ to both arguments doesn't change which one is larger:

$$
\begin{aligned}
\max(x + a, y + a) &=
\begin{cases}
x + a, & x + a \ge y + a \\
y + a, & x + a < y + a
\end{cases} \\
&=
\begin{cases}
x + a, & x \ge y \\
y + a, & x < y
\end{cases} \\
&=
\begin{cases}
x, & x \ge y \\
y, & x < y
\end{cases} + a \\
&= \max(x, y) + a
\end{aligned}
$$

so $\max(x, y) = \max(x + a, y + a) - a$.

## An "if" function

Define a function that picks $y$ or $z$ by the sign of $x$, and averages them
when $x = 0$:

$$
\mathrm{if}(x, y, z) =
\begin{cases}
y, & x > 0 \\
z, & x < 0 \\
\dfrac{y + z}{2}, & x = 0
\end{cases}
$$

To get a formula for it, start from a scaled max:

$$
z \max(x, y) =
\begin{cases}
xz, & x \ge y \\
yz, & x < y
\end{cases} =
\begin{cases}
xz, & x - y \ge 0 \\
yz, & x - y < 0
\end{cases}
$$

The condition depends on $x - y$ and the results are $xz$ and $yz$, so let

$$
a = x - y, \qquad b = xz, \qquad c = yz
$$

and solve for $x$, $y$ and $z$ in terms of $a$, $b$ and $c$. First
$az = xz - yz = b - c$, so

$$
z = \frac{b - c}{a}, \qquad
x = \frac{b}{z} = \frac{ab}{b - c}, \qquad
y = \frac{c}{z} = \frac{ac}{b - c}
$$

This needs $a \ne 0$ and $b \ne c$. Substituting, for $a \ne 0$:

$$
\frac{b - c}{a} \max\left(\frac{ab}{b - c}, \frac{ac}{b - c}\right) =
\begin{cases}
b, & a > 0 \\
c, & a < 0
\end{cases} =
\mathrm{if}(a, b, c)
$$

Using the formula for $\max$ from above:

$$
\mathrm{if}(a, b, c) =
\frac{b - c}{a} \cdot
\frac{1}{2} \left( \frac{ab}{b - c} + \frac{ac}{b - c} +
\left| \frac{ab}{b - c} - \frac{ac}{b - c} \right| \right)
$$

Multiplying the factor $\frac{b - c}{a}$ into the bracket, and using
$\frac{ab - ac}{b - c} = a$:

$$
\begin{aligned}
\mathrm{if}(a, b, c) &=
\frac{1}{2} \left( b + c + \frac{b - c}{a} \left| \frac{ab - ac}{b - c} \right| \right) \\
&= \frac{1}{2} \left( b + c + \frac{|a|}{a} (b - c) \right) \\
&= \frac{b + c + \mathrm{sgn}(a)(b - c)}{2}
\end{aligned}
$$

Renaming the variables back:

$$
\boxed{\mathrm{if}(x, y, z) = \frac{y + z + \mathrm{sgn}(x)(y - z)}{2}}
$$

The derivation assumed $x \ne 0$ and $y \ne z$, but the final formula holds
for all inputs. When $y = z$ it gives $y$, which is correct whichever branch
is taken. When $x = 0$, $\mathrm{sgn}(0) = 0$ gives $\frac{y + z}{2}$, which
is the value chosen in the definition.

## Min

*Page 2*

The minimum picks $y$ when $x > y$ and $x$ when $x < y$. When $x = y$ the
average $\frac{x + y}{2}$ is just $x$, so

$$
\begin{aligned}
\min(x, y) &= \mathrm{if}(x - y, y, x) \\
&= \frac{y + x + \mathrm{sgn}(x - y)(y - x)}{2} \\
&= \frac{y + x - \mathrm{sgn}(x - y)(x - y)}{2} \\
&= \frac{x + y - |x - y|}{2}
\end{aligned}
$$

using $\mathrm{sgn}(t) \cdot t = |t|$ in the last step.
